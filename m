Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64196 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab0JIOhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 10:37:21 -0400
Received: by ywi6 with SMTP id 6so245302ywi.19
        for <linux-media@vger.kernel.org>; Sat, 09 Oct 2010 07:37:20 -0700 (PDT)
References: <20101008211235.GF5165@redhat.com> <201010091147.25562.jorispubl@xs4all.nl>
In-Reply-To: <201010091147.25562.jorispubl@xs4all.nl>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <B782CDD2-F496-4007-949E-6278A1076A2B@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"lirc-list@lists.sourceforge.net" <lirc-list@lists.sourceforge.net>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 1/2] IR/lirc: further ioctl portability fixups
Date: Sat, 9 Oct 2010 10:36:17 -0400
To: Joris van Rantwijk <jorispubl@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 9, 2010, at 5:47 AM, Joris van Rantwijk <jorispubl@xs4all.nl> wrote:

> On Friday, October 08, 2010 23:12:35 Jarod Wilson wrote:
>> I've dropped the .compat_ioctl addition from Joris' original patch,
>> as I swear the non-compat definition should now work for both 32-bit
>> and 64-bit userspace. Technically, I think we still need/want a
>> Signed-off-by: from Joris here. Joris? (And sorry for the lengthy
>> delay in getting a reply to you).
> 
> No. I just tested the patch and it does not work without .compat_ioctl.

Okay, seems I misunderstood something then, thought the main one would be tried if the compat one wasn't wired. 

Will tack on another patch adding back .compat_ioctl where needed, thanks for testing!

-- 
Jarod Wilson
jarod@wilsonet.com

