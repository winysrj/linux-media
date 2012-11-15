Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63304 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768379Ab2KOQbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 11:31:39 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so1440572lbb.19
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 08:31:38 -0800 (PST)
Message-ID: <50A518E8.8060002@googlemail.com>
Date: Thu, 15 Nov 2012 17:31:36 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Michael Yang <yze007@gmail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: The em28xx driver error
References: <loom.20121111T054512-795@post.gmane.org> <50A3CDCD.6020900@googlemail.com> <CAGoCfiwd0Dt49sZO_XEkv5rGwCj+nEDz0sGxw_j8oxKXE=NQAQ@mail.gmail.com>
In-Reply-To: <CAGoCfiwd0Dt49sZO_XEkv5rGwCj+nEDz0sGxw_j8oxKXE=NQAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.11.2012 18:05, schrieb Devin Heitmueller:
> On Wed, Nov 14, 2012 at 11:58 AM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> This looks indeed like a bug.
>> a >>= b means a = a >> b, which in this case means shifting height 480
>> or 576 bits to the right...
>> height >> 1 means height /= 2 which seems to be sane for interlaced devices.
>> OTOH, I wonder why it seems to be working on other platforms !?
>> Unfortunately I don't have an interlaced device here for testing. :(
> It's definitely a bug.  I think Mauro put a patch in for 3.7 or 3.8.
> The reason it works under x86 is because shifting an arbitrary number
> of bits > 32 causes indeterminate behavior, and out of dumb luck it
> has no effect on x86.
>
> But yeah, I changed the code to shift by one bit and it's been working
> fine on ARM for months in my environment (DM3730).
>
> Devin
Hmm... I've made some experiments to find out what gcc does on x86 and
it seems to ignore bit shifting > 32.
I also noticed that this line has been removed in 3.7-rc.
So we do NOT want to halve the height for interlaced devices here, right ?

Regards,
Frank
