Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42737 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759691Ab2D0IuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 04:50:06 -0400
Message-ID: <4F9A5DB4.2000804@gentoo.org>
Date: Fri, 27 Apr 2012 10:49:56 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] b2c2_flexcop_pci: Add suspend/resume support
References: <201204151618.07719.stefan.bauer@cs.tu-chemnitz.de> <4F905095.5020604@redhat.com>
In-Reply-To: <4F905095.5020604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19.04.2012 19:51, Mauro Carvalho Chehab wrote:
> Hi Stefan,
>
> Em 15-04-2012 11:18, Stefan Bauer escreveu:
>> Dear linux-dvb developers, dear Matthias,
>>
>>
>> proper suspend and resume support for the b2c2_flexcop_pci driver is still missing as pointed out by these two bug reports:
>>
>> https://bugs.gentoo.org/show_bug.cgi?id=288267
>> https://bugzilla.kernel.org/show_bug.cgi?id=14394
>>
>> The first report contains a proposed patch to add suspend/resume support written by Matthias Schwarzott<zzam@gentoo.org>. I and some others (see first bug report) confirm that it's actually working.
>>
>> Behaviour without the patch: b2c2_flexcop_pci must be unloaded before suspending (means TV applications must be closed), and reloaded after resuming.
>> Behaviour with the patch: No module unloading/reloading necessary any more.
>> Known issues: TV application still needs to be closed before suspend. Otherwise the device is not functional (kaffeine shows only black screen) after resume. Reloading the module revives the device in that case.
>>
>> I'd kindly ask you to review the attached patch by Matthias and consider its upstream inclusion after the issues are sorted out. I'm more than willing to assist and test as I can.
> I don't have any b2c2 device, so I can't actually test it. on a quick lock,
> it seems sane on my eyes. In order for us to merge, we need the patch author's
> Signed-off-by.
Hi!

I do not remember exactly what were the open issues with this patch or 
how they could be solved, but if you want to merge the patch as it is, I 
am fine with this.
So here is my Signed-off-by:

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

