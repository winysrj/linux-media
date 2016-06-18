Return-path: <linux-media-owner@vger.kernel.org>
Received: from meine-oma.de ([5.135.213.152]:55100 "EHLO meine-oma.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbcFRQTq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 12:19:46 -0400
Received: from localhost ([127.0.0.1] helo=webmail.meine-oma.de)
	by meine-oma.de with esmtp (Exim 4.87)
	(envelope-from <himbeere@meine-oma.de>)
	id 1bEIb0-0001xS-Ld
	for linux-media@vger.kernel.org; Sat, 18 Jun 2016 17:55:42 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_b59d1b9c348d4a7f924bc29538e1a128"
Content-Transfer-Encoding: 7bit
Date: Sat, 18 Jun 2016 17:55:41 +0200
From: Thomas Stein <himbeere@meine-oma.de>
To: linux-media@vger.kernel.org
Subject: dvb usb stick Hauppauge WinTV-soloHD
Message-ID: <abfe17ade84725100f405e5b1f6228b8@webmail.meine-oma.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=_b59d1b9c348d4a7f924bc29538e1a128
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Hello.

I'm trying to get a dvb usb stick Hauppauge WinTV-soloHD running. I saw 
there is general support already in the kernel.
https://git.linuxtv.org/media_tree.git/commit/?id=1efc21701d94ed0c5b91467b042bed8b8becd5cc

I'm able to use this device for dvb-t but not dvb-t2. I'm living in 
berlin so it should work. w_scan is scanning dvb-t2 and seems
to find channels:

Scanning DVB-T2...
Scanning 7MHz frequencies...
177500: (time: 02:17.828)
184500: (time: 02:19.828)
191500: (time: 02:21.876)
198500: (time: 02:23.924)
205500: (time: 02:25.971)
212500: (time: 02:27.971)
219500: (time: 02:30.021)
226500: (time: 02:32.071)
Scanning 8MHz frequencies...
474000: (time: 02:34.120)
482000: (time: 02:36.121)
490000: (time: 02:38.169)
498000: (time: 02:40.219)
506000: skipped (already known transponder)
514000: (time: 02:42.268)
522000: skipped (already known transponder)
530000: (time: 02:44.318)
538000: (time: 02:46.368)
546000: (time: 02:48.417)
554000: (time: 02:50.417)
562000: (time: 02:52.467)
570000: skipped (already known transponder)
578000: (time: 02:54.467)
586000: (time: 02:56.469)
594000: (time: 02:58.469)
602000: (time: 03:00.518)
610000: (time: 03:02.567)
618000: skipped (already known transponder)
626000: (time: 03:04.617)
634000: (time: 03:06.617)
642000: (time: 03:08.667)         signal ok:    QAM_AUTO f = 642000 kHz 
I999B8C999D999T999G999Y999P0 (0:0:0)
         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 (0:0:0) : 
updating transport_stream_id: -> (0:0:16481)
         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 (0:0:16481) 
: updating network_id -> (0:12352:16481)
         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 
(0:12352:16481) : updating original_network_id -> (8468:12352:16481)
         updating transponder:
            (QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 
(8468:12352:16481)) 0x0000
         to (QAM_AUTO f = 650000 kHz I999B8C999D999T32G16Y999P0 
(8468:12352:16481)) 0x4004
         new transponder: (QAM_AUTO f = 642000 kHz I999B8C0D0T32G16Y0P1 
(8468:12352:16497)) 0x4004
650000: skipped (already known transponder)
658000: skipped (already known transponder)
666000: (time: 03:10.382)
674000: (time: 03:12.429)
682000: skipped (already known transponder)
690000: (time: 03:14.476)
698000: (time: 03:16.528)
706000: skipped (already known transponder)
714000: (time: 03:18.575)
722000: (time: 03:20.623)
730000: (time: 03:22.669)
738000: (time: 03:24.716)
746000: (time: 03:26.764)
754000: skipped (already known transponder)
762000: (time: 03:28.811)
770000: (time: 03:30.860)
778000: skipped (already known transponder)
786000: (time: 03:32.908)
794000: (time: 03:34.953)
802000: (time: 03:36.999)
810000: (time: 03:39.045)
818000: (time: 03:41.045)
826000: (time: 03:43.091)
834000: (time: 03:45.137)
842000: (time: 03:47.185)
850000: (time: 03:49.231)
858000: (time: 03:51.277)

So the question is, what is going wrong? When i start vlc with dvb-t2 
channels file for berlin i get:

[00007f7e0c01a0e8] ts demux error: cannot peek

Any hints appreciated.

cheers
t.
--=_b59d1b9c348d4a7f924bc29538e1a128
Content-Transfer-Encoding: 7bit
Content-Type: application/pgp-keys;
 name=0xF5437AA0.asc
Content-Disposition: attachment;
 filename=0xF5437AA0.asc;
 size=5281

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2

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
=2FIa
-----END PGP PUBLIC KEY BLOCK-----

--=_b59d1b9c348d4a7f924bc29538e1a128--
