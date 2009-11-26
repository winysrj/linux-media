Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep27-int.chello.at ([62.179.121.47]:44232 "EHLO
	viefep27-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZKZMoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 07:44:04 -0500
Received: from edge05.upc.biz ([192.168.13.212]) by viefep17-int.chello.at
          (InterMail vM.7.09.01.00 201-2219-108-20080618) with ESMTP
          id <20091126115550.JFKK18225.viefep17-int.chello.at@edge05.upc.biz>
          for <linux-media@vger.kernel.org>;
          Thu, 26 Nov 2009 12:55:50 +0100
Message-ID: <4B0E6CC0.9030207@waechter.wiz.at>
Date: Thu, 26 Nov 2009 12:55:44 +0100
From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Mantis =?UTF-8?B?4oCTIGFueW9uZT8=?=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am now playing around with the available code for quite some time now
with mixed success, but no solution comes near the term “stable”.

• kernel: nothing in there. Well, reasonable.
• v4l-dvb: nothing in there.
• s2-liplianin: mantis available, but obviously not under
development/bugfixing. IR seems to work, CI handling looks quite broken,
hangups/lockups are the rule, additional problems with more than one of
these cards in the system.
• mantis-v4l: does not compile out of the box for recent kernels. When
hand-knitting the files into a kernel source directory (2.6.31), works
quite unstable, module reloading frequently segfaults. IR does not work
(at least for VDR), CI handling looks better than s2-liplianin.

Conclusion: Stability is way below a level for reasonable usage while
bug fixing.

[1] gives an overview of the current state of (non-)development. Does
this still apply?

My questions are:

• Is there someone feeling responsible for that baby?
• What is the main part of the mantis stuff not working – mantis itself,
the frontend, or adaptions from multiproto to s2api?
• What can someone owning some of these cards (one Terratec, two
Technisat) do to help the (former) authors to continue their work?
• Is there some documentation available which would enable ‘the
community’ to work on that further?

Cheers,
– Matthias

1:
http://linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_%28VP-1041%29#Drivers
