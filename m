Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44263 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbaFZHgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jun 2014 03:36:19 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so3144779wgh.35
        for <linux-media@vger.kernel.org>; Thu, 26 Jun 2014 00:36:18 -0700 (PDT)
Received: from [192.168.1.100] ([109.89.128.81])
        by mx.google.com with ESMTPSA id bx2sm12603215wjb.47.2014.06.26.00.36.18
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 26 Jun 2014 00:36:18 -0700 (PDT)
From: =?windows-1252?Q?Thomas_L=E9t=E9?= <bistory@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: Terratec Cinergy C (HD ?) support
Message-Id: <4EC457E3-152C-4A0C-9261-A12AA51A70DB@gmail.com>
Date: Thu, 26 Jun 2014 09:36:17 +0200
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone !
I just discovered that Terratec made an other revision of their Cinergy C PCI card (it is a DVB-C lci card). I tried to install it on a debian system with the kernel 3.2.0 and with back port 3.14 without success, I have no device in /dev/dvb.
The wiki page ( http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C ) shows a card with a black PCB but mine has a white one. The weird thing is that the box says it supports HDTV so I guess I own a HD version even it is not mentioned on the product name.

lspci -vnn shows that :

04:00.0 Multimedia controller [0480]: InfiniCon Systems Inc. Device [1820:4e35] (rev 01)
	Subsystem: ATELIER INFORMATIQUES et ELECTRONIQUE ETUDES S.A. Device [1539:1178]
	Flags: bus master, medium devsel, latency 32, IRQ 8
	Memory at 90100000 (32-bit, prefetchable) [disabled] [size=4K]

I found no information on this hardware yet…

I’m currently building latest sources but I don’t think it will help so much.

Do you have any clue that could lead supporting this device on linux ?

Thanks !