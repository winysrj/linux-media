Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:51363 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZC1Uq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 16:46:57 -0400
Received: from shell2.sea5.speakeasy.net ([69.17.116.3])
          (envelope-sender <xyzzy@speakeasy.org>)
          by mail12.sea5.speakeasy.net (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 28 Mar 2009 20:46:54 -0000
Date: Sat, 28 Mar 2009 13:46:54 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-media@vger.kernel.org
Subject: saa7146 vbi capture broken?
Message-ID: <Pine.LNX.4.58.0903281336200.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While working on another patch I noticed a flaw I think is preventing VBI
capture on saa7146 from working.  The v4l2-ioctl code will not allow
VIDIOC_(Q|DQ|REQ|QUERY)BUFS ioctls for a given buffer type unless the driver
provides a ->vidioc_try_fmt_foo() method for that buffer type.  SAA7146
only provides try_fmt methods for video_capture and video_overlay, NOT
vbi_capture.  Has anyone actually used saa7146 for VBI capture?
