Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab0JKWG6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 18:06:58 -0400
Message-ID: <4CB38A7C.5040603@redhat.com>
Date: Mon, 11 Oct 2010 19:06:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media@vger.kernel.org, Gavin Hurlbut <gjhurlbu@gmail.com>
Subject: Re: [PULL] http://kernellabs.com/hg/~stoth/saa7164-v4l
References: <AANLkTima57h2Zz23y885AnyzWJOOUNWZxzt4o4gRjaUX@mail.gmail.com> <4CB37BB6.4050307@infradead.org>
In-Reply-To: <4CB37BB6.4050307@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-10-2010 18:03, Mauro Carvalho Chehab escreveu:
> Hi stoth,
> 
> Em 31-07-2010 17:42, Steven Toth escreveu:
>> Mauro,
>>
>> Analog Encoder and VBI support in the SAA7164 tree, for the HVR2200
>> and HVR2250 cards.
>>
>> Please pull from http://www.kernellabs.com/hg/~stoth/saa7164-v4l
>>
> 
> As requested on irc, I've pulled from your tree again, and fixed a few things
> on your patch series (a warning and _lots_ of checkpatch issues).
> 
> There are still some compilation breakages in the middle of your patch series.
> So, I'll fold some patches, in order to avoid the issues.
> 
> There are still a few checkpatch issues (I removed all 80-columns warning noise).
> Could you please double check them?
> 
> To make life easier for you, I've created a temp git tree at:
> 	http://git.linuxtv.org/mchehab/stoth.git

Stoth,

I realized that I missed a few patches on my queue. I've applied them also at the
git tree. There are a few issues on some of them:

    commit a5209649cb5aa8a706e6ed5ab74378f2f95c64bf
    Author: Steven Toth <stoth@kernellabs.com>
    Date:   Wed Oct 6 21:52:22 2010 -0300

    V4L/DVB: saa7164: Removed use of the BKL

    Remove usage of the BKL and instead used video_set_drvdata() during
       open fops.
    
    Signed-off-by: Steven Toth <stoth@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

There were some conflicts on this patch. Please verify that the conflict solve
went ok.

    commit 86ae40b5f3da13c5fd0c70731aac6447c6af4cd8
    Author: Gavin Hurlbut <gjhurlbu@gmail.com>
    Date:   Thu Sep 30 18:21:20 2010 -0300

    V4L/DVB: Fix the -E{*} returns in the VBI device as well

    commit f92f45822ce73cfc4bde8d61a75598fb9db35d6b
    Author: Gavin Hurlbut <gjhurlbu@gmail.com>
    Date:   Wed Sep 29 15:18:20 2010 -0300

    V4L/DVB: Fix the negative -E{BLAH} returns from fops_read

    commit 25b5ab78a5240c82baa78167e55c8d74a6e0a276
    Author: Gavin Hurlbut <gjhurlbu@gmail.com>
    Date:   Mon Sep 27 23:50:43 2010 -0300

    V4L/DVB: Change the second input names to include " 2" to distinguish them

Those three patches are missing your Signed-off-by: and Gavin's Signed-off-by:

Could you please provide it?

Thanks,
Mauro
