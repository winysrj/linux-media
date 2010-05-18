Return-path: <linux-media-owner@vger.kernel.org>
Received: from lilzmailso01.liwest.at ([212.33.55.23]:48812 "EHLO
	lilzmailso02.liwest.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756206Ab0ERMpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 08:45:11 -0400
Received: from [212.33.55.11] (helo=24speed.at)
	by lilzmailso02.liwest.at with smtp (Exim 4.69)
	(envelope-from <dietmar.hein@liwest.at>)
	id 1OELKY-0004uK-R2
	for linux-media@vger.kernel.org; Tue, 18 May 2010 13:51:26 +0200
Date: Tue, 18 May 2010 13:51:26 +0200 (CEST)
From: dietmar.hein@liwest.at
To: linux-media@vger.kernel.org
Subject: =?ISO-8859-15?Q?bugreport=3A_tt-budget_c-1501_-_buffer_larger?=
 =?ISO-8859-15?Q?_than_encounte_size?=
Message-ID: <mtranet.20100518135126.1522624960@24speed.at>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-ID: <mtranet.1274183486.1272703730@24speed.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I am using yaVDR 0.1.1 based on ubuntu 9.10 i386
--> DVB-C card: TT-Budget C-1501
Multimedia controller: Philips Semiconductors SAA7146 (rev 01)

--> several times when switching channels buffer error occurs:

dmesg | grep buffer
[ 6194.632558] dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
[ 6263.209584] saa7146 (0): dma buffer size 192512

/var/log/messages
May  9 17:47:51 <hostname> kernel: [11344.224843] dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
May  9 17:47:51 <hostname> kernel: [11344.224860] dvb_ca adapter 0: DVB CAM link initialisation failed :(

If you need more informations feel free to reply to my email
thx.
/regards dietmar


