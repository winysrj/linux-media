Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:59707 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3JGLbi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Oct 2013 07:31:38 -0400
Received: from ni.piap.pl (localhost.localdomain [127.0.0.1])
	by ni.piap.pl (Postfix) with ESMTP id C19FD440DB8
	for <linux-media@vger.kernel.org>; Mon,  7 Oct 2013 13:31:36 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Date: Mon, 07 Oct 2013 13:31:36 +0200
MIME-Version: 1.0
Message-ID: <m3txgt8gh3.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: V4L2_BUF_FLAG_NO_CACHE_*
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

found them looking for my V4L2 + mmap + MIPS solution... Is the
following intentional? Some out-of-tree code maybe?

$ grep V4L2_BUF_FLAG_NO_CACHE_ * -r

Documentation/DocBook/media/v4l/io.xml:     <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
Documentation/DocBook/media/v4l/io.xml:     <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml:<constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml:<constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
include/uapi/linux/videodev2.h:#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE        0x0800
include/uapi/linux/videodev2.h:#define V4L2_BUF_FLAG_NO_CACHE_CLEAN             0x1000
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
