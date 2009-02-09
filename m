Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:44073 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbZBIO5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 09:57:36 -0500
Received: by gxk14 with SMTP id 14so1709541gxk.13
        for <linux-media@vger.kernel.org>; Mon, 09 Feb 2009 06:57:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.1.10.0902091249420.21232@pub2.ifh.de>
References: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net>
	 <412bdbff0902081100q4e625a59p42cba55d942010bc@mail.gmail.com>
	 <77294D52-7BCA-4E11-A589-861692FAA513@alice-dsl.net>
	 <alpine.LRH.1.10.0902091249420.21232@pub2.ifh.de>
Date: Mon, 9 Feb 2009 09:57:34 -0500
Message-ID: <412bdbff0902090657q20d9076er6d0eb278204ce4a9@mail.gmail.com>
Subject: Re: Use ir_keymaps.c for dibcom driver (was: Re: [PATCH] Add Elgato
	EyeTV Diversity to dibcom driver)
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: =?ISO-8859-1?Q?Michael_M=FCller?= <mueller_michael@alice-dsl.net>,
	pboettcher@dibcom.fr, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 9, 2009 at 6:54 AM, Patrick Boettcher
<patrick.boettcher@desy.de> wrote:
> Hi,
>
> On Sun, 8 Feb 2009, Michael Müller wrote:
>>>
>>> While I am indeed strongly in favor of integrating dib0700 with
>>> ir_keymaps.c so it is consistent with the other drivers, I have been
>>> tied up in another project and haven't had any cycles to do the work
>>> required.
>>>
>>> By all means, if you want to propose a patch, I would be happy to
>>> offer feedback/comments.
>>
>> Hi Devin,
>>
>> yes, it was my intention to offer some help.
>>
>> My hope was to find some similarities that I could use for dibcom. But
>> everything looks different. And they deal with GPIO. So it looks much more
>> complicated than just simply adding some keys to a table. ;-)
>>
>> Do you have an idea which of the modules listed above is closest to the
>> dibcom module? Can you (easily) create a frame/template that I can use for a
>> start and I add details and does the testing?
>>
>> Is the existing ir_keymaps approach already able to handle the case that I
>> need to set dvb_usb_dib0700_ir_proto=0 (=> no NEC protocol) for my Elgato?
>
> If you are going to ir_keymap or any other superior solution (which I'm
> for), please don't consider the dib0700-driver only, but think about the
> whole dvb-usb-framework... Only the driver specific part can be found in the
> drivers. The input-stuff is located in dvb-usb-remote.c
>
> Loading the ir-tables from userspace would be the preferred solution, like
> that any IR-receiver on any device could handle any remote-control
> (requiring a generic IR-decoder in the device's firmware) without changing
> the kernel-module-driver...
>
> Is lirc already in-kernel now? Can the event-interface handle raw keys (so
> that a user-space thing could translate them to their real meaning?)
>
> Patrick.
>
> --
>  Mail: patrick.boettcher@desy.de
>  WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

Hello,

Just to be clear, I agree completely with Patrick and did not intend
for it to come across that the solution should be dib0700 specific.  I
mentioned it in the context of dib0700 because that is the device the
user is experiencing the issue with, as well as the only device in the
dvb_usb framework I am personally familiar with.

Regarding lirc, this is a challenging issue:

On one hand, it is logical for the remote control definitions to be in
userland, as this allows the user to change the keymaps easily, and
the IR receiver could be seen by the kernel as "just another RC5 or
RC6 receiver".

On the other hand, the in-kernel management allows it to work as it
did before without the need for lirc, as well as allowing the driver
implementer to provide the "default keymap" associated with the remote
control that ships with the product.  If the keymaps were in the lirc
userland package then the developer would have to ensure that the
userland package got updated in all the distributions, as well as the
users getting lircd to work properly (which given the debugging in the
daemon, is an *enormous* challenge for most users).

At this point, I think the goal should be to get as many of the
drivers as possible centralized into ir_keymaps.  This allows the
drivers to behave consistently, and if we can come up with a userland
solution then it can be supported for every device at the same time.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
