Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:43734 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbBMT6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 14:58:54 -0500
Received: by labms9 with SMTP id ms9so12623326lab.10
        for <linux-media@vger.kernel.org>; Fri, 13 Feb 2015 11:58:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150212215700.GA4882@turing>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
 <54D9E14A.5090200@iki.fi> <e65f6b905eae37f11e697ad20b97c37c@hardeman.nu>
 <CAEmZozPN2xDQMyao8GAYB1KqKxvgznn6CNc+LgPGhE=TJfDbFQ@mail.gmail.com>
 <32c10d8cd2303ed9476db1b68924170a@hardeman.nu> <CAEmZozP5jrJnWAF6ZbXtvkRveZE29BnSg+hO2x9KDSyPmjBBaQ@mail.gmail.com>
 <20150212095029.018f63df@recife.lan> <CAEmZozOTuigxavH_5M4mw5kDHS_mxgwLS53HipG2o4uvm_09OQ@mail.gmail.com>
 <20150212215700.GA4882@turing>
From: =?UTF-8?Q?David_Cimb=C5=AFrek?= <david.cimburek@gmail.com>
Date: Fri, 13 Feb 2015 20:58:22 +0100
Message-ID: <CAEmZozPKsBwq4=TtAOtR-LdjOi3k8MhmEqZ49gg8X48P1f5wdQ@mail.gmail.com>
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working
 since kernel 3.17
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-02-12 22:57 GMT+01:00 Luis de Bethencourt <luis@debethencourt.com>:
> On Thu, Feb 12, 2015 at 06:34:40PM +0100, David Cimbůrek wrote:
>> 2015-02-12 12:50 GMT+01:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
>> > Em Wed, 11 Feb 2015 17:41:01 +0100
>> > David Cimbůrek <david.cimburek@gmail.com> escreveu:
>> >
>> > Please don't top post. I reordered the messages below in order to get some
>> > sanity.
>> >
>> >>
>> >> 2015-02-11 15:40 GMT+01:00 David Härdeman <david@hardeman.nu>:
>> >> > Can you generate some scancodes before and after commit
>> >> > af3a4a9bbeb00df3e42e77240b4cdac5479812f9?
>> >>
>> >> Let me know what exactly do you want me to do (which commands, which
>> >> traces etc.). I'm not very familiar with the Linux media stuff...
>> >
>> > As root, you should run:
>> >
>> >         # ir-keytable -r
>> >
>> > This will print the scancodes and their key associations.
>> >
>> > Also, on what architecture are you testing?
>> >
>> > Regards,
>> > Mauro
>>
>> Output of the "ir-keytable -r" is available here:
>> http://pastebin.com/eEDu1Bmn. It is the same before and after the
>> patch.
>>
>> Architecture is x86_64.
>>
>>
>
> From the top-posted thread. Merging it here to not confuse people.
>
>> I'll try to describe my thoughts.
>>
>> The changed structure "dib0700_rc_response" is used in
>> dib0700_core.c:dib0700_rc_urb_completion(struct urb *purb) function:
>>
>> struct dib0700_rc_response *poll_reply;
>> ...
>> poll_reply = purb->transfer_buffer;
>>
>> dib0700_rc_urb_completion() is then used in
>> dib0700_core.c:dib0700_rc_setup() in macros usb_fill_bulk_urb and
>> usb_fill_int_urb. These macros are defined in header file usb.h. Here
>> I have found in macro description this:
>>
>>  * @transfer_buffer: pointer to the transfer buffer
>>
>> I suppose that it means that the struct dib0700_rc_response is being
>> filled from this transfer buffer. Therefore I suppose that the order
>> of structure members IS important.
>>
>> Of course it's only my guess but my patch is really working for me :-)
>
> Hi,
>
> I looked at this again and I still don't see why the order is important.
> Plus the code looks like it does what it should be doing when using
> RC_SCANCODE_NEC, RC_SCANCODE_NEC32, RC_SCANCODE_NECX and RC_SCANCODE_RC5.
>
> Unfortunately I can't review this if I am not sure about it, and I don't
> have the device to be able to properly test your patch.
>
> Hopefully your print of the scancodes helps.
>
> Luis

Hi,

unfortunately I don't understand the code very well but it really
works like I described.

I tried to get debugging output from the
dib0700_core.c:dib0700_rc_urb_completion() function:

deb_data("IR ID = %02X state = %02X System = %02X %02X Cmd = %02X %02X
(len %d)\n",
        poll_reply->report_id, poll_reply->data_state,
        poll_reply->system, poll_reply->not_system,
        poll_reply->data, poll_reply->not_data,
        purb->actual_length);

And the output after my patch (and before commit
af3a4a9bbeb00df3e42e77240b4cdac5479812f9!) looks like this:

[  282.842557] IR ID = 01 state = 01 System = 07 00 Cmd = 0F F0 (len 6)
[  282.955810] IR ID = 01 state = 02 System = 07 00 Cmd = 0F F0 (len 6)

But without my patch the output looks after commit
af3a4a9bbeb00df3e42e77240b4cdac5479812f9 like this:

[  186.302282] IR ID = 01 state = 01 System = 00 07 Cmd = 0F F0 (len 6)
[  186.415660] IR ID = 01 state = 02 System = 00 07 Cmd = 0F F0 (len 6)

You can see that the content of "system" and "not_system" is really switched...

Regards,
David
