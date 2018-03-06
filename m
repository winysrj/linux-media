Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753878AbeCFQS1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 11:18:27 -0500
Date: Tue, 6 Mar 2018 13:18:23 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH v2 11/12] [media] ngene: move the tsin_exchange()
 stripcopy block into a function
Message-ID: <20180306131823.4b6280ba@vento.lan>
In-Reply-To: <20180225123140.19486-12-d.scheller.oss@gmail.com>
References: <20180225123140.19486-1-d.scheller.oss@gmail.com>
        <20180225123140.19486-12-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 25 Feb 2018 13:31:39 +0100
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Move the copy logic that will skip previously inserted TS NULL frames when
> moving data to the DVB ring buffers into an own function. This is done to
> not duplicate code all over the place with the following TS offset shift
> fixup patch.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/pci/ngene/ngene-dvb.c | 48 +++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
> index f71fd41c762c..6d72b9f69418 100644
> --- a/drivers/media/pci/ngene/ngene-dvb.c
> +++ b/drivers/media/pci/ngene/ngene-dvb.c
> @@ -123,6 +123,32 @@ static u32 overflow;
>  static u32 stripped;
>  #endif
>  
> +static inline void tsin_copy_stripped(struct ngene *dev, void *buf)
> +{
> +	if (memcmp(buf, fill_ts, sizeof(fill_ts)) != 0) {
> +		if (dvb_ringbuffer_free(&dev->tsin_rbuf) >= 188) {
> +			dvb_ringbuffer_write(&dev->tsin_rbuf, buf, 188);
> +			wake_up(&dev->tsin_rbuf.queue);
> +#ifdef DEBUG_CI_XFER
> +			ok++;
> +#endif
> +		}
> +#ifdef DEBUG_CI_XFER
> +		else
> +			overflow++;
> +#endif
> +	}
> +#ifdef DEBUG_CI_XFER
> +	else
> +		stripped++;
> +
> +	if (ok % 100 == 0 && overflow)
> +		dev_warn(&dev->pci_dev->dev,
> +			 "%s: ok %u overflow %u dropped %u\n",
> +			 __func__, ok, overflow, stripped);
> +#endif

Those blocks are ugly. Also, there's no Kconfig way to enable those
debug messages.

If they're meant only for your own consumption, just keep it
outside of upstream.

Otherwise, please change the logic in a way that it would
make the code harder to read/enable.

> +}
> +
>  void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
>  {
>  	struct ngene_channel *chan = priv;
> @@ -134,28 +160,8 @@ void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
>  
>  	if (dev->ci.en && chan->number == 2) {
>  		while (len >= 188) {
> -			if (memcmp(buf, fill_ts, sizeof fill_ts) != 0) {
> -				if (dvb_ringbuffer_free(&dev->tsin_rbuf) >= 188) {
> -					dvb_ringbuffer_write(&dev->tsin_rbuf, buf, 188);
> -					wake_up(&dev->tsin_rbuf.queue);
> -#ifdef DEBUG_CI_XFER
> -					ok++;
> -#endif
> -				}
> -#ifdef DEBUG_CI_XFER
> -				else
> -					overflow++;
> -#endif
> -			}
> -#ifdef DEBUG_CI_XFER
> -			else
> -				stripped++;
> +			tsin_copy_stripped(dev, buf);
>  
> -			if (ok % 100 == 0 && overflow)
> -				dev_warn(&dev->pci_dev->dev,
> -					 "%s: ok %u overflow %u dropped %u\n",
> -					 __func__, ok, overflow, stripped);
> -#endif
>  			buf += 188;
>  			len -= 188;
>  		}



Thanks,
Mauro
