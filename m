Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42582 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3HRS6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 14:58:22 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so3109804wes.19
        for <linux-media@vger.kernel.org>; Sun, 18 Aug 2013 11:58:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <trinity-f1bb3861-097c-4a3d-a374-a999bdb0fd9d-1376838057464@3capp-gmx-bs32>
References: <trinity-f1bb3861-097c-4a3d-a374-a999bdb0fd9d-1376838057464@3capp-gmx-bs32>
Date: Sun, 18 Aug 2013 14:58:20 -0400
Message-ID: <CALzAhNUh2Xs0T2Fr-rTg7T1Nt=3Y_qekVFeUT5-jquOFc2gN=Q@mail.gmail.com>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
From: Steven Toth <stoth@kernellabs.com>
To: Ulf <mopp@gmx.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I tried to apply the dvbsky-linux-3.9-hps-v2.diff to media_build.git (used do_patches.sh from http://www.selasky.org/hans_petter/distfiles/webcamd-3.10.0.7.tar.bz2), but I was not able to compile it. I already changed some includes, but then I got the next error.
> I just wanted to test if the si2168 module will work with si2165, but as I don't expect it to work I stopped trying to compile the si2168.

I don't see a si2165 driver in the tarball.

Did I miss something?

- Steve

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
