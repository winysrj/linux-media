Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:59927 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750949AbeEML3o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 07:29:44 -0400
Date: Sun, 13 May 2018 13:29:42 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] media: mceusb: filter out bogus timing irdata of
 duration 0
Message-ID: <20180513112942.qei5ilesxrottr42@camel2.lan>
References: <20180511083650.20020-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511083650.20020-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Fri, May 11, 2018 at 09:36:48AM +0100, Sean Young wrote:
> A mceusb device has been observed producing invalid irdata. Proactively
> guard against this.

Thanks a lot, the patch series looks good to me! Good catch on the
missing break BTW.

We've included this patch in LibreELEC testbuilds, so far we got
not complaints.

so long,

Hias

> 
> Suggested-by: Matthias Reichl <hias@horus.com>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/mceusb.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 1619b748469b..1ca49491abc8 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -1177,6 +1177,11 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  			init_ir_raw_event(&rawir);
>  			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
>  			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK);
> +			if (unlikely(!rawir.duration)) {
> +				dev_warn(ir->dev, "nonsensical irdata %02x with duration 0",
> +					 ir->buf_in[i]);
> +				break;
> +			}
>  			if (rawir.pulse) {
>  				ir->pulse_tunit += rawir.duration;
>  				ir->pulse_count++;
> -- 
> 2.14.3
> 
