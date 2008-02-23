Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166] helo=smtp.eutelia.it)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roa@libero.it>) id 1JSy9Q-0002uu-N8
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 18:27:04 +0100
Received: from [192.168.1.3] (ip-213-176.sn2.eutelia.it [83.211.213.176])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.eutelia.it (Eutelia) with ESMTP id 7714D15A76B
	for <linux-dvb@linuxtv.org>; Sat, 23 Feb 2008 18:27:00 +0100 (CET)
From: ROASCIO Paolo <roa@libero.it>
To: linux-dvb@linuxtv.org
Date: Sat, 23 Feb 2008 18:28:19 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802231828.20535.roa@libero.it>
Subject: [linux-dvb] [PATCH to be tested] hvr3000 repository ported to
	todaysnapshot - support multiple frontends of hvr3000 and
	flydvbwithout rmmod/insmod
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

I'm a Flydvb Trio owner and since it appears i use this patch together with 
dpeddi's flydvb_trio_remote_final.diff.

For the last one, i don't want to open a flame: i know that it will not merged 
in the v4l-dvb code due to implementation problems, i will continue to apply 
it myself (works very well for me).

Well, my problem with the first patch is this: i update to the last 
v4l-dvb-20070818 available, but when i try to scan analog and dvb-t channels 
i obtain different behaviours:

- w_scan: no signal in the whole frequency range (w_scan -t3 -F -x)

- kaffeine: random signal lock, i have to start the scan, register channels 
eventually found on the first transponder, stop kaffeine, comment in the 
configuration file the transponder scanned, rerun kaffeine, start scanning 
and so on, i'm not able to do a complete scan in one shot. The strange thing 
is that each time i do this, i obtain different channels and not the 
previously scanned.
When i try to watch channels, often kaffeine can't lock to the signal:i have 
to try dozens times to obtain video.

- tzap: no problem, all channels are correctly scanned.

- tvtime: no problem, all channels are correctly scanned.

- gqradio: scanning very slow and no channels found.

Today i downloaded the actual hg snapshot from v4l-dvb, applied the remote 
patch (with minor adaptiations) and - without the second frontend support - 
of course, i obtained all programs above runs perfectly.

Now, in the hg changelog, there are lots of saa7134 improvements, then i 
suspect that the 20070818 branch is quite old.

Is there a chance to see the multifrontend code for tlydvb/hvr3000/* merged in 
the mainline, or the patch have to be upgraded?

Thanks and excuse me for my poor self-learned english

Roascio paolo

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
