Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:55158 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZGTB7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 21:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <4A63CF1B.7010909@rtr.ca>
References: <4A631C8F.7000002@rtr.ca>
	 <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
	 <4A6337C1.6080104@rtr.ca> <4A63416E.2070103@rtr.ca>
	 <4A63A15F.8040804@rtr.ca>
	 <829197380907191812v185e0869j2e5fa47483a4de4c@mail.gmail.com>
	 <4A63CF1B.7010909@rtr.ca>
Date: Sun, 19 Jul 2009 21:59:45 -0400
Message-ID: <829197380907191859n64582aa1pb95dd524e292512b@mail.gmail.com>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
	branch
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 19, 2009 at 9:57 PM, Mark Lord<lkml@rtr.ca> wrote:
> Devin Heitmueller wrote:
>>
>> 2.  You hit the known analog audio issue that is preventing people
>> from using analog with MythTV.  I guess you can look at the analog
>> support as a work in progress - it works with most apps, but there is
>> something going on specific to MythTV that I haven't isolated yet.
>> Note this issue is completely related to the 950q analog project and
>> has nothing to do with the xc5000 tuner improvements.
>
> ..
>
> One additional thing I noticed here, is that when tuning analog
> for the first time, the firmware is reloaded yet again.. even though
> it has already been loaded once for "digital" operation.
>
> Perhaps the extra 6-7second delay here is contributing to Myth's problems.

That theory would be very easy to check.  Just modprobe xc5000 with
no_poweroff=1, load up under digital mode, and then try analog mode
and see if you hit the segfault.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
