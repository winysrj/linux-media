Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:46512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0H3Mun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 08:50:43 -0400
Message-ID: <4C7BA933.2020303@infradead.org>
Date: Mon, 30 Aug 2010 09:50:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Anton Blanchard <anton@samba.org>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: IR code autorepeat issue?
References: <e5clffplcfofw16tg9fp5t77.1283131265736@email.android.com>
In-Reply-To: <e5clffplcfofw16tg9fp5t77.1283131265736@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 29-08-2010 22:26, Andy Walls escreveu:
> How about a keycode sensitive repeat delay?
> A short delay for vol+/-, ch+/-, etc.
> A medium delay for digits, fast forward, rewind, pause, play, stop, etc.
> A long delay for power, mute, etc.

There are two separate things here:

1) we need to fix a bug introduced for some remotes;
2) We may improve the repeat code at rc subsystem.

For (1), a simple trivial patch is enough/desired. Let's first fix it, and then
think on improvements.

About a keycode sensitive delay, it might be a good idea, but there are some
aspects to consider:
	- a few remotes already do it. I have one or two remotes here that,
instead of using the remote protocol standard for key repeat for all keys, 
they simply implement their own logic, allowing repeat events only on a few
keys, (like vol and channel keys). So, conflicts may rise with hardware-driven
logic;
	- evdev already allows reading/replacing the repeat settings with 
EVIOCGREP/EVIOCSREP;
	- to do a per-key repeat events, it is needed to disable the
input repeat handling at the input subsystem and to implement our own logic inside
rc-core, or to use some ugly workarounds. It is needed to take some care when reinventing 
the wheel. Several old IR codes at drivers/media did some sort of their own repeat logic, 
some of them using a very odd logic;
	- it is needed to clearly define what's a short/medium/long delay, in terms of
two parameters: delay for starting to produce repeat key events and number of
repeat events per second;
	- it is needed to define what key will use the each delay timings, and 
what should be done with the other keys that don't match any delay lists;
	- a new API set of calls will be needed to set/get the delay timings lists,
and to associate a keycode with a specified delay time.
	
IMHO, this would add too much complexity for not much gain. 
> 
> Regards,
> Andy
> 
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
>> Em 29-08-2010 03:40, Anton Blanchard escreveu:
>>>
>>> I'm seeing double IR events on 2.6.36-rc2 and a DViCO FusionHDTV DVB-T Dual
>>> Express. I enabled some debug and it looks like we are only getting one IR
>>> event from the device as expected:
>>>
>>> [ 1351.032084] ir_keydown: i2c IR (FusionHDTV): key down event, key 0x0067, scancode 0x0051
>>> [ 1351.281284] ir_keyup: keyup key 0x0067
>>>
>>> ie one key down event and one key up event 250ms later. I wonder if the input
>>> layer software autorepeat is the culprit. It seems to set autorepeat to start
>>> at 250ms:
>>>
>>>         /*
>>>          * If delay and period are pre-set by the driver, then autorepeating
>>>          * is handled by the driver itself and we don't do it in input.c.
>>>          */
>>>         init_timer(&dev->timer);
>>>         if (!dev->rep[REP_DELAY] && !dev->rep[REP_PERIOD]) {
>>>                 dev->timer.data = (long) dev;
>>>                 dev->timer.function = input_repeat_key;
>>>                 dev->rep[REP_DELAY] = 250;
>>>                 dev->rep[REP_PERIOD] = 33;
>>>         }
>>>
>>> If I shorten the IR key up events to 100ms via the patch below the problem
>>> goes away. I guess the other option would be to initialise REP_DELAY and
>>> REP_PERIOD so the input layer autorepeat doesn't cut in at all. Thoughts?
>>
>>> Anton
>>> --
>>>
>>> diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
>>> index 7e82a9d..cf44d5a 100644
>>> --- a/drivers/media/IR/ir-keytable.c
>>> +++ b/drivers/media/IR/ir-keytable.c
>>> @@ -22,7 +22,7 @@
>>>  #define IR_TAB_MAX_SIZE	8192
>>>  
>>>  /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
>>> -#define IR_KEYPRESS_TIMEOUT 250
>>> +#define IR_KEYPRESS_TIMEOUT 100
>>
>> Yes, 250ms is too high, if we want to use REP_DELAY = 250ms.
>>
>> There's one issue on touching on this constant: it is currently just one global 
>> timeout value that will be used by all protocols. This timeout should be enough to
>> retrieve and proccess the repeat key event on all protocols, and on all devices, or 
>> we'll need to do a per-protocol (and eventually per device) timeout init. From 
>> http://www.sbprojects.com/knowledge/ir/ir.htm, we see that NEC prococol uses 110 ms
>> for repeat code, and we need some aditional time to wake up the decoding task. I'd
>> say that anything lower than 150-180ms would risk to not decode repeat events with
>> NEC.
>>
>> I got exactly the same problem when adding RC CORE support at the dib0700 driver. At
>> that driver, there's an additional time of sending/receiving URB's from USB. So, we
>> probably need a higher timeout. Even so, I tried to reduce the timeout to 200ms or 150ms 
>> (not sure), but it didn't work. So, I ended by just patching the dibcom driver to do 
>> dev->rep[REP_DELAY] = 500:
>>
>> commit 8dc09004978538d211ccc36b5046919489e30a55
>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date:   Sat Jul 31 23:37:19 2010 -0300
>>
>>    V4L/DVB: dib0700: avoid bad repeat
>>    
>>    a 250ms delay is too low for this device. It ends by producing false
>>    repeat events. Increase the delay time to 500 ms to avoid troubles.
>>    
>>    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
>> index 164fa9c..a05d955 100644
>> --- a/drivers/media/dvb/dvb-usb/dib0700_core.c
>> +++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
>> @@ -648,6 +648,9 @@ static int dib0700_probe(struct usb_interface *intf,
>>                        else
>>                                dev->props.rc.core.bulk_mode = false;
>>
>> +                 /* Need a higher delay, to avoid wrong repeat */
>> +                 dev->rc_input_dev->rep[REP_DELAY] = 500;
>> +
>>                        dib0700_rc_setup(dev);
>>
>> Maybe the better solution is to use, by default:
>> 	rc_input_dev->rep[REP_DELAY] = 500;
>> 	#define IR_KEYPRESS_TIMEOUT 250
>>
>> And, eventually, adding a patch to allow changing it per device.
>>
>> That's said, IMHO, 500ms is a very reasonable time for starting repeat with remotes. 
>> Opinions?
>>
>> Cheers,
>> Mauro.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

