Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.acens.net ([86.109.99.145]:21888 "EHLO smtp.movistar.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752256AbbBBPEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 10:04:39 -0500
Received: from webmail17.tnet (217.116.1.119) by smtp.movistar.es (8.6.122.03)
        id 54430CAB0351EDD5 for linux-media@vger.kernel.org; Mon, 2 Feb 2015 15:04:37 +0000
Date: Mon, 2 Feb 2015 16:04:37 +0100 (CET)
From: "DCRYPT@telefonica.net" <DCRYPT@telefonica.net>
Reply-To: DCRYPT@telefonica.net
To: linux-media@vger.kernel.org
Message-ID: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>
Subject: 
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_293915_33269809.1422889477490"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_293915_33269809.1422889477490
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

As I faced problems with my Terratec Cinergy T PCIe Dual and was unable to solve it (yet), I recently purchased a used Hauppauge HVR-2200 PCIe dual tuner. I immediately ran into problems with the HVR-2200 as well, perfectly described here:

http://whirlpool.net.au/wiki/n54l_all_in_one
(scroll down or search "saa7164_cmd_send() No free sequences")

Basically, it starts working but after a while I get an "Event timed out" message and several i2c errors and VDR shuts down (some hours after reboot). As the web page mentions, I tested downgrading the PCIe bandwith from GEN2 to GEN1 without success. But after playing with different BIOS options, what did the trick was limiting the power-saving C-states. If I select "C7" as the maximum C-state, the card fails as described. After limiting the maximum C-state to "C6", it has been working for a whole weekend.

The HVR-2200 was also tested in a GA-H67MA-UD2H-B3 board with an G1610 Celeron, working without problems (although maximum C-state setup was not checked).

Probably the error is present in other saa7164 boards.

My VDR server is based on BayTrail J1900 (Asrock Q1900M).

PS: I'm still waiting for advice regarding my Cinergy T/cx23885 problems and debugging. 
------=_Part_293915_33269809.1422889477490--
