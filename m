Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52459 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1ALQTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 11:19:16 -0500
Received: by pwj3 with SMTP id 3so112506pwj.19
        for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 08:19:16 -0800 (PST)
Message-ID: <4D2DD47E.8030307@gmail.com>
Date: Wed, 12 Jan 2011 17:19:10 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com> <4D2CD262.2070601@redhat.com>
In-Reply-To: <4D2CD262.2070601@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/11/2011 10:57 PM, Mauro Carvalho Chehab wrote:
> Em 03-01-2011 14:48, Sylwester Nawrocki escreveu:
>> Hi Mauro,
>>
>> Please pull from our tree for the following items:
>>
>> 4. s5p-fimc driver conversion to Videbuf2 and multiplane ext. and various
>>     driver updates and bugfixes,
>> 5. Siliconfile NOON010PC30 sensor subdev driver,
> 
> Those patches seem ok. I have just a couple comments about them. See bellow.
> 
> After having them solved, please send the patches against my vb2 test tree:
> 
> 	git://linuxtv.org/mchehab/experimental.git vb2_test
> 
> I've tested already vb2 with vivi. I'll be testing them now with saa7134.
> After testing it, I'll give you a feedback about vb2 and, if ok, I'll merge
> both multiplane and vb2 on my main tree.
> 
>> Hyunwoong Kim (5):
>>        [media] s5p-fimc: fix the value of YUV422 1-plane formats
> 
> I don't have an arm cross-compilation handy, but... that means that, before this
> patch, compilation were broken? If so, please, don't do that, as it breaks bisect.
> Instead, merge the patch withthe one that broke compilation.

No, the purpose of this patch is to only change the values programmed
into the H/W registers. The patch summary line seem not to be 
too accurate. This patch doesn't fix any compilation problems. 

I always try to test the patches against compilation breakage one by one.
But this time unfortunately I didn't do enough tests of the mem2mem
conversion changes when sending the pull request.


Regards,
Sylwester



