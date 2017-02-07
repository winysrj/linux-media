Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:51175 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753230AbdBGLJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 06:09:37 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 2BE3220B8D
        for <linux-media@vger.kernel.org>; Tue,  7 Feb 2017 12:09:36 +0100 (CET)
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 3vHhSH3V5mz106P
        for <linux-media@vger.kernel.org>; Tue,  7 Feb 2017 12:09:35 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Feb 2017 12:09:35 +0100
From: hpb <hpbiege@posteo.de>
To: linux-media@vger.kernel.org
Subject: DVB-T2 Stick
Reply-To: hpbiege@posteo.de
Message-ID: <550f82eb34a61ce50316e58108bf486d@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After executing: media_built_driver installataion (compiled/restarted) 
on Ubuntu 16:04 Kernel 4.0.4-62
NVIDIA UNIX x86_64 Kernel Module 340.101
DVBSky T330 DVB-T2/c Tuner (=Sit2168) (Works perfectly on WIN 10)

Old DVB-T works well on Linux. DVB-T2 (H265) is awful - stop and go and 
stop...

> WARNING: You are using an experimental version of the media stack. As 
> the driver is backported to an older kernel, it doesn't offer enough 
> quality for its usage in production. Use it with care.
> Latest git patches (needed if you report a bug to 
> (...vger.kernel.org...): 47b037a0512d9f8675ec2693bed46c8ea6a884ab
> 
> [media] v4l2-async: failing functions shouldn't have side effects 
> 79a2eda80c6dab79790c308d9f50ecd2e5021ba3
> 
> [media] mantis_dvb: fix some error codes in mantis_dvb_init() 
> c2987aaf0c9c2bcb0d4c5902d61473d9aa018a3d
> 
> [media] exynos-gsc: Avoid spamming the log on VIDIOC_TRY_FMT

DVB-T2 is standard in Germany now. Linux Kernels should support it 
without gymnastics after each Kernel-update...
  Please help
  And thanks a lot!
  hpb
  --

-------------------------

Hans-Peter Biege Immenweg 11
  12169 Berlin
fon: +49 (0) 30-60938290
  fax: +49 (0) 3212-6121902
  mob: +49 (0) 151-21731494
  post: hpbiege@posteo.de

-------------------------
