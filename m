Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35912 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1LaAbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 19:31:31 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RgmrA-0006A2-VN
	for linux-media@vger.kernel.org; Sat, 31 Dec 2011 01:31:28 +0100
Received: from 69.red-80-32-146.staticip.rima-tde.net ([80.32.146.69])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 01:31:28 +0100
Received: from javier by 69.red-80-32-146.staticip.rima-tde.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 01:31:28 +0100
To: linux-media@vger.kernel.org
From: "Javier S. Pedro" <javier@javispedro.com>
Subject: Re: [PATCH 02/21] [media] tuner/xc2028: Fix frequency offset for
 radio mode.
Date: Sat, 31 Dec 2011 00:31:16 +0000 (UTC)
Message-ID: <jdll4j$ovk$1@dough.gmane.org>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
	<1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de>
	<4E5E7E2B.90603@redhat.com>
	<20110901051037.GB18473@avionic-0098.mockup.avionic-design.de>
	<4E5F7E71.5010209@aapt.net.au>
	<20110902081904.GA27008@avionic-0098.mockup.avionic-design.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Fri, 02 Sep 2011 10:19:05 +0200) Thierry Reding:
> So you are saying that the card was previously working for you, but
> when you apply the xc2028 patches from my series on top the tuning is
> off by 2.7 MHz?

I observed the 2.75Mhz offset nearly a year ago [1], but since I got 
silence on this ML I assumed it was a problem specific to my card and 
patched my kernel with a patch very similar to Thierry's.

Seeing some activity around this makes me happy, even if it's to confirm 
it is indeed a problem specific to my card or a set of cards.

In case anyone wants to start a list, my card is AverMedia PCI Hybrid (aka 
'A16D'). By Andrew's post we know Leadtek 1800 seems not to need the 
patch.

Javier.

[1] http://comments.gmane.org/gmane.linux.drivers.video-input-
infrastructure/24251

