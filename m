Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12871 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0L2JsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 04:48:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LE6001LGOKKBJ10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Dec 2010 09:48:20 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LE600IHQOKJUS@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Dec 2010 09:48:20 +0000 (GMT)
Date: Wed, 29 Dec 2010 10:48:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/2] Videobuf2 tests with SAA7134 driver
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293616097-24167-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

here are the very initial patches for testing videbuf2 with the saa7134 driver.
I am sending them on behalf of Andrzej who is currently on holiday.
Hopefully we can provide real conversion patches of a v4l2 driver of hardware
which is widely available in the near future. Unfortunately except the Samsung 
S5P FIMC and S5P MFC drivers now it's all we can provide for vb2 testing.  

The patches were created against git://linuxtv.org/media_tree.git staging/for_v2.6.38. 

on top of my previous changeset:

"V4L2 mem-to-mem framework and s5p-fimc driver conversion for videobuf2"

The patch series contains:
[PATCH 1/2] v4l: saa7134: remove radio, vbi, mpeg, input, alsa, tvaudio, saa6752hs support
[PATCH 2/2] v4l: saa7134: quick and dirty port to videobuf2

The full GIT tree should soon be available at:
git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2 branch.

Gitweb:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2


Regards,
Sylwester 


--
Sylwester Nawrocki
Samsung Poland R&D Center

