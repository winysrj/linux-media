Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:41925 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab0KLMM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 07:12:57 -0500
Date: Fri, 12 Nov 2010 13:12:53 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
Message-ID: <20101112121252.GB14033@hardeman.nu>
References: <4CDA94C6.2010506@infradead.org>
 <0bda4af059880eb492d921728997958c@hardeman.nu>
 <4CDAC730.4060303@infradead.org>
 <20101110220115.GA7302@hardeman.nu>
 <4CDBF596.6030206@infradead.org>
 <02f13638ea24016b5b3673b50940a91c@hardeman.nu>
 <4CDC1326.3030502@infradead.org>
 <20101111203501.GA8276@hardeman.nu>
 <AANLkTinjBOdnYfs=+HVxjaurbwEA33U2YwE0=bdz_Zto@mail.gmail.com>
 <4CDCBBF7.8050702@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CDCBBF7.8050702@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Nov 12, 2010 at 02:00:55AM -0200, Mauro Carvalho Chehab wrote:
>Em 11-11-2010 21:40, Jarod Wilson escreveu:
>> On Thu, Nov 11, 2010 at 3:35 PM, David Härdeman <david@hardeman.nu> wrote:
>>> On Thu, Nov 11, 2010 at 02:00:38PM -0200, Mauro Carvalho Chehab wrote:
>>>> A good exercise would be to port lirc-zilog and see what happens.
>>>
>>> I had a quick look at lirc-zilog and I doubt it would be a good
>>> candidate to integrate with ir-kbd-i2c.c (I assume that's what you were
>>> implying?). Which code from ir-kbd-i2c would it actually be using?
>> 
>> On the receive side, lirc_zilog was pretty similar to lirc_i2c, which
>> we dropped entirely, as ir-kbd-i2c handles receive just fine for all
>> the relevant rx-only devices lirc_i2c worked with. So in theory,
>> ir-kbd-i2c might want to just grow tx support, but I think I'm more
>> inclined to make it a new stand-alone rx and tx capable driver.
>
>It doesn't matter much if we'll grow ir-kbd-i2c or convert lirc_zilog.
>The point is that rc_register_device() should be called inside the i2c
>driver, but several parameters should be passed to it via platform_data,
>in a way that is similar to ir-kbd-i2c.

Yes, but if lirc_zilog doesn't use ir-kbd-i2c, there might not be a need
for the large number of rc-specific members in platform_data?

>Maybe one solution would be to pass rc_dev via platform_data.

Shouldn't platform_data be const? And you'll break the refcounting done
in rc_allocate_device() and rc_free_device() / rc_unregister_device().
Not to mention the silent bugs that may be introduced if anyone modifies
rc_allocate_device() without noticing that one driver isn't using it.

>>>> I like the idea of having an inlined function (like
>>>> usb_fill_control_urb), to be sure that all mandatory fields are
>>>> initialized by the drivers.
>>>
>>> I like the idea of having a function, let's call it
>>> rc_register_device(), which makes sure that all mandatory fields are
>>> initialized by the drivers :)
>> 
>> rc_register_device(rc, name, phys, id); to further prevent duplicate
>> struct members? :)
>
>Seems a good idea to me. It is easier and more direct to pass those info
>as parameter, than to have some code inside rc_register_device to check
>for the mandatory data.

See my reply to Jarod.

And also, rc_register_device() is anyway going to check other mandatory
fields so having it check all of them in one go is just good consistency
IMHO.

>> I still really like this interface change, even if its going to cause
>> short-term issues for i2c devices. I think we just extend this as
>> needed to handle the i2c bits. That said, I haven't really looked all
>> that closely at how much that entails...
>> 
>
>I think I'll apply the cx231xx fixes and then rebase the rc_register_device
>patch on the top of it, doing a minimal change at IR_i2c. Currently, we
>just need to pass one extra parameter. After this, we can work to improve
>it.

Meaning that you'll my patch with the rc_dev API the way it is basically
and then we can revisit the IR_i2c debate later if necessary? If that's
what you mean I'm all for it.

-- 
David Härdeman
