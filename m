Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:33655 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZJ2O2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 10:28:17 -0400
Received: by qyk4 with SMTP id 4so1134323qyk.33
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2009 07:28:22 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Oct 2009 10:28:21 -0400
Message-ID: <829197380910290728y5d885db7v34433dac73728fd5@mail.gmail.com>
Subject: Call for Testers: HVR-1600 Improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	ivtv-users@ivtvdriver.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

If you are an HVR-1600 user who has noticed the ClearQAM tuning
performance under Linux was worse than under Windows, the following
should make you happy.

There is now a tree that contains various fixes for ClearQAM tuning.
These have been measured to put the SNR performance on-par with the
Windows driver.

http://www.kernellabs.com/hg/~dheitmueller/hvr-1600-perf-2

The goal is to submit this upstream, but before that we want to get
some people to try it out first and submit feedback on their
experience.

Thanks go out to ONELAN Limited for sponsoring this work!

Feedback (good or bad) on the KernelLabs blog or the linux-media
mailing list would be appreciated.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
