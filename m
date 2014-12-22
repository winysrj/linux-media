Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60206 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbaLVNhH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 08:37:07 -0500
Message-ID: <54981E79.5090601@gentoo.org>
Date: Mon, 22 Dec 2014 14:36:57 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>	<54972866.3030101@gentoo.org> <20141222112550.5f5e80c7@concha.lan.sisa.samsung.com>
In-Reply-To: <20141222112550.5f5e80c7@concha.lan.sisa.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.12.2014 14:25, Mauro Carvalho Chehab wrote:
> Em Sun, 21 Dec 2014 21:07:02 +0100
> Matthias Schwarzott <zzam@gentoo.org> escreveu:
> 
>> Hi!
>>
>> Should the commit message directly point to the breaking commit
>> 36efec48e2e6016e05364906720a0ec350a5d768?
> 
> Yes, if this fixes an issue that happened on a previous commit, then
> you should add the original commit there.
> 
> That likely means that this is a regression fix, right? So, you should
> c/c the patch to stable, adding a comment msg telling to what Kernel
> version it applies (assuming that the patch was merged on 3.18).
> Also, please add "PATCH FIX" to the subject, as this patch should be
> sent to 3.19 as well.
> 
>>
>> This commit hopefully reverts the problematic attach for the Starburst
>> card. I kept the GPIO-part in common, but I can split this also if
>> necessary.
> 
> Keep the GPIO part in common is better, if the GPIOs are the same.

Hi!

The GPIO-Pins that are used are the same on both cards. And I assume the
ones that control Si2165 on HVR-5500 are just unused on Starburst, so
setting them does not hurt (and Antti confirmed that the patch works).

The cards have more in common, but I could not find a clean way to share
attaching and TS-config of the DVB-S2 frontend.

So I will change the commit message, prefix subject with PATCH fix, and
resend the patch here and c/c to stable.

Regards
Matthias

