Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15A4VRn004161
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 05:04:31 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m15A3rfS008049
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 05:03:54 -0500
Date: Tue, 5 Feb 2008 11:03:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <a030ada87143b0e559ae.1202176997@localhost>
Message-ID: <Pine.LNX.4.64.0802051100210.5546@axis700.grange>
References: <a030ada87143b0e559ae.1202176997@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2 of 3] [v4l] Add new user class controls and deprecate
 others
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, 4 Feb 2008, Brandon Philips wrote:

> +
> +/* Deprecated, use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
> +#define V4L2_CID_HCENTER_DEPRECATED	(V4L2_CID_BASE+22) 
> +#define V4L2_CID_VCENTER_DEPRECATED	(V4L2_CID_BASE+23) 
> +
> +#define V4L2_CID_POWER_LINE_FREQUENCY	(V4L2_CID_BASE+24) 
> +enum v4l2_power_line_frequency {
> +	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
> +	V4L2_CID_POWER_LINE_FREQUENCY_50HZ	= 1,
> +	V4L2_CID_POWER_LINE_FREQUENCY_60HZ	= 2,
> +};
> +#define V4L2_CID_HUE_AUTO			(V4L2_CID_BASE+25) 
> +#define V4L2_CID_WHITE_BALANCE_TEMPERATURE	(V4L2_CID_BASE+26) 
> +#define V4L2_CID_SHARPNESS			(V4L2_CID_BASE+27) 
> +#define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28) 
> +#define V4L2_CID_LASTP1				(V4L2_CID_BASE+29) /* last CID + 1 */
>  
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

Also, please, remove trailing blanks in 7 lines:

Adds trailing whitespace.
.dotest/patch:26:#define V4L2_CID_HCENTER_DEPRECATED    (V4L2_CID_BASE+22)
Adds trailing whitespace.
.dotest/patch:27:#define V4L2_CID_VCENTER_DEPRECATED    (V4L2_CID_BASE+23)
Adds trailing whitespace.
.dotest/patch:29:#define V4L2_CID_POWER_LINE_FREQUENCY  (V4L2_CID_BASE+24)
Adds trailing whitespace.
.dotest/patch:35:#define V4L2_CID_HUE_AUTO                      (V4L2_CID_BASE+25)
Adds trailing whitespace.
.dotest/patch:36:#define V4L2_CID_WHITE_BALANCE_TEMPERATURE     (V4L2_CID_BASE+26)
warning: squelched 2 whitespace errors
warning: 7 lines add whitespace errors.

(git only listed 5 out of 7 lines explicitly above)

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
