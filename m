Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4.bt.bullet.mail.ird.yahoo.com ([212.82.108.235]:40442 "HELO
	nm4.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752282Ab1LFW44 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 17:56:56 -0500
Message-ID: <1323211822.9609.YahooMailNeo@web86401.mail.ird.yahoo.com>
Date: Tue, 6 Dec 2011 22:50:22 +0000 (GMT)
From: JULIAN GARDNER <joolzg@btinternet.com>
Reply-To: JULIAN GARDNER <joolzg@btinternet.com>
Subject: Irdeto Cam Problem, any help
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Been trying now to get my IrdetoCam and card working, im using mumudvb for this.

Turning on debug i get the folowing in the output

nfo:  Autoconf:  Channel number :   0, name : "ERT World"  service id 0 
Info:  Autoconf:      Multicast4 ip : 227.25.0.1:1234
Deb0:  Autoconf:          pids : 5001 (PMT), 1160 (Video (MPEG4-AVC)), 1120 (Audio (MPEG2)), 
Info:  Main:  Channel "ERT World" is
 now higly scrambled (97% of scrambled packets). Card 0
en50221_tl_handle_sb: Received T_SB for connection not in T_STATE_ACTIVE from module on slot 00

en50221_stdcam_llci_poll: Error reported by stack:-7

Deb1:  CAM:  Status change from EN50221_STDCAM_CAM_INRESET to EN50221_STDCAM_CAM_OK.
WARN: 
 CAM:  Transport Layer Error change from EN50221ERR_NONE (No Error.) to 
EN50221ERR_BADCAMDATA (CAM supplied an invalid request.)
Deb1:  CAM:  CAM Application_Info_Callback
Info:  CAM:  CAM Application type: 01
Info:  CAM:  CAM Application manufacturer: cafe
Info:  CAM:  CAM Manufacturer code: babe
Info:  CAM:  CAM Menu string: Irdeto Access

Now can anybody help with the -7 error, as i am getting no decryption.

Patches would be welcome, before i start trying to delve deeper in

joolz
