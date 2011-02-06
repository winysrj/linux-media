Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <davejohansen@gmail.com>) id 1PmDET-0005VT-4T
	for linux-dvb@linuxtv.org; Sun, 06 Feb 2011 23:37:26 +0100
Received: from mail-wy0-f182.google.com ([74.125.82.182])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-c) with esmtps
	[TLSv1:RC4-MD5:128] for <linux-dvb@linuxtv.org>
	id 1PmDES-0005OP-5V; Sun, 06 Feb 2011 23:37:24 +0100
Received: by wyf19 with SMTP id 19so4070907wyf.41
	for <linux-dvb@linuxtv.org>; Sun, 06 Feb 2011 14:37:23 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 6 Feb 2011 15:37:23 -0700
Message-ID: <AANLkTinjefXPaDrbgbWLEC4-Zd9wOjx8zz1=vvPDuKtu@mail.gmail.com>
From: Dave Johansen <davejohansen@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Tuning channels with DViCO FusionHDTV7 Dual Express
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

I am trying to resurrect my MythBuntu system with a DViCO FusionHDTV7
Dual Express. I had previously had some issues with trying to get
channels working in MythTV (
http://www.mail-archive.com/linux-media@vger.kernel.org/msg03846.html
), but now it locks up with MythBuntu 10.10 when I scan for channels
in MythTV and also with the scan command line utility.

Here's the output from scan:

scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB
scanning us-ATSC-center-frequencies-8VSB
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tune to: 189028615:8VSB
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x1ffb

Any ideas/suggestions on how I can get this to work?

Thanks,
Dave

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
