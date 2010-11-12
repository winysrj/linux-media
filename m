Return-path: <mchehab@pedra>
Received: from asmtpout029.mac.com ([17.148.16.104]:35658 "EHLO
	asmtpout029.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0KLUcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 15:32:45 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from [192.168.123.4] (dh207-84-122.xnet.hr [88.207.84.122])
 by asmtp029.mac.com
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 64bit))
 with ESMTPSA id <0LBS005PBH1XQQ50@asmtp029.mac.com> for
 linux-media@vger.kernel.org; Fri, 12 Nov 2010 12:32:25 -0800 (PST)
From: Damjan Marion <dmarion@me.com>
Date: Fri, 12 Nov 2010 21:32:21 +0100
Subject: issues with af9015
To: linux-media@vger.kernel.org
Message-id: <E82D79AD-40D8-4B59-BA4B-D633AEF3EC11@me.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi,

I have same issue with two different af9015 cards made by 2 different manufacturers with 2 different frontends.

When card is used with tvheadend software which constantly does idle scanning, after 1-2 days it starts showing following dmesgs:

[342924.332308] tda18218: i2c wr failed ret:-1 reg:1a len:3
[342925.152277] af9015: command failed:1
[342925.152293] tda18218: i2c wr failed ret:-1 reg:1a len:3
[342925.973596] af9015: command failed:1
[342925.973610] tda18218: i2c wr failed ret:-1 reg:1a len:3

Only way to recover it from this state is unplugging. Rebooting doesn't help as card stays powered during reboot.

Any idea what can cause this? Can I do any further debugging steps?

Thanks,

damjan

