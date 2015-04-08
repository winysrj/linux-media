Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52204 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbbDHUoN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 16:44:13 -0400
Date: Wed, 8 Apr 2015 17:43:12 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Brendan McGrath <redmcg@redmandi.dyndns.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4] [media] saa7164: use an MSI interrupt when available
Message-ID: <20150408174312.317c7823@recife.lan>
In-Reply-To: <1426303659-4937-1-git-send-email-redmcg@redmandi.dyndns.org>
References: <1425168893-5251-1-git-send-email-redmcg@redmandi.dyndns.org>
	<1426303659-4937-1-git-send-email-redmcg@redmandi.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brendan,

The idea is good, 
Some comments bellow.

Em Sat, 14 Mar 2015 14:27:39 +1100
Brendan McGrath <redmcg@redmandi.dyndns.org> escreveu:

> Enhances driver to use an MSI interrupt when available.
> 
> Adds the module option 'enable_msi' (type bool) which by default is
> enabled. Can be set to 'N' to disable.
> 
> Fixes (or can reduce the occurrence of) a crash which is most commonly
> reported when both digital tuners of the saa7164 chip is in use. A reported example can
> be found here:
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/83948
> 
> Reviewed-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Brendan McGrath <redmcg@redmandi.dyndns.org>
> ---
> Changes since v3:
>   - fixes a conflict with a commit (3f845f3c4cf4) made to the media_tree after v3 was created (only the unified context has been changed)
>   - corrected comments to reflect that the reported incident occured more commonly when multiple tuners were in use (not multiple saa7164 chips as previously stated)
> 
> 
>  drivers/media/pci/saa7164/saa7164-core.c | 40 ++++++++++++++++++++++++++++++--
>  drivers/media/pci/saa7164/saa7164.h      |  1 +
>  2 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
> index 9cf3c6c..7635598 100644
> --- a/drivers/media/pci/saa7164/saa7164-core.c
> +++ b/drivers/media/pci/saa7164/saa7164-core.c
> @@ -85,6 +85,11 @@ module_param(guard_checking, int, 0644);
>  MODULE_PARM_DESC(guard_checking,
>  	"enable dma sanity checking for buffer overruns");
>  
> +static bool enable_msi = true;
> +module_param(enable_msi, bool, 0444);
> +MODULE_PARM_DESC(enable_msi,
> +		"enable the use of an msi interrupt if available");
> +
>  static unsigned int saa7164_devcount;
>  
>  static DEFINE_MUTEX(devlist);
> @@ -1230,8 +1235,34 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
>  		goto fail_irq;
>  	}
>  
> -	err = request_irq(pci_dev->irq, saa7164_irq,
> -		IRQF_SHARED, dev->name, dev);
> +	/* irq bit */
> +	if (enable_msi)
> +		err = pci_enable_msi(pci_dev);

It is worth printing a warning about that.

> +
> +	if (!err && enable_msi) {
> +		/* no error - so request an msi interrupt */
> +		err = request_irq(pci_dev->irq, saa7164_irq, 0,
> +				  dev->name, dev);
> +
> +		if (err) {
> +			/* fall back to legacy interrupt */
> +			printk(KERN_ERR "%s() Failed to get an MSI interrupt."
> +			       " Falling back to a shared IRQ\n", __func__);
> +			pci_disable_msi(pci_dev);
> +		} else {
> +			dev->msi = true;
> +		}
> +	}

It would be better to join this if with the next one, in order
to make clear that both belong to the enable_msi logic. Something like:

static bool saa7164_enable_msi(struct device *pci_dev)
{
	if (!enable_msi)
		return false;

	err = pci_enable_msi(pci_dev);
	if (err) {
		printf(KERN_ERR "%s() Failed to enable MSI"
		       " Falling back to a shared IRQ\n", __func__);
		return false;
	}
	err = request_irq(pci_dev->irq, saa7164_irq, 0,
			  dev->name, dev);
	if (err) {
		printk(KERN_ERR "%s() Failed to get an MSI interrupt."
		       " Falling back to a shared IRQ\n", __func__);
		pci_disable_msi(pci_dev);
		return false;
	}
	return true;
}

Then, at the probe function, you could simply do:

	if (saa7164_enable_msi(pci_dev)) {
		dev->msi = true;
	} else {
		/* SOME_FALLBACK_CODE */
	}

The probe function is already complex enough. Breaking it into small
inlined functions makes easier to review. The removal of the if's
is an extra bonus, as the code size will likely be a little bit smaller.

> +
> +	if ((!enable_msi) || err) {
> +		dev->msi = false;

No need, as dev was initialized with kzalloc(), with zeroes all fields.

Also, you can simplify the "if" clause to:

	if (!dev->msi) {

That makes clearer that the code below is to be used when MSI is not
enabled or not initialized properly.

> +		/* if we have an error (i.e. we don't have an interrupt)
> +			 or msi is not enabled - fallback to shared interrupt */
> +
> +		err = request_irq(pci_dev->irq, saa7164_irq,
> +				  IRQF_SHARED, dev->name, dev);
> +	}
> +
>  	if (err < 0) {
>  		printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
>  			pci_dev->irq);
> @@ -1439,6 +1470,11 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
>  	/* unregister stuff */
>  	free_irq(pci_dev->irq, dev);
>  
> +	if (dev->msi) {
> +		pci_disable_msi(pci_dev);
> +		dev->msi = false;
> +	}
> +
>  	pci_disable_device(pci_dev);
>  
>  	mutex_lock(&devlist);
> diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
> index cd1a07c..6df4b252 100644
> --- a/drivers/media/pci/saa7164/saa7164.h
> +++ b/drivers/media/pci/saa7164/saa7164.h
> @@ -459,6 +459,7 @@ struct saa7164_dev {
>  	/* Interrupt status and ack registers */
>  	u32 int_status;
>  	u32 int_ack;
> +	u32 msi;

Should be bool instead of u32.

>  
>  	struct cmd			cmds[SAA_CMD_MAX_MSG_UNITS];
>  	struct mutex			lock;
