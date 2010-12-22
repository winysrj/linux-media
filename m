Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55260 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0LVPjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 10:39:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adrian Sandor <aditsu@yahoo.com>
Subject: Re: Logitech C310
Date: Wed, 22 Dec 2010 16:39:48 +0100
Cc: linux-media@vger.kernel.org
References: <29060.37144.qm@web32407.mail.mud.yahoo.com>
In-Reply-To: <29060.37144.qm@web32407.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221639.49893.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Adrian,

On Wednesday 22 December 2010 13:56:41 Adrian Sandor wrote:
> Hi, I bought a Logitech C310 webcam. According to the box, it supports 5
> megapixel photos and 720p video.
> How can I take high-resolution photos from it? Does it work through v4l or
> a separate interface?
> The camera is working well in mplayer (showing 1280*720 video).

The camera sensor has a native 1280x960 resolution. You won't be able to 
capture higher resolution images. If you look at the box, there should be an 
"achieved by software interpolation" or similar comment in a very small 
footprint.

-- 
Regards,

Laurent Pinchart
