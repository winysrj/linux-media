Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:42704 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZC0T3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 15:29:46 -0400
Date: Fri, 27 Mar 2009 20:21:53 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-media@vger.kernel.org, kilgota@banach.math.auburn.edu,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC][PATCH 1/2] Sensor orientation reporting
Message-ID: <20090327202153.7173f48f@free.fr>
In-Reply-To: <200903152229.48761.linux@baker-net.org.uk>
References: <200903152224.29388.linux@baker-net.org.uk>
	<200903152229.48761.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 22:29:48 +0000
Adam Baker <linux@baker-net.org.uk> wrote:

> Add support to the SQ-905 driver to pass back to user space the
> sensor orientation information obtained from the camera during init.
> Modifies gspca and the videodev2.h header to create the necessary
> API.
> 
> Signed-off-by: Adam Baker <linux@baker-net.org.uk>
> 
> ---
	[snip]
> diff -r 1248509d8bed linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h	Sat Mar 14
> 08:44:42 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.h	Sun Mar 15
> 22:25:34 2009 +0000
> @@ -168,6 +168,7 @@ struct gspca_dev {
> 	__u8 alt;		/* USB alternate setting */
> 	__u8 nbalt;		/* number of USB alternate settings */
>	 u8 bulk;		/* image transfer by 0:isoc / 1:bulk
> */
> +	u32 input_flags;	/* value for ENUM_INPUT status flags
> */ };
	[snip]

Hi Adam,

This 'input_flags' should better go to the 'struct cam' (line 59).

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
