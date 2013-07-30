Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:11041 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3G3NMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 09:12:39 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQR007DP3BBZS30@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Jul 2013 09:12:37 -0400 (EDT)
Date: Tue, 30 Jul 2013 10:12:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QsOlcmQ=?= Eirik Winther <bwinther@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 FINAL 0/6] qv4l2: add OpenGL rendering and window fixes
Message-id: <20130730101233.2c78cbae@samsung.com>
In-reply-to: <1375172124-14439-1-git-send-email-bwinther@cisco.com>
References: <1375172124-14439-1-git-send-email-bwinther@cisco.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Jul 2013 10:15:18 +0200
Bård Eirik Winther <bwinther@cisco.com> escreveu:

...

> Performance:
> All tests are done on an Intel i7-2600S (with Turbo Boost disabled) using the
> integrated Intel HD 2000 graphics processor. The mothreboard is an ASUS P8H77-I
> with 2x2GB CL 9-9-9-24 DDR3 RAM. The capture card is a Cisco test card with 4 HDMI
> inputs connected using PCIe2.0x8. All video input streams used for testing are
> progressive HD (1920x1080) with 60fps.

I did a quick test here with a radeon HD 7750 GPU on a i7-3770 CPU, using an UVC
camera at VGA resolution and nouveau driver (Kernel 3.10.3).

qv4l2 CPU usage dropped from 13% to 3,75%.

It sounds a nice improvement!

-- 

Cheers,
Mauro
