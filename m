Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45646 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZDIBF5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 21:05:57 -0400
Received: by bwz17 with SMTP id 17so374601bwz.37
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 18:05:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239227821.9855.5.camel@pc07.localdom.local>
References: <5d932cdc0904081249j59bccc7cg864753d22479d9a8@mail.gmail.com>
	 <1239227821.9855.5.camel@pc07.localdom.local>
Date: Thu, 9 Apr 2009 02:05:55 +0100
Message-ID: <5d932cdc0904081805q49f712b8sa27f1b8c89b05661@mail.gmail.com>
Subject: Re: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture
	Device
From: Thomas Horsten <thomas@horsten.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

2009/4/8 hermann pitton <hermann-pitton@arcor.de>:

> does it make any difference too with the current mercurial v4l-dvb ?
>
> I did not look any further, since some tones coming currently from above
> I don't like, more those from Linus after having 800 plus patches.

After installing the mercurial drivers and rebooting the symptoms are
exactly the same. Another tuner card in the same machine (a Hauppauge
Nova-T 500 Dual DVB-T) works fine.

If you have any ideas I am willing to experiment to get this to work
again. If I have some time over Easter I might try git-dissecting the
changes to find the patch that introduced the behaviour but since it
is running on quite a big server the turnaround time to reboot and try
new modules is about 30 minutes :(

Cheers
Thomas
