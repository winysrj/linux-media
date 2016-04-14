Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60586 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbcDNVJI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 17:09:08 -0400
Date: Thu, 14 Apr 2016 18:08:58 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: nenggun.kim@samsung.com, akpm@linux-foundation.org,
	jh1009.sung@samsung.com, inki.dae@samsung.com, arnd@arndb.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: saa7134 fix media_dev alloc error path to not
 free when alloc fails
Message-ID: <20160414180858.43c8620b@recife.lan>
In-Reply-To: <1460651480-6935-1-git-send-email-shuahkh@osg.samsung.com>
References: <1460651480-6935-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Apr 2016 10:31:20 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> media_dev alloc error path does kfree when alloc fails. Fix it to not call
> kfree when media_dev alloc fails.

No need. kfree(NULL) is OK.

Adding a label inside a conditional block is ugly.

> 

> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/pci/saa7134/saa7134-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
> index c0e1780..eab2684 100644
> --- a/drivers/media/pci/saa7134/saa7134-core.c
> +++ b/drivers/media/pci/saa7134/saa7134-core.c
> @@ -1046,7 +1046,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
>  	dev->media_dev = kzalloc(sizeof(*dev->media_dev), GFP_KERNEL);
>  	if (!dev->media_dev) {
>  		err = -ENOMEM;
> -		goto fail0;
> +		goto media_dev_alloc_fail;
>  	}
>  	media_device_pci_init(dev->media_dev, pci_dev, dev->name);
>  	dev->v4l2_dev.mdev = dev->media_dev;
> @@ -1309,6 +1309,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
>   fail0:
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	kfree(dev->media_dev);
> + media_dev_alloc_fail:
>  #endif
>  	kfree(dev);
>  	return err;


-- 
Thanks,
Mauro
