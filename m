Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:41743 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932152AbeATAYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 19:24:05 -0500
Received: by mail-pg0-f48.google.com with SMTP id 136so2602004pgd.8
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 16:24:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHNoecsLq=9Sqk_8WZC+Gm1we13oyz9Mnh2Dfy8Y2U11O0PS2g@mail.gmail.com>
References: <CAHNoecsLq=9Sqk_8WZC+Gm1we13oyz9Mnh2Dfy8Y2U11O0PS2g@mail.gmail.com>
From: Jason Cameron <jazzyjas84@gmail.com>
Date: Sat, 20 Jan 2018 11:23:44 +1100
Message-ID: <CAHNoecuqrNAtqdY7hN0302EHdYQpb7REzuvSTFDx0e7GUVrioQ@mail.gmail.com>
Subject: Fwd: Distro-specific hint for media_build - Linux Mint Sylvia 18.3
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following error occurred when building media_build on Linux Mint 18.3:

***
Checking if the needed tools for Linux Mint 18.3 Sylvia are available
ERROR: please install "Proc::ProcessTable", otherwise, build won't work.
I don't know distro Linux Mint 18.3 Sylvia. So, I can't provide you a
hint with the package names.
Be welcome to contribute with a patch for media-build, by submitting a
distro-specific hint
to linux-media@vger.kernel.org
Build can't procceed as 1 dependency is missing at ./build line 274.
***

Issue can be resolved by installing libproc-processtable-perl (apt-get
install libproc-processtable-perl).

Cheers.

Jason.
