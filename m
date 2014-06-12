Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:38236 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbaFLLWa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:22:30 -0400
Message-ID: <53998D69.60901@dest-unreach.be>
Date: Thu, 12 Jun 2014 13:22:17 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
Subject: Re: [BUG & PATCH] media/rc/ir-nec-decode : phantom keypress
References: <538994CB.6020205@dest-unreach.be> <53980DF8.5040206@dest-unreach.be> <330c58e7d7849824b812db007c03b08d@hardeman.nu>
In-Reply-To: <330c58e7d7849824b812db007c03b08d@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-06-12 12:42, David Härdeman wrote:
> Hi,

Hi, thanks for the response


> the problem with triggering a keypress as soon as 32 bits have been
> received (i.e. before the trailing silence is detected)

Just for clarity: this patch does wait for the trailing silence. It does
NOT wait for the trailing silence to have (at least) a specific length.
(The pulse event is only fired after the pulse has ended, because the
length of the pulse needs to be known)


> is that it would
> cause phantom keypresses on some other protocols (I'm thinking of NEC48,
> which does exist in the wild).

I don't think the current code is able to decode NEC48. Is NEC48
recognizable in some other way than just being longer?

In that case, the alternative would be to start a timer when the
TRAILING_SPACE is entered, and trigger the key-event after, say 2 bit-times.


> Now, the question is why the trailing silence isn't generated within a
> reasonable time. Which hardware decoder do you use?

I use the IR receiver built in to the TBS6281 DVB-T tuner card. I also
have a TBS6982 DVB-S card, but I guess it's the same hardware.

It also depends on what "reasonable" means. I've found 300+ms, which is
unusable long.


Niels



> On 2014-06-11 10:06, Niels Laukens wrote:
>> I have not received any response on this email... so I hope to bump this
>> thread back to the more active region in most people's in-boxes.
>>
>>
>> On 2014-05-31 10:37, Niels Laukens wrote:
>>> Hi,
>>>
>>> I believe I've found a bug in the NEC decoder for InfraRed remote
>>> controls. The problem manifests itself as an extra keypress that happens
>>> when pushing different buttons in "rapid" succession.
>>>
>>> I can reproduce the problem easily (but not always) by pushing DOWN,
>>> DOWN,
>>> UP in "rapid" succession. I put "rapid" in quotes, because I don't
>>> have to
>>> hurry in any way, it happens when I use it normally. Depending on the
>>> duration of the presses, I get a number of repeats of DOWN. The bug is
>>> that an additional DOWN keypress happens at the time that I press the UP
>>> key (or so it seams).
>>>
>>> Attached is kernel-debug.log, which contains the redacted and annotated
>>> dmesg output, illustrating the problem described above. Especially note
>>> lines 31-36 and 54-59, where more than 200ms pass between the end of the
>>> IR-code and the actual emit of the keydown event.
>>>
>>>
>>> I've debugged this issue, and believe I've found the cause: The keypress
>>> is only emitted in state 5 (STATE_TRAILER_SPACE). This state is only
>>> executed when the space after the message is received, i.e. when the
>>> next pulse (of the next message) starts. It is only then that the length
>>> of the space is known, and that ir_raw_event will fire an event.
>>>
>>> The patch below addresses this issue. This is my first kernel patch.
>>> I've tried to follow all guidelines that I could find, but might have
>>> missed a few.
>>>
>>> I've tested this patch with the out-of-tree TBS drivers (which seem to
>>> be based on 3.13), and it solves the bug.
>>> I've compared this TBS-version with the current master (1487385). There
>>> are 8 (non-comment) lines that differ, none affect this patch. This
>>> patch applies cleanly to the current master.
>>>
>>> Regards,
>>> Niels
>>>
>>>
>>>
>>>
>>> From 071c316e9315f22a055d6713cc8cdcdc73642193 Mon Sep 17 00:00:00 2001
>>> From: Niels Laukens <niels@dest-unreach.be>
>>> Date: Sat, 31 May 2014 10:30:18 +0200
>>> Subject: [PATCH] drivers/media/rc/ir-nec-decode: fix phantom detect
>>>
>>> The IR NEC decoder waited until the TRAILER_SPACE state to emit a
>>> keypress. Since the triggering 'space' event will only be sent at the
>>> beginning of the *next* IR-code, this is way to late.
>>>
>>> This patch moves the processing to the TRAILER_PULSE state. Since we
>>> arrived here with a 'pulse' event, we know that the pulse has ended and
>>> thus that the space is there (as of yet with unknown length).
>>>
>>> Signed-off-by: Niels Laukens <niels@dest-unreach.be>
>>> ---
>>>  drivers/media/rc/ir-nec-decoder.c | 20 ++++++++++----------
>>>  1 file changed, 10 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/media/rc/ir-nec-decoder.c
>>> b/drivers/media/rc/ir-nec-decoder.c
>>> index 35c42e5..955f99d 100644
>>> --- a/drivers/media/rc/ir-nec-decoder.c
>>> +++ b/drivers/media/rc/ir-nec-decoder.c
>>> @@ -148,16 +148,6 @@ static int ir_nec_decode(struct rc_dev *dev,
>>> struct ir_raw_event ev)
>>>          if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT / 2))
>>>              break;
>>>
>>> -        data->state = STATE_TRAILER_SPACE;
>>> -        return 0;
>>> -
>>> -    case STATE_TRAILER_SPACE:
>>> -        if (ev.pulse)
>>> -            break;
>>> -
>>> -        if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
>>> -            break;
>>> -
>>>          address     = bitrev8((data->bits >> 24) & 0xff);
>>>          not_address = bitrev8((data->bits >> 16) & 0xff);
>>>          command        = bitrev8((data->bits >>  8) & 0xff);
>>> @@ -190,6 +180,16 @@ static int ir_nec_decode(struct rc_dev *dev,
>>> struct ir_raw_event ev)
>>>              data->necx_repeat = true;
>>>
>>>          rc_keydown(dev, scancode, 0);
>>> +        data->state = STATE_TRAILER_SPACE;
>>> +        return 0;
>>> +
>>> +    case STATE_TRAILER_SPACE:
>>> +        if (ev.pulse)
>>> +            break;
>>> +
>>> +        if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
>>> +            break;
>>> +
>>>          data->state = STATE_INACTIVE;
>>>          return 0;
>>>      }
>>>

