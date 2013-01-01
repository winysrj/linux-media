Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3AAUED (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 15:04:03 -0500
Date: Tue, 1 Jan 2013 21:03:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: RE: [PATCH V3 06/15] [media] marvell-ccic: add new formats support
 for marvell-ccic driver
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D13EA8816@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1301012102510.4048@axis700.grange>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-7-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1301011734070.31619@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D13EA8816@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

On Tue, 1 Jan 2013, Albert Wang wrote:

> >> +	case V4L2_PIX_FMT_YUV422P:
> >> +	case V4L2_PIX_FMT_YUV420:
> >> +	case V4L2_PIX_FMT_YVU420:
> >> +		imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
> >> +		widthy = fmt->width;
> >> +		widthuv = fmt->width / 2;
> >
> >I might be wrong, but the above doesn't look right to me. Firstly, YUV422P
> >is a 4:2:2 format, whereas YUV420 and YVU420 are 4:2:0 formats, so, I
> >would expect calculations for them to differ. Besides, bytesperline * 4 /
> >3 doesn't look right for any of them. If this is what I think - total
> >number of bytes per line, i.e., sizeimage / height, than shouldn't YAU422P
> >have
> >+		imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
> >and the other two
> >+		imgsz_w = (fmt->bytesperline * 3 / 2) & IMGSZ_H_MASK;
> >? But maybe I'm wrong, please, double-check and confirm.
> >
> [Albert Wang] It looks they are both 12 bit planar format, they have same imgsz_w.
> Anyway, we will double check it after back to office.

_Both_ YUV420 and YVU420 - yes, but YUV422P is 16-bit.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
