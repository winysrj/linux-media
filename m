Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62456 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbeA3MIA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 07:08:00 -0500
Date: Tue, 30 Jan 2018 10:07:50 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Brad Love <brad@nextdimension.cc>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/9] em28xx: Bulk transfer implementation fix
Message-ID: <20180130100750.06487d7a@vela.lan>
In-Reply-To: <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
        <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  4 Jan 2018 18:04:12 -0600
Brad Love <brad@nextdimension.cc> escreveu:

> Set appropriate bulk/ISOC transfer multiplier on capture start.
> This sets ISOC transfer to 940 bytes (188 * 5)
> This sets bulk transfer to 48128 bytes (188 * 256)
> 
> The above values are maximum allowed according to Empia.
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>  drivers/media/usb/em28xx/em28xx-core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index ef38e56..67ed6a3 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -638,6 +638,18 @@ int em28xx_capture_start(struct em28xx *dev, int start)
>  	    dev->chip_id == CHIP_ID_EM28174 ||
>  	    dev->chip_id == CHIP_ID_EM28178) {
>  		/* The Transport Stream Enable Register moved in em2874 */
> +		if (dev->dvb_xfer_bulk) {
> +			/* Max Tx Size = 188 * 256 = 48128 - LCM(188,512) * 2 */
> +			em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
> +					EM2874_R5D_TS1_PKT_SIZE :
> +					EM2874_R5E_TS2_PKT_SIZE,
> +					0xFF);
> +		} else {
> +			/* TS2 Maximum Transfer Size = 188 * 5 */
> +			em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
> +					EM2874_R5D_TS1_PKT_SIZE :
> +					EM2874_R5E_TS2_PKT_SIZE, 0x05);
> +		}

Hmm... for ISOC, the USB descriptors inform the max transfer size, with
are detected at probe time, on this part of em28xx_usb_probe:

	if (size > dev->dvb_max_pkt_size_isoc) {
		has_dvb = true; /* see NOTE (~) */
		dev->dvb_ep_isoc = e->bEndpointAddress;
		dev->dvb_max_pkt_size_isoc = size;
		dev->dvb_alt_isoc = i;
	}

If we're touching TS PKT size register, it should somehow be
aligned what's there. I mean, we should either do:

			em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
					EM2874_R5D_TS1_PKT_SIZE :
					EM2874_R5E_TS2_PKT_SIZE, dev->dvb_max_pkt_size_isoc / 188);

Or the other way around, setting dev->dvb_max_pkt_size_isoc after
writing to EM2874_R5D_TS1_PKT_SIZE or EM2874_R5E_TS2_PKT_SIZE.

Not sure what's more accurate here: the USB descriptors or the
contents of the TS size register. I doubt, I would stick with
the USB descriptor info.

Btw, I wander what happens if we write a bigger value than 5 to those
registers. Would it support a bigger transfer size than 940 for ISOCH?



Cheers,
Mauro
