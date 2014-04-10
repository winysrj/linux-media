Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933736AbaDJBoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 21:44:25 -0400
Date: Wed, 9 Apr 2014 18:47:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anthony DeStefano <adx@fastmail.fm>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: rtl2832_sdr: fixup checkpatch/style issues
Message-ID: <20140410014706.GA11347@kroah.com>
References: <20140410000722.GA64332@pluto-arch.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410000722.GA64332@pluto-arch.home>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 09, 2014 at 08:07:28PM -0400, Anthony DeStefano wrote:
> rtl2832_sdr.c: fixup checkpatch issues about long lines
> 
> Signed-off-by: Anthony DeStefano <adx@fastmail.fm>
> ---
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> index 104ee8a..0e6c6fa 100644
> --- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> +++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> @@ -935,7 +935,9 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_state *s)
>  	/*
>  	 * bandwidth (Hz)
>  	 */
> -	bandwidth_auto = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
> +	bandwidth_auto = v4l2_ctrl_find(&s->hdl,
> +		V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);

Please line stuff up under the (, so for this line it would be:

	bandwidth_auto = v4l2_ctrl_find(&s->hdl,
					V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);

Please fix the rest of these all up.

greg k-h
