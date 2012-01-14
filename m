Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:43103 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2ANIrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 03:47:08 -0500
Date: Sat, 14 Jan 2012 09:47:20 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v2 3/4] gspca: sonixj: Add
 V4L2_CID_JPEG_COMPRESSION_QUALITY control support
Message-ID: <20120114094720.781f89a5@tele>
In-Reply-To: <1325873682-3754-4-git-send-email-snjw23@gmail.com>
References: <4EBECD11.8090709@gmail.com>
	<1325873682-3754-4-git-send-email-snjw23@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  6 Jan 2012 19:14:41 +0100
Sylwester Nawrocki <snjw23@gmail.com> wrote:

> The JPEG compression quality value can currently be read using the
> VIDIOC_G_JPEGCOMP ioctl. As the quality field of struct v4l2_jpgecomp
> is being deprecated, we add the V4L2_CID_JPEG_COMPRESSION_QUALITY
> control, so after the deprecation period VIDIOC_G_JPEGCOMP ioctl
> handler can be removed, leaving the control the only user interface
> for retrieving the compression quality.
	[snip]

This patch works, but, to follow the general control mechanism in gspca,
it should be better to remove the variable 'quality' of 'struct sd' and
to replace all 'sd->quality' by 'sd->ctrls[QUALITY].val'.

Then, initialization

	sd->quality = QUALITY_DEF;

in sd_config() is no more useful, and there is no need to have a
getjpegqual() function, the control descriptor for QUALITY having just:

	.set_control = setjpegqual

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
