Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp28.orange.fr ([80.12.242.100])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kafifi@orange.fr>) id 1Jze1A-0003Zv-7W
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 22:37:36 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2807.orange.fr (SMTP Server) with ESMTP id 826A28000181
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 22:37:02 +0200 (CEST)
Received: from pcserver (ASte-Genev-Bois-151-1-46-208.w83-114.abo.wanadoo.fr
	[83.114.156.208])
	by mwinf2807.orange.fr (SMTP Server) with ESMTP id 4F21C800010B
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 22:37:02 +0200 (CEST)
Received: from pcserver ([192.168.200.1]) by pcserver (602LAN SUITE 2004) id
	376e25f1 for linux-dvb@linuxtv.org; Fri, 23 May 2008 22:36:29 +0200
From: "kafifi" <kafifi@orange.fr>
To: <linux-dvb@linuxtv.org>
Date: Fri, 23 May 2008 22:36:28 +0200
MIME-Version: 1.0
In-Reply-To: <20080523194658.40820@gmx.net>
Message-Id: <20080523203702.4F21C800010B@mwinf2807.orange.fr>
Subject: [linux-dvb] NOVA-T500 : mesuring bit rate error ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I recently added a NOVA-T500 to my vdrbox. Unfortunately, even if the
picture is really nice, I've some freezes because the DVB-T signal is weak
(I am in 50km of the Eiffel Tower...). I ordered a 0.4 dB low noise
preamplifier (ULNA 3036 from TGN-Technology) to improve my installation. 

I will need to mesure strengh and bit rate error values. Unfortunately,
Femon 1.6 is mesuring only the strengh value (about 60%). It seems the DVB
driver of Nova-T 500 always returns 0. 

Can anyone can confirm this, and if so, can fix the Linux driver ?

Thanks a lot.
Karim



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
