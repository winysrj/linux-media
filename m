Return-path: <mchehab@pedra>
Received: from davee.hu ([195.228.74.82]:45833 "EHLO mail.davee.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab0HNNc2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Aug 2010 09:32:28 -0400
Received: from [IPv6:2a01:270:dd00:e101:6c71:ca9f:b48a:6fa3] (2a010270dd00e1016c71ca9fb48a6fa3.rdns.inet6.hu [IPv6:2a01:270:dd00:e101:6c71:ca9f:b48a:6fa3])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.davee.hu (Postfix) with ESMTP id 6ED8F181598F3
	for <linux-media@vger.kernel.org>; Sat, 14 Aug 2010 15:05:43 +0200 (CEST)
Message-ID: <4C6694C7.6020203@davee.hu>
Date: Sat, 14 Aug 2010 15:06:15 +0200
From: Kelemen Soma <soma@davee.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: bttv id
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

  [  789.209449] bttv0: subsystem: ff01:a132 (UNKNOWN)
[  789.209453] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[  789.209460] bttv0: using: IVC-100 [card=110,insmod option]

05:00.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
         Subsystem: Device [ff01:a132]
         Flags: bus master, medium devsel, latency 32, IRQ 21
         Memory at f0101000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv

05:00.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
         Subsystem: Device [ff01:a132]
         Flags: bus master, medium devsel, latency 32, IRQ 10
         Memory at f0100000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

this is an IVC-100 card like ff00:a132

