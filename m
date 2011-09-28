Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52630 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1I1E7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 00:59:35 -0400
Received: by wyg34 with SMTP id 34so7915041wyg.19
        for <linux-media@vger.kernel.org>; Tue, 27 Sep 2011 21:59:33 -0700 (PDT)
Date: Wed, 28 Sep 2011 14:59:29 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org
Subject: saa7134 + xc5000 long time work
Message-ID: <20110928145929.213ad266@glory.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

One of our customers report me about a strange bug. They use our TV card with DVB-T for capture a DVB-T signal and
transmit it to his network. TV card based on saa7134, xc5000, zl10353.
Main problem is: after 30 day of 24h working TV card can't lock a DVB-T signal. After rebooting all is normal.
Does Anybody have same as problem?

With my best regards, Dmitry.
