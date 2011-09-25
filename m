Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1IYLm3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 07:42:29 -0400
Message-ID: <4E7F13A1.30103@redhat.com>
Date: Sun, 25 Sep 2011 08:42:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: Status of the patches under review at LMML (28 patches)
References: <4E7DCE71.4030200@redhat.com> <CAHFNz9KJW1AYW8ZEofPYCbPfPrGdbhtFo-OVKvrY0gLxBpc2Jg@mail.gmail.com>
In-Reply-To: <CAHFNz9KJW1AYW8ZEofPYCbPfPrGdbhtFo-OVKvrY0gLxBpc2Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-09-2011 15:11, Manu Abraham escreveu:
> On Sat, Sep 24, 2011 at 6:04 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Everything at patchwork were reviewed by me, and I've applied all patches
>> that I didn't notice any review by the drivers maintainers.
>>
>> Driver maintainers:
>> Please review the remaining patches.
>>
>>                == Patches for Manu Abraham <abraham.manu@gmail.com> review ==
>>
>> Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.linuxtv.org/patch/3639   Florent AUDEBERT <florent.audebert@anevia.com>
> 
> A single byte doesn't make much of a difference, but well it is still
> a difference. The DiSEqC has some known issues and has some tricky
> workarounds for different Silicon cuts. This patch *might* be good on
> some chips while have an adverse effect. But that said I have not
> tested this patch.
> 
> If general users would like to have this patch and is proven good on
> different versions, I have no objection for this patch to go in.
> 
> In which case; Acked-by: Manu Abraham <manu@linuxtv.org>

Ok. Well, let's apply it and see the feedbacks if any.

Thanks for reviewing it!
Mauro
