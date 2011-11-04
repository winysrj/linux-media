Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33297 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab1KDNH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 09:07:59 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LU500I1M0HAWVH0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 22:07:58 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.121.116])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LU5007YG0HASN60@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Fri, 04 Nov 2011 22:07:58 +0900 (KST)
From: Jonghun Han <jonghun.han@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com
Subject: Query the meaning of variable in v4l2_pix_format and v4l2_plane
Date: Fri, 04 Nov 2011 22:07:58 +0900
Message-id: <001c01cc9af2$c607e0f0$5217a2d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I'm not sure the meaning of variables in v4l2_pix_format and v4l2_plane.
Especially bytesperline, sizeimage, length and bytesused.

v4l2_pix_format.width		= width
v4l2_pix_format.height		= height
v4l2_pix_format.bytesperline	= bytesperline [in bytes]
v4l2_pix_format.sizeimage	= bytesperline * buf height  -> Is this
right ?

v4l2_plane.length	= bytesperline * buf height  -> Is this right ?
I don't which is right.
v4l2_plane.bytesused	= bytesperline * (top + height)
v4l2_plane.bytesused	= bytesperline * height
v4l2_plane.bytesused	= width * height * bytesperpixel
v4l2_plane.bytesused	= bytesperline * (top + height) - (pixelperline -
(left + width)) * bytesperpixel

I assumed the following buffer.

|                                                          |
|<--------------------- bytesperline --------------------->|
|                                                          |
+----------------------------------------------------------+-----
|          ^                                               |  ^
|          |                                               |  |
|                                                          |  |
|          t                                               |  |
|          o                                               |  |
|          p                                               |  |
|                                                          |  |
|          |                                               |  |
|          V |<--------- width ---------->|                |  |
|<-- left -->+----------------------------+ -              |  |
|            |                            | ^              |
|            |                            | |              |  b
|            |                            | |              |  u
|            |                            |                |  f
|            |                            | h              |
|            |                            | e              |  h
|            |                            | i              |  e
|            |                            | g              |  i
|            |                            | h              |  g
|            |                            | t              |  h
|            |                            |                |  t
|            |                            | |              |  
|            |                            | |              |  |
|            |                            | v              |  |
|            +----------------------------+ -              |  |
|                                                          |  |
|                                                          |  |
|                                                          |  v
+----------------------------------------------------------+-----


Best regards,


