Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:43726 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2ANIrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 03:47:13 -0500
Date: Sat, 14 Jan 2012 09:47:31 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v2 4/4] gspca: zc3xx: Add
 V4L2_CID_JPEG_COMPRESSION_QUALITY control support
Message-ID: <20120114094731.50471e94@tele>
In-Reply-To: <1325873682-3754-5-git-send-email-snjw23@gmail.com>
References: <4EBECD11.8090709@gmail.com>
	<1325873682-3754-5-git-send-email-snjw23@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  6 Jan 2012 19:14:42 +0100
Sylwester Nawrocki <snjw23@gmail.com> wrote:

> The JPEG compression quality control is currently done by means of the
> VIDIOC_S/G_JPEGCOMP ioctls. As the quality field of struct v4l2_jpgecomp
> is being deprecated, we add the V4L2_CID_JPEG_COMPRESSION_QUALITY control,
> so after the deprecation period VIDIOC_S/G_JPEGCOMP ioctl handlers can be
> removed, leaving the control the only user interface for compression
> quality configuration.

This patch works, but it may be simplified.

Instead of a '.set' pointer, the control descriptor for QUALITY may contain a '.set_control' pointing to a function which just does

	jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);

this function being also be called from the obsoleted function
sd_setquality().

Also, in sd_config, there is no need to initialize the variable
sd->ctrls[QUALITY].val.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
