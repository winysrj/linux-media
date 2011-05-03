Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53466 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1ECK7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 06:59:30 -0400
Received: from mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.137])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id DF30F1720A2
	for <linux-media@vger.kernel.org>; Tue,  3 May 2011 12:59:28 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter8-d.gandi.net (mfilter8-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id G1EHbWyh4nCw for <linux-media@vger.kernel.org>;
	Tue,  3 May 2011 12:59:27 +0200 (CEST)
Received: from WIN7PC (ALyon-157-1-16-136.w81-251.abo.wanadoo.fr [81.251.55.136])
	(Authenticated sender: sr@coexsi.fr)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 1F646172088
	for <linux-media@vger.kernel.org>; Tue,  3 May 2011 12:59:27 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: DVB nGene CI : TS Discontinuities issues
Date: Tue, 3 May 2011 12:59:29 +0200
Message-ID: <004f01cc0981$2d371ec0$87a55c40$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear all,

I'm doing some tests with the CI interface of the "Linux4Media cineS2 DVB-S2
Twin Tuner (v5)" card.
I notice some TS discontinuities during my tests.

My setup:
- Aston Viaccess Pro CAM
- Linux4Media cineS2 DVB-S2 Twin Tuner (v5) card
- Latest git media_build source with DF_SWAP32 patch
- DVB-S source from ASTRA 19.2E / 12285.00-V-27500

Test #1: (idle)
Reading from sec0 (without CI init or sec0 input stream) using "dd" give me
a stream of NULL TS packets of roughly 62mbps or 7.8MB/s (seems normal
behavior)
Command line: dd if=/dev/dvb/adapter14/sec0 of=/root/test.ts bs=18800
count=10000

Test #2: (CAM removal)
After CAM initialization and some tests, if CAM is removed, the output sec0
bandwidth isn't anymore 62mbps of NULL TS packets
Same command line as Test #1 is used.
It seems that the CI is badly reacting after hot remove of CAM.
After rebooting, everything is fine again.

Test #3: (Test dvr0 stream)
- Setting up the DVB-S reception: gnutv -adapter 14 -channels channels.conf
-out dvr CHAINE
- Channel configuration: CHAINE:12285:v:0:27500:170:120:17030
- Dumping the dvr0 output: dd if=/dev/dvb/adapter14/dvr0 of=/root/test.ts
bs=1880 count=1000
=> The dvr0 output bandwidth is roughly 300kB/s (normal for one filtered
channel)
=> The resulting TS file is correct (no sync missing, no continuity error)

Test #4: (Loop mode - No CAM inserted)
- Sending all TS packets from dvr0 to sec0: dd if=/dev/dvb/adapter14/dvr0
of=/dev/dvb/adapter14/sec0 bs=1880
- Setting up the DVB-S reception: gnutv -adapter 14 -channels channels.conf
-out dvr CHAINE
- Channel configuration: CHAINE:12285:v:0:27500:170:120:17030
- Dumping the sec0 output: dd if=/dev/dvb/adapter14/sec0 of=/root/test.ts
bs=18800 count=10000
=> The sec0 output bandwidth is roughly 7.8MB/s (normal as the CI output is
always 62mbps)
=> The resulting TS file is filled at 96% by NULL TS packets (normal,
regarding the input stream bandwidth of 300kB/S)
=> All the input PID seem to present in the output file
=> But, there are some discontinuities in the TS packets (a lot and for all
the PID)

Test #5: (Trough CAM - CAM is inserted)
- Sending all TS packets from dvr0 to sec0: dd if=/dev/dvb/adapter14/dvr0
of=/dev/dvb/adapter14/sec0 bs=1880
- Setting up the DVB-S reception: gnutv -adapter 14 -channels channels.conf
-out dvr CHAINE
- Channel configuration: CHAINE:12285:v:0:27500:170:120:17030
- Waiting for CAM initialization (the CAM is correctly initialized and the
PMT packet is send to the CAM)
- Dumping the sec0 output: dd if=/dev/dvb/adapter14/sec0 of=/root/test.ts
bs=18800 count=10000
=> The sec0 output bandwidth is roughly 7.8MB/s (normal as the CI output is
always 62mbps)
=> The resulting TS file is filled at 96% by NULL TS packets (normal,
regarding the input stream bandwidth of 300kB/S)
=> All the input PID seem to present in the output file
=> The stream isn't decoded (normal as the CAT table isn't outputted by
gnutv)
=> But, there are some discontinuities in the TS packets (a lot and for all
the PID)

So, in summary, I'm observing discontinues when stream is going through the
sec0 device, if CAM is present or not.
Also, the CI adapter doesn't seem to react correctly when the CAM is hot
removed.
I can provide the TS files (from dvr0, from sec0 with CAM and without CAM)
if someone is interested.

Does someone has a setup that show no discontinuities when a TS stream is
going through sec0? (with an input TS file)
I would like to test it as for me the CI interface doesn't seem to work for
the nGene cards.

Best regards,
Sebastien.







