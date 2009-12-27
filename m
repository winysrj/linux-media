Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:50060 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZL0Qhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2009 11:37:39 -0500
To: linux-media@vger.kernel.org
cc: Manu Abraham <manu@linuxtv.org>
Subject: Mantis driver on TechniSat "CableStar HD 2"
From: Wolfgang Denk <wd@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Sun, 27 Dec 2009 17:37:36 +0100
Message-Id: <20091227163736.CC9C03F6D6@gemini.denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have problems getting a TechniSat "CableStar HD 2" DVB-C card
running with the latest Mantis driver on a Fedora 12 system (using
their current standard 2.6.31.9-174.fc12.i686.PAE kernel in
combination with the drivers from the http://linuxtv.org/hg/v4l-dvb
repository). Tests have been done on two different mainboards.

I can run a channel scan (using kaffeine) perfectly fine, also tuning
to channels appears to work. I see a load of some 1,300 interrupts per
sec when I have kaffeine running and tuned, and it seems there is data
transferred between the card and the application.

The problem is: there is no video nor sound.

I have bought this card second-hand on, so I am not really sure if it
is a software issue, or if eventually the hardware is broken.


Can anybody recommend a way how to verify the driver or the hardware?
Or can you recommend a specific kernel version the Mantis driver has
been tested against?

Any help welcome. Thanks in advance.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Another megabytes the dust.
