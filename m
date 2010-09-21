Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58226 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0IUEoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 00:44:30 -0400
Received: by qyk36 with SMTP id 36so3478652qyk.19
        for <linux-media@vger.kernel.org>; Mon, 20 Sep 2010 21:44:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100920225527.GK25306@kryten>
References: <20100829064036.GB22853@kryten>
	<4C7A8056.4070901@infradead.org>
	<4C87BA04.7030908@redhat.com>
	<20100920225527.GK25306@kryten>
Date: Tue, 21 Sep 2010 00:44:29 -0400
Message-ID: <AANLkTimOb-LvDANq8O802c3w9svX8JefUhtdQjPor0BL@mail.gmail.com>
Subject: Re: IR code autorepeat issue?
From: Jarod Wilson <jarod@wilsonet.com>
To: Anton Blanchard <anton@samba.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Sep 20, 2010 at 6:55 PM, Anton Blanchard <anton@samba.org> wrote:
>
> Hi,
>
>> > > I'm seeing double IR events on 2.6.36-rc2 and a DViCO FusionHDTV DVB-T
>> > > Dual Express.
>> >
>> > There's one issue on touching on this constant: it is currently just one
>> > global timeout value that will be used by all protocols. This timeout
>> > should be enough to retrieve and proccess the repeat key event on all
>> > protocols, and on all devices, or we'll need to do a per-protocol (and
>> > eventually per device) timeout init. From
>> > http://www.sbprojects.com/knowledge/ir/ir.htm, we see that NEC prococol
>> > uses 110 ms for repeat code, and we need some aditional time to wake up the
>> > decoding task. I'd say that anything lower than 150-180ms would risk to not
>> > decode repeat events with NEC.
>> >
>> > I got exactly the same problem when adding RC CORE support at the dib0700
>> > driver. At that driver, there's an additional time of sending/receiving
>> > URB's from USB. So, we probably need a higher timeout. Even so, I tried to
>> > reduce the timeout to 200ms or 150ms (not sure), but it didn't work. So, I
>> > ended by just patching the dibcom driver to do dev->rep[REP_DELAY] = 500:
>>
>> Ok, just sent a patch adding it to rc-core, and removing from dib0700 driver.
>
> Thanks, tested and confirmed to work!
>
> I originally hit this on Ubuntu Maverick. Would you be OK if I submit it for
> backport to 2.6.35 stable?

Nb: both Fedora 14's and Ubuntu 10.10's 2.6.35 kernels have a
considerably newer IR stack than upstream 2.6.35, but this patch
should still be relevant to both, since I don't see it yet in the
Fedora tree, and the Ubuntu patches are more or less identical to at
least the first round of IR stack update patches in the Fedora kernel.
(Hm, I should actually give the Ubuntu folks some updated patches, but
I think they may be pretty well frozen already...) I'll take care of
updating the IR bits in the Fedora kernel, and will point some Ubuntu
folks in this direction as well.

-- 
Jarod Wilson
jarod@wilsonet.com
