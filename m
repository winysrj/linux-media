Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56879 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1HLQ0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 12:26:44 -0400
Received: from lancelot.localnet (unknown [91.178.165.160])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id DBB2935AA5
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2011 16:26:42 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Is V4L2_PIX_FMT_RGB656 RGB or BGR ?
Date: Fri, 12 Aug 2011 18:26:38 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108121826.39804.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html, 
V4L2_PIX_FMT_RGB565 is defined as

 Identifier           Byte 0 in memory         Byte 1 
                  Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0
 V4L2_PIX_FMT_RGB565  g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3

As this is stored in little-endian, the color word is thus

b4 b3 b2 b1 b0 g5 g4 g3 g2 g1 g0 r4 r3 r2 r1 r0

This looks awfully like BGR to me, not RGB.

I need to define a FOURCC for the corresponding RGB format

 Identifier           Byte 0 in memory         Byte 1 
                  Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0
 V4L2_PIX_FMT_RGB565  g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3

Should I call it V4L2_PIX_FMT_BGR565 ? :-)

-- 
Regards,

Laurent Pinchart
