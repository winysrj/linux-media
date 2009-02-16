Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:21363 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbZBPVee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 16:34:34 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org
Subject: [ANNOUNCE] Minoru3D camera supported by the Linux UVC driver
Date: Mon, 16 Feb 2009 22:38:06 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162238.06526.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I've just realized that my latest announcement to the linux-uvc-devel mailing 
list is awfully old. I had to do something about it, and I'm pleased to 
announce that the Linux UVC driver now supports the Minoru3D stereo camera.

The Minoru3D (http://www.minoru3d.com) is a cute, anthropomorphic device made 
of two UVC cameras mounted in a single case and spaced roughly the same 
distance apart as human eyes to get a stereoscopic effect.

The latest Linux UVC driver supports streaming from both cameras 
simultaneously at 30fps (up to 320x240) or 15fps (up to 640x480). You can 
download it from the Linux UVC Mercurial repository 
(http://linuxtv.org/hg/~pinchartl/uvcvideo) or wait for Linux 2.6.30.

Please note that anaglyph (pseudo-3D image with red and blue or red and cyan 
components), "picture in picture" and "side by side" output provided by the 
Minoru3D driver on the Windows platform is not supported at this stage. This 
is an excellent opportunity for all of you to get into V4L2 application 
development and write a nice anaglyph Linux application :-)

I would like to thank Promotion & Display Technology for helping the Linux UVC 
driver development by providing both hardware samples and technical 
information.

Cheers,

Laurent Pinchart

