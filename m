Return-path: <mchehab@gaivota>
Received: from alia.ip-minds.de ([84.201.38.2]:58844 "EHLO alia.ip-minds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543Ab0LSXom (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 18:44:42 -0500
Received: from localhost (pD9E18ED5.dip.t-dialin.net [217.225.142.213])
	by alia.ip-minds.de (Postfix) with ESMTPA id E6B2B1BE898E
	for <linux-media@vger.kernel.org>; Mon, 20 Dec 2010 00:36:16 +0100 (CET)
Date: Mon, 20 Dec 2010 00:35:45 +0100
From: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
To: linux-media@vger.kernel.org
Subject: General Question regarding SNR
Message-Id: <20101220003545.23fd62bd.jean.bruenn@ip-minds.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

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
