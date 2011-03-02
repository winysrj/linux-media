Return-path: <mchehab@pedra>
Received: from jabba.london.02.net ([82.132.130.169]:51636 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755636Ab1CBSUZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 13:20:25 -0500
Received: from tiber.centauri (188.222.111.86) by mail.o2.co.uk (8.5.119.05) (authenticated as ahoughton2005@o2.co.uk)
        id 4C63A9A336ACCA33 for linux-media@vger.kernel.org; Wed, 2 Mar 2011 18:14:09 +0000
Received: from [127.0.0.1] (helo=realh.co.uk)
	by tiber.centauri with esmtp (Exim 4.74)
	(envelope-from <h@realh.co.uk>)
	id 1PuqYo-0004wU-Hb
	for linux-media@vger.kernel.org; Wed, 02 Mar 2011 18:14:06 +0000
Date: Wed, 2 Mar 2011 18:14:04 +0000
From: Tony Houghton <h@realh.co.uk>
To: <linux-media@vger.kernel.org>
Subject: Hauppauge "grey" remote not working in recent kernels
Message-ID: <20110302181404.6406a3d2@realh.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Since upgrading my kernel from 2.6.32 to 2.6.37 in Debian my DVB remote
control no longer works. The card is a Hauppauge Nova-T PCI with the
"grey" remote. It uses the saa7146, tda1004x, budget_ci and budget_core
modules (but it doesn't actually have a CI).

There used to be a patch for the budget_ci driver to support this model
of remote because the driver's key mappings were incorrect, but that
patch was no longer necessary from about Linux 2.6.20 onwards. Has there
been a regression or is there a new problem?

FWIW I have two cards which used the saa7146, but the other one is DVB-S
and doesn't have a remote. The one with the remote is adapter1 and the
one without is adapter0. Could that have anything to do with the
problem?
