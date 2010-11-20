Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40588 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0KTRhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 12:37:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Shuzhen Wang" <shuzhenw@codeaurora.org>
Subject: Re: Zooming with V4L2
Date: Sat, 20 Nov 2010 18:37:18 +0100
Cc: linux-media@vger.kernel.org
References: <000001cb883f$ec4e4220$c4eac660$@org>
In-Reply-To: <000001cb883f$ec4e4220$c4eac660$@org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011201837.18832.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Shuzhen,

On Saturday 20 November 2010 00:17:23 Shuzhen Wang wrote:
> Hello,
> 
> I am working on a SOC V4L2 driver, and need to implement zoom
> functionality.
> 
> From application, there are 2 ways to do zooming. The 1st way is to use
> cropping and scaling as described in section 1.11.1. The application needs
> to figure out what the steps will be, and calling VIDIOC_S_CROP.
> 
> The 2nd way is to use V4L2_CID_ZOOM_ABSOLUTE and V4L2_CID_ZOOM_RELATIVE as
> described by Laurent in
> http://video4linux-list.1448896.n2.nabble.com/RFC-Zoom-controls-in-V4L2-
td1451987.html.
> 
> Our camera hardware supports digital zoom. However, it acts LIKE optical
> zoom because it doesn't do upscaling, so no video quality is sacrificed.

How can you apply a digital zoom, keeping the output size constant, without 
performing upscaling ?

> As a driver writter, is it okay to support only V4L2_CID_ZOOM_ABSOLUTE and
> V4L2_CID_ZOOM_RELATIVE?
> 
> I guess it also depends on how zooming is done for most of the V4L2 user
> application out there.

The V4L2_CID_ZOOM_* controls are really meant for optical zoom. Digital zoom 
should be implemented using cropping.

-- 
Regards,

Laurent Pinchart
