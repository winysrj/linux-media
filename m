Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33366 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaKGNul (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Nov 2014 08:50:41 -0500
Received: by mail-wg0-f43.google.com with SMTP id y10so3810133wgg.16
        for <linux-media@vger.kernel.org>; Fri, 07 Nov 2014 05:50:40 -0800 (PST)
Date: Fri, 7 Nov 2014 14:50:28 +0100
From: Francesco Marletta <fmarletta@movia.biz>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Help required for TVP5151 on Overo
Message-ID: <20141107145028.0505f1d0@crow>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello to everyone,
I'd like to know who have used the TVP5151 video decoder with the OMAP3
Overo module.

I'm trying to have the processor to capture the video from a TVP5151
boarda, but without success (both gstreamer and yavta wait forever the
data from the V4L2 subsystem).

Thanks in advance!
