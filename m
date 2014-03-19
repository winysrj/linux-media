Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4197 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997AbaCSKOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 06:14:46 -0400
Message-ID: <53296DDC.502@xs4all.nl>
Date: Wed, 19 Mar 2014 11:13:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Martin Bugge <marbugge@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] adv7842: Source Product Description (SPD)
 InfoFrame
References: <1395222225-30084-1-git-send-email-marbugge@cisco.com> <1395222225-30084-3-git-send-email-marbugge@cisco.com>
In-Reply-To: <1395222225-30084-3-git-send-email-marbugge@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On 03/19/14 10:43, Martin Bugge wrote:
> Decode and display any received SPD InfoFrame in log-status.

This is really quite standardized data. I looked around in the kernel
and I found this very nice header: include/linux/hdmi.h and source
drivers/video/hdmi.c.

I would suggest that the adv7842 driver fills the hdmi_spd_infoframe
struct and calls a function in v4l2_dv_timings.c to log the contents.

That way it can also be used by e.g. adv7604. We really should be using
this header for other frame types as well.

Actually, I think you should ask on the dri-devel mailinglist (with a
CC to the active maintainers of the hdmi.c source, see 'git log') whether
creating an hdmi_spd_infoframe_log function would be useful to add to
hdmi.c. If they don't like it, then we stick it in v4l2_dv_timings.c. If
they do like it, we can just add it to hdmi.c. It's something that is
primarily useful for receivers, and not so much for transmitters, so they
might not want it in the hdmi.c source.

> 
> Signed-off-by: Martin Bugge <marbugge@cisco.com>
> ---
>  drivers/media/i2c/adv7842.c | 76 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
> index 5d79c57..805a117 100644
> --- a/drivers/media/i2c/adv7842.c
> +++ b/drivers/media/i2c/adv7842.c
> @@ -2243,6 +2243,81 @@ static void print_avi_infoframe(struct v4l2_subdev *sd)
>  		v4l2_info(sd, "\t%s %s\n", y10_txt[avi.y10], q10_txt[avi.q10]);
>  }
>  
> +static const char *sdi_txt(u8 code)
> +{
> +	switch (code) {
> +	case 0x00: return "unknown";

"unknown" -> "Unknown"

to be consistent with the others.

Regards,

	Hans

> +	case 0x01: return "Digital STB";
> +	case 0x02: return "DVD player";
> +	case 0x03: return "D-VHS";
> +	case 0x04: return "HDD Videorecorder";
> +	case 0x05: return "DVC";
> +	case 0x06: return "DSC";
> +	case 0x07: return "Video CD";
> +	case 0x08: return "Game";
> +	case 0x09: return "PC general";
> +	case 0x0a: return "Blu-Ray Disc (BD)";
> +	case 0x0b: return "Super Audio CD";
> +	}
> +	return "Reserved";
> +}
> +
> +static void print_spd_info_frame(struct v4l2_subdev *sd)
> +{
> +	int i;
> +	u8 spd_type;
> +	u8 spd_ver;
> +	u8 spd_len;
> +	u8 spd_crc;
> +	u8 buf[32];
> +	u8 vn[8];
> +	u8 pd[16];
> +	u8 sdi;
> +
> +	if (!(hdmi_read(sd, 0x05) & 0x80)) {
> +		v4l2_info(sd, "receive DVI-D signal (SDP infoframe not supported)\n");
> +		return;
> +	}
> +	if (!(io_read(sd, 0x60) & 0x04)) {
> +		v4l2_info(sd, "SDP infoframe not received\n");
> +		return;
> +	}
> +
> +	if (io_read(sd, 0x88) & 0x40) {
> +		v4l2_info(sd, "SPD infoframe checksum error has occurred earlier\n");
> +		io_write(sd, 0x8a, 0x40); /* clear SPD_INF_CKS_ERR_RAW */
> +		if (io_read(sd, 0x88) & 0x40) {
> +			v4l2_info(sd, "SPD infoframe checksum error still present\n");
> +			io_write(sd, 0x8a, 0x40); /* clear SPD_INF_CKS_ERR_RAW */
> +		}
> +	}
> +
> +	spd_type = infoframe_read(sd, 0xe6) & 0x7f;
> +	spd_ver = infoframe_read(sd, 0xe7);
> +	spd_len = infoframe_read(sd, 0xe8);
> +	spd_crc = infoframe_read(sd, 0x2a);
> +
> +	v4l2_info(sd, "SPD infoframe type %d, version %d, crc 0x%x, len %d\n",
> +		  spd_type, spd_ver, spd_crc, spd_len);
> +
> +	if (spd_type != 0x03)
> +		return;
> +	if (spd_ver != 0x01)
> +		return;
> +
> +	memset(buf, 0, sizeof(buf));
> +	for (i = 0; i < 25 && i < spd_len; i++)
> +		buf[i] = infoframe_read(sd, i + 0x2b);
> +
> +	snprintf(vn, 8, buf);
> +	snprintf(pd, 16, buf + 8);
> +	sdi = buf[24];
> +
> +	v4l2_info(sd, "\tVendor Name: %s\n", vn);
> +	v4l2_info(sd, "\tProduct Description: %s\n", pd);
> +	v4l2_info(sd, "\tSource Device Information: %s (%d)\n", sdi_txt(sdi), sdi);
> +}
> +
>  static const char * const prim_mode_txt[] = {
>  	"SDP",
>  	"Component",
> @@ -2455,6 +2530,7 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
>  			deep_color_mode_txt[hdmi_read(sd, 0x0b) >> 6]);
>  
>  	print_avi_infoframe(sd);
> +	print_spd_info_frame(sd);
>  	return 0;
>  }
>  
> 

