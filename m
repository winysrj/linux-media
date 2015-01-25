Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49277 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbbAYUOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 15:14:02 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so5831605wgh.10
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 12:14:01 -0800 (PST)
Message-ID: <54C54E87.6080400@gmail.com>
Date: Sun, 25 Jan 2015 21:13:59 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?Sm9uIEFybmUgSsO4cmdlbnNlbg==?= <jonarne@jonarne.no>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Development discussions related to Fedora
	<devel@lists.fedoraproject.org>,
	"Amadeus W.M." <amadeus84@verizon.net>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: adding new driver to kernel src and building rpm
References: <pan.2015.01.25.06.50.18@verizon.net> <54C5194F.4000701@gmail.com> <pan.2015.01.25.17.37.58@verizon.net> <54C52CAB.8060102@gmail.com>
In-Reply-To: <54C52CAB.8060102@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Salutem

Guys, can you tell us what the situation is with this device(s) and whether it has a chance to land soon in the kernel?

$ modinfo smi2021.ko
filename:       /tmp/smi2021/smi2021.ko
version:        0.1
description:    SMI2021 - EasyCap
author:         Jon Arne Jørgensen <jonjon.arnearne--a.t--gmail.com>
license:        GPL
firmware:       smi2021_3f.bin
firmware:       smi2021_3e.bin
firmware:       smi2021_3c.bin
srcversion:     D6B5C23282ADA257E4A0DD6
alias:          usb:v1C88p003Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1C88p003Ed*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1C88p003Dd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1C88p003Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1C88p0007d*dc*dsc*dp*ic*isc*ip*in*
depends:        videobuf2-core,videodev,snd-pcm,videobuf2-vmalloc,snd,v4l2-common
vermagic:       3.18.3-201.fc21.x86_64 SMP mod_unload 
parm:           firmware_version:Select what firmware to upload
accepted values: 0x3c, 0x3e, 0x3f (int)


poma

