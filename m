Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38808.mail.mud.yahoo.com ([209.191.125.99])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1Kcq4q-0005vK-6z
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 01:23:27 +0200
Date: Mon, 8 Sep 2008 16:22:49 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <48C5911A.4050808@gmail.com>
MIME-Version: 1.0
Message-ID: <179729.56472.qm@web38808.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: urishk@yahoo.com
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

Manu and all,


First I would like to present myself (I'm new to this forum)
My name is Uri Shkolnik, and I work as Software Architecture at Siano Mobile Silicon (www.siano-ms.com).

As some people reading this mailing list know, but some don't.... Siano manufactures chipsets that support various of MDTV standards (DVB-H, DVB-T, ISDB-T, CMMB, T-DMB, DAB-IP,... and many more). Many products you see actually uses Siano's chipsets.

As far as I understand from this thread, and from other threads, the LinuxTV/DVB sub-system will not support non-DVB standards in the near future.

This is quite understandable since those standards are quite complicate, and the newer are even more complicated than DVB-C/S/T. It took about 5 years for the DVB sub-system to become mature, so, trying to add all of those standards at once will lead to nowhere good.

I don't know what should be done next, which API (and sub-system) should be added first, second, ... (or not at all?). I have my own views (CMMB getting much more audience than DVB-H and ISDB-T more than the DAB family). 

But, I can offer technical assistant. Siano is senior member at most of the MDTV consortiumes (CMMB, DVB and more) and I have access to lot of technical documentation (specifications, guildlines, etc.) which are otherwise quite hard (if not impossible) to be obtained.
True that some (not all) of those papers are under classification that does not permit me to share them directly, but always a specific question can be answered.

One point regarding Siano non-DVB offering - With Michael Krufky's help, I'm trying to find a way to add Siano's non-DVB(-T) offering into the kernel's code base (till now we supply a proprietary sources directly to our customers). Of course it will be somewhat specific code by the fact that it'll match Siano's chipset instead of be more generic.


So, I'm done with the introduction..... :-)


Regards,

Uri




      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
