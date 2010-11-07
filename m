Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51361 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0KGTBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Nov 2010 14:01:07 -0500
Received: by qyk12 with SMTP id 12so1303189qyk.19
        for <linux-media@vger.kernel.org>; Sun, 07 Nov 2010 11:01:07 -0800 (PST)
Subject: Re: [RFC PATCH 0/2] Apple remote support
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <AANLkTinNadDFESQNx7tiq8V6ksuoOSm_N0BXXe3evWq8@mail.gmail.com>
Date: Sun, 7 Nov 2010 14:01:04 -0500
Cc: =?iso-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D11E8396-BAB1-485E-AC60-D60319D1B5E0@wilsonet.com>
References: <20101029191711.GA12136@hardeman.nu> <20101029192733.GE21604@redhat.com> <20101029195918.GA12501@hardeman.nu> <20101029200937.GG21604@redhat.com> <20101030233617.GA13155@hardeman.nu> <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com> <20101101215635.GA4808@hardeman.nu> <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com> <37bb20b43afce52964a95a72a725b0e4@hardeman.nu> <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com> <20101104193823.GA9107@hardeman.nu> <4CD30CE5.5030003@redhat.com> <da4aa0687909ae3843c682fbf446e452@hardeman.nu> <AANLkTinNadDFESQNx7tiq8V6ksuoOSm_N0BXXe3evWq8@mail.gmail.com>
To: Christopher Harrington <ironiridis@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Nov 5, 2010, at 10:04 AM, Christopher Harrington wrote:

> On Fri, Nov 5, 2010 at 08:27, David Härdeman <david@hardeman.nu> wrote:
>> If you're referring to the pain caused by changing existing keytables
>> (thereby breaking custom keytables), I think it's inevitable. Throwing away
>> information is not a good solution.
>> 
>> As this subsystem progresses, there's going to be more and more reports of
>> remotes which, intentionally or unintentionally, do not follow the NEC
>> "standard" (I use that word in the most liberal sense). Using the full 32
>> bits allows us to support them without any module parameters or code
>> changes.
>> 
>> Which solution do you suggest?
> 
> What about reporting two key events: One with the Apple ID masked, and
> one with the Apple ID retained? The "default" keymap could then match
> the masked IDs, with the option of the user changing their keymaps to
> ignore the masked one and only "pair" with the specific IDs they're
> looking for?
> 
> As a bonus, they will be able to watch incoming scancodes to see the
> ID they might want to pair with, even though those scancodes would be
> ignored.

Interesting idea. But I think that 99% of the time, sending two scancodes is unnecessary overhead. I've got some reworked code I still need to test out which simply spits out the Apple remote's pair ID into dmesg w/core ir debugging enabled. If we're not pairing, its masked out in the full 32-bit scancode sent along, but still available via dmesg. If we are pairing, the pair byte is included in the full 32-bit scancode sent along.

-- 
Jarod Wilson
jarod@wilsonet.com



