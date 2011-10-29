Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38619 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab1J2QPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 12:15:03 -0400
Received: by eye27 with SMTP id 27so4219076eye.19
        for <linux-media@vger.kernel.org>; Sat, 29 Oct 2011 09:15:01 -0700 (PDT)
Message-ID: <4EAC2676.8030808@gmail.com>
Date: Sat, 29 Oct 2011 18:14:46 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Piotr Chmura <chmooreck@poczta.onet.pl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [RESEND PATCH 4/14] staging/media/as102: checkpatch fixes
References: <4E7F1FB5.5030803@gmail.com>	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>	<4E7FF0A0.7060004@gmail.com>	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>	<20110927094409.7a5fcd5a@stein>	<20110927174307.GD24197@suse.de>	<20110927213300.6893677a@stein>	<4E999733.2010802@poczta.onet.pl>	<4E99F2FC.5030200@poczta.onet.pl>	<20111016105731.09d66f03@stein>	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>	<4E9ADFAE.8050208@redhat.com>	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>	<20111018111151.635ac39e.chmooreck@poczta.onet.pl> <20111018215146.1fbc223f@darkstar> <4EABD3E2.3070302@gmail.com> <4EABFCF8.2010003@poczta.onet.pl>
In-Reply-To: <4EABFCF8.2010003@poczta.onet.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/29/2011 03:17 PM, Piotr Chmura wrote:
> 
> W dniu 29.10.2011 12:22, Sylwester Nawrocki pisze:
>> On 10/18/2011 09:51 PM, Piotr Chmura wrote:
>>> Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
>>>
>>> Original source and comment:
>>> # HG changeset patch
>>> # User Devin Heitmueller<dheitmueller@kernellabs.com>
>>> # Date 1267318701 18000
>>> # Node ID 69c8f5172790784738bcc18f8301919ef3d5373f
>>> # Parent b91e96a07bee27c1d421b4c3702e33ee8075de83
>>> as102: checkpatch fixes
>>>
>>> From: Devin Heitmueller<dheitmueller@kernellabs.com>
>>>
>>> Fix make checkpatch issues reported against as10x_cmd.c.
>>>
>>> Priority: normal
>>>
>>> Signed-off-by: Devin Heitmueller<dheitmueller@kernellabs.com>
>>> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
>> Hi Piotr,
>>
>> starting from this patch the series doesn't apply cleanly to
>> staging/for_v3.2 tree. Which branch is it based on ?
>>
>> ---
>> Thanks,
>> Sylwester
> Hi Sylwester,
> 
> I'is based on
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel-3.1.0-git9+
> 
> All patches are working on newly created driver directory drivers/staging/media/as102
> (exception is 13/14: staging/Makefile and staging/Kconfig) and they apply cleanly in
> my tree. Let me know why they doesn't on yours and i'll try to fix them.

I suspect the patch got mangled. The base tree shouldn't matter that much since
the patches are touching only the newly created directory.
With you previous patch set I'm getting an error at patch 5/11.


snawrocki@vostro:~/linux/media_tree$ git am -3 RESEND-1-14-staging-media-as102-initial-import-from-Abilis.patch
Applying: staging/media/as102: initial import from Abilis
snawrocki@vostro:~/linux/media_tree$ git am -3 RESEND-2-14-staging-media-as102-checkpatch-fixes.patch
Applying: staging/media/as102: checkpatch fixes
snawrocki@vostro:~/linux/media_tree$ git am -3 RESEND-3-14-staging-media-as102-checkpatch-fixes.patch
Applying: staging/media/as102: checkpatch fixes
snawrocki@vostro:~/linux/media_tree$ git am -3 RESEND-4-14-staging-media-as102-checkpatch-fixes.patch
Applying: staging/media/as102: checkpatch fixes
fatal: corrupt patch at line 664
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 staging/media/as102: checkpatch fixes
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".
snawrocki@vostro:~/linux/media_tree$ git apply --verbose --reject RESEND-4-14-staging-media-as102-checkpatch-fixes.patch
fatal: corrupt patch at line 702
snawrocki@vostro:~/linux/media_tree$ git ll
cbcbb4b staging/media/as102: checkpatch fixes
acde12d staging/media/as102: checkpatch fixes
d47fc51 staging/media/as102: initial import from Abilis
...

You are not using git send-email to send the patches, are you ? 

-- 
Regards,
Sylwester
