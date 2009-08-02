Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4924 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZHBJd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 05:33:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org,
	Jean-Francois Moine via Mercurial <moinejf@free.fr>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] gspca - vc032x: H and V flip controls added for mi13x0_soc sensors.
Date: Sun, 2 Aug 2009 11:33:25 +0200
References: <E1MWegK-00046z-Si@mail.linuxtv.org>
In-Reply-To: <E1MWegK-00046z-Si@mail.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908021133.25624.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 31 July 2009 01:05:04 Patch from Jean-Francois Moine wrote:
> The patch number 12354 was added via Jean-Francois Moine <moinejf@free.fr>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------
> 
> From: Jean-Francois Moine  <moinejf@free.fr>
> gspca - vc032x: H and V flip controls added for mi13x0_soc sensors.
> 
> 
> Also, H/V flip default values adjusted according to the webcam IDs.
> 
> Priority: normal
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> 
> 
> ---
> 
>  linux/drivers/media/video/gspca/vc032x.c |  109 +++++++++++++----------
>  1 file changed, 63 insertions(+), 46 deletions(-)
> 
> diff -r c9c025650ce7 -r 266dc538f544 linux/drivers/media/video/gspca/vc032x.c
> --- a/linux/drivers/media/video/gspca/vc032x.c	Mon Jul 27 10:52:27 2009 +0200
> +++ b/linux/drivers/media/video/gspca/vc032x.c	Mon Jul 27 11:00:03 2009 +0200
> @@ -3121,33 +3127,44 @@
>  	return 0;
>  }
>  
> -/* for OV7660 and OV7670 only */
> +/* some sensors only */
>  static void sethvflip(struct gspca_dev *gspca_dev)
>  {
>  	struct sd *sd = (struct sd *) gspca_dev;
> -	__u8 data;
> +	u8 data[2], hflip, vflip;
>  
> +	hflip = sd->hflip;
> +	if (sd->flags & FL_HFLIP)
> +		hflip != hflip;
> +	vflip = sd->vflip;
> +	if (sd->flags & FL_VFLIP)
> +		vflip != vflip;

Hi Jean-Francois,

The daily build produces this warning:

/marune/build/v4l-dvb-master/v4l/vc032x.c: In function 'sethvflip':
/marune/build/v4l-dvb-master/v4l/vc032x.c:3138: warning: statement with no effect
/marune/build/v4l-dvb-master/v4l/vc032x.c:3141: warning: statement with no effect

And looking at the code those warnings are correct. I think you wanted to do
'hflip = !hflip'.

Can you take a look at this?

Thanks,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
