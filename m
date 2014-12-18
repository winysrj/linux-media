Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51463 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaLRVXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 16:23:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: William Manley <will@williammanley.net>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] [media] uvcvideo: Add GUID for BGR 8:8:8
Date: Thu, 18 Dec 2014 23:23:26 +0200
Message-ID: <2873589.uTjIvfEhRn@avalon>
In-Reply-To: <5488F136.6050907@williammanley.net>
References: <1418065078-27791-1-git-send-email-will@williammanley.net> <1514839.CAtLhmhmvy@avalon> <5488F136.6050907@williammanley.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Thursday 11 December 2014 01:19:50 William Manley wrote:
> On 10/12/14 23:54, Laurent Pinchart wrote:
> > On Monday 08 December 2014 18:57:58 William Manley wrote:
> >> The Magewell XI100DUSB-HDMI[1] video capture device reports the pixel
> >> format "e436eb7d-524f-11ce-9f53-0020af0ba770".  This is its GUID for
> >> BGR 8:8:8.
> >> 
> >> The UVC 1.5 spec[2] only defines GUIDs for YUY2, NV12, M420 and I420.
> >> This seems to be an extension documented in the Microsoft Windows Media
> >> Format SDK[3] - or at least the Media Format SDK was the only hit that
> >> Google gave when searching for the GUID.  This Media Format SDK defines
> >> this GUID as corresponding to `MEDIASUBTYPE_RGB24`.  Note though, the
> >> XI100DUSB outputs BGR e.g. byte-reversed.  I don't know if its the
> >> capture device in error or Microsoft mean BGR when they say RGB.
> > 
> > I believe Microsoft defines RGB as BGR. They do at least in BMP
> > (https://en.wikipedia.org/wiki/BMP_file_format), probably because they
> > consider the RGB pixel to be stored in little-endian format.
> 
> Thanks, that's helpful.
> 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > I'll apply the patch to my tree and submit it for v3.20.
> 
> Great
> 
> > Could you please send me the output of 'lsusb -v' for your device, if
> > possible running as root ?
> 
> lsusb output attached.

Thank you. I've updated the supported devices list.

-- 
Regards,

Laurent Pinchart

