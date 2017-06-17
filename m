Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:39111 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752727AbdFQLOL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 07:14:11 -0400
Date: Sat, 17 Jun 2017 13:14:05 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 3/7] rc-core: img-nec-decoder - leave the internals of
 rc_dev alone
Message-ID: <20170617111405.ynf5nledw7e5kfc6@hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
 <149365500692.13489.9572857464621441673.stgit@zeus.hardeman.nu>
 <20170522204030.GA22650@gofer.mess.org>
 <20170528082844.mba244bxuepuaqh7@hardeman.nu>
 <20170611160223.GA16107@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170611160223.GA16107@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 11, 2017 at 05:02:24PM +0100, Sean Young wrote:
>On Sun, May 28, 2017 at 10:28:44AM +0200, David Härdeman wrote:
>> On Mon, May 22, 2017 at 09:40:30PM +0100, Sean Young wrote:
>> >On Mon, May 01, 2017 at 06:10:06PM +0200, David Härdeman wrote:
>> >> Obvious fix, leave repeat handling to rc-core
>> >> 
>> >> Signed-off-by: David Härdeman <david@hardeman.nu>
>> >> ---
>> >>  drivers/media/rc/ir-nec-decoder.c |   10 +++-------
>> >>  1 file changed, 3 insertions(+), 7 deletions(-)
>> >> 
>> >> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
>> >> index 3ce850314dca..75b9137f6faf 100644
>> >> --- a/drivers/media/rc/ir-nec-decoder.c
>> >> +++ b/drivers/media/rc/ir-nec-decoder.c
>> >> @@ -88,13 +88,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>> >>  			data->state = STATE_BIT_PULSE;
>> >>  			return 0;
>> >>  		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
>> >> -			if (!dev->keypressed) {
>> >> -				IR_dprintk(1, "Discarding last key repeat: event after key up\n");
>> >> -			} else {
>> >> -				rc_repeat(dev);
>> >> -				IR_dprintk(1, "Repeat last key\n");
>> >> -				data->state = STATE_TRAILER_PULSE;
>> >> -			}
>> >> +			rc_repeat(dev);
>> >> +			IR_dprintk(1, "Repeat last key\n");
>> >> +			data->state = STATE_TRAILER_PULSE;
>> >
>> >This is not correct. This means that whenever a nec repeat is received,
>> >the last scancode is sent to the input device, irrespective of whether
>> >there has been no IR for hours. The original code is stricter.
>> 
>> I think that'd be an argument for moving the check to rc_repeat().
>
>It is.

And I just realised that the check is anyway incorrect since
dev->keylock isn't held when dev->keypressed is checked. rc_repeat() on
the other hand does the right thing, which is another argument for
moving the check.

>> But, on the other hand, sending an input scancode for each repeat event
>> seems kind of pointless, doesn't it? If so, it might make more sense to
>> just remove the input event generation from rc_repeat() altogether...
>
>At least there is something visible in user-space saying that a repeat
>has been received.

Yes, but I'm not sure what the value of that information is? The
MSC_SCAN events are mostly useful to create new keymaps for unknown
controls, additional repeat messages won't really be of any use there.

And generating repeat events has the disadvantage that userspace will be
woken up (how often is protocol dependent, but once every 110ms for NEC,
as an example) repeatedly while a button is pressed.

Anyway, I'll spin a new patch in two parts, one which makes the
behaviour consistent between decoders and one which removes the input
event altogether, then you can decide whether you want to merge the
second patch or not.

-- 
David Härdeman
