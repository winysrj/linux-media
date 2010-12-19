Return-path: <mchehab@gaivota>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <jean.bruenn@ip-minds.de>) id 1PUSmE-0000iS-UQ
	for linux-dvb@linuxtv.org; Mon, 20 Dec 2010 00:34:55 +0100
Received: from alia.ip-minds.de ([84.201.38.2])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PUSmE-00051a-1x; Mon, 20 Dec 2010 00:34:54 +0100
Received: from localhost (pD9E18ED5.dip.t-dialin.net [217.225.142.213])
	by alia.ip-minds.de (Postfix) with ESMTPA id 453431BE898E
	for <linux-dvb@linuxtv.org>; Mon, 20 Dec 2010 00:35:24 +0100 (CET)
Date: Mon, 20 Dec 2010 00:34:52 +0100
From: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
To: linux-dvb@linuxtv.org
Message-Id: <20101220003452.49a9dffd.jean.bruenn@ip-minds.de>
Mime-Version: 1.0
Subject: [linux-dvb] General Question regarding SNR
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
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <linux-dvb@linuxtv.org>

Hello,

i hope it's okay to ask here. I'm wondering how the SNR is calculated,
and how someone can calculate the "real" snr in db. This caused me a
lot of nerves and i don't seem to be able to calculate the correct snr.
For that some examples. I'm using DVB-T and a Hauppauge WinTV-HVR1200
(Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 02))

dvbsnoop reports 
cycle: 1  d_time: 0.001 s  Sig: 63993  SNR: 185  BER: 9999839
UBLK: 11  Stat: 0x00 []
cycle: 2  d_time: 0.003 s  Sig: 64507 SNR: 185  BER: 9999839  UBLK: 18
Stat: 0x00 []
cycle: 3 d_time: 0.003 s  Sig: 63993  SNR: 168 BER: 9999839  UBLK: 28
Stat: 0x00 []

WITHOUT a antenna connected, WITHOUT a sender tuned. I guess it's quite
unlikely that i have 185 db snr, without anything connected nor tuned.
Alright. With a 42 db amplified antenna connected, i get SNRs between
143 and 178 (calculated with bash and tzap.. e.g.: 

((snr_in_db=16#$snr_from_tzap))
->
	((var=16#0092))
	echo $var
	146 (should be db)

Doing so, reports also db values of 215 which should be quite unlikely
even when using cable (correct me if i'm wrong). So let's assume that
the value which is reported needs to be subtracted from the above
value. Then we would have:

	215 - 185 = 30 db (sounds resonable)
	146 - 185 = -39 db (errm... ok.. so this can't be)

AAaaaanother try, some guy reported to calculate the snr (reported snr
= 0f1f1 (though seems to be for dvb-s, and i'm dealing with dvb-t) like
this:
	0xf1 / 8 = 30.125 db (sounds reasonable)

But why did he removed the last two parts? (0xf1 = 0f1f1 ???) ok.. so
let's try agaaaaain:

	0092 .. =>  146. 146 / 8 = 18. So 18 db, sounds reasonable,
though remember dvbsnoop reports 185 snr without anything connected,
if i take this as "noise" and want to remove it to get the real value
i'd have: 185 = 23 and 18 db - 23 db = -5 db.

So.. errm. WTF?

Who can enlighten me?

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
