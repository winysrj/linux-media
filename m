Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0BBUD3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 15:03:29 -0500
Message-ID: <4B688507.606@redhat.com>
Date: Tue, 02 Feb 2010 18:03:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] -  tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de>
In-Reply-To: <4B685FB9.1010805@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 01.02.2010 23:52, schrieb Mauro Carvalho Chehab:
>> This struct is meant to pass static parameters to the driver. the analog/digital
>> mode is dynamic, so, this is not the right place for doing it.
>>
>>   
> Can you tell me how that work? Where would call it? Switch it after read
> demodulator status or before? This switch switches the  tuner output to
> the demodulator or adc input and if it read status before it switch
> thoughts the apps  "no digital found".

Basically, this is done by check_firmware. It is called by
	xc2028_set_analog_freq()
or
	xc2028_set_params()

So, when the frontend (digital) or the tuner (analog) is called to set an analog frequency
or to set DVB parameters.

All that it is needed for this to work is that both analog and DVB part should call
xc2028_attach() with the proper parameters.

For the analog side, you need a code like that (modified from em28xx-cards.c):

        if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type)) {
                tun_setup.type   = TUNER_XC2028;
                tun_setup.addr   = dev->tuner_addr;

                v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
        }

With this code, tuner-core set_type() will register the analog side of the driver.

For the digital part, you need to call xc2028_attach() manually (from em28xx-dvb):

        fe = dvb_attach(xc2028_attach, dev->dvb->frontend, &cfg);

When the driver wants to switch to an specific mode, all it needs is to set an analog or
digital frequency. The frontend or tuner driver will do the rest.

>>> @@ -45,6 +45,8 @@ struct zl10353_config
>>>      /* clock control registers (0x51-0x54) */
>>>      u8 clock_ctl_1;  /* default: 0x46 */
>>>      u8 pll_0;        /* default: 0x15 */
>>> +   
>>> +    int tm6000:1;
>>>     
>> This doesn't make sense. The zl10353 doesn't need to know if the device is
>> a tm6000 or not. If the tm6000 driver needs something special, then we need
>> to discover what he is doing and name the zl10353 feature accordingly.
>>
>>
>>   
> that is for todo in next week, when I switch from hack.c to zl10353
> kernel module, but it can remove if it don't use.

OK.

>>> +    tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x0b1f,0,data,2);
>>> +    printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
>>> +    msleep(40);
>>>     
>> The same comment here: maybe the above code only applies to tm6010.
>>
>>   
> It little different to the other hack code. The lastest lines are
> reading demod status.

If you're reading the demod status, the proper way is to call the corresponding
code at the tm6000-dvb part and use the standard i2c way of doing it.

The demod status depends on what demod you have, so the code there should be
board dependent. While currently only one demod is supported, there are devices
like Nova-S USB that have different demods (the Nova-S is DVB-S).

>>> --- a/drivers/staging/tm6000/tm6000-cards.c
>>> +++ b/drivers/staging/tm6000/tm6000-cards.c
>>> @@ -32,7 +32,7 @@
>>>  #include "tm6000.h"
>>>  #include "tm6000-regs.h"
>>>  #include "tuner-xc2028.h"
>>> -#include "tuner-xc5000.h"
>>> +#include "xc5000.h"
>>>     
>> Please send this hunk on a separate patch. Since it fixes compilation, I'll
>> need to apply it before the Kconfig changes, when tm6000 upstream.
>>
>>   
> o.k. but I cannot know how. I have no idea with diff or something.

The better way is to clone a tree and write your patches there, committing every
patch.

If you want to break an already existing diff into small diffs, you may copy it
by hand and remove the uneeded hunks.

For example, if you just save this into a file:

--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -32,7 +32,7 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 #include "tuner-xc2028.h"
-#include "tuner-xc5000.h"
+#include "xc5000.h"
 
 #define TM6000_BOARD_UNKNOWN			0
 #define TM5600_BOARD_GENERIC			1

and apply to your new tree, you'll have just one change there.

A hunk starts with @@. the numbers after "-" are the line number and the number of lines
of the original code. The numbers after "+" are the line number/line count after the patch.
For example, on this hunk:

@@ -402,6 +448,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		}
 #endif
 	}
+	return 0;
 
 err2:
 	v4l2_device_unregister(&dev->v4l2_dev);

It is changing the content of line number 402 of the source code. The original code has 6 lines
(the 3 lines before and the 3 lines after the insertion). It is adding one line (the line with "+").
The resulting code will be at line #448 and will have 7 lines.

If you copy the above, plus the name of the file to patch (the lines with --- and +++):

--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -402,6 +448,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		}
 #endif
 	}
+	return 0;
 
 err2:
 	v4l2_device_unregister(&dev->v4l2_dev);


You'll have a patch that just adds return 0.

On some cases like the above, it is just easier to edit the line and let the 
mercurial to generate the diff for you.

>> Those tuner callback initializations are board-specific. So, it is better to test
>> for your board model, if you need something different than what's currently done.
>>
>>   
> This tuner reset works with my stick, but I think that can test with
> other tm6000 based sticks and if it not works then I can say this as a
> board-specific.

It won't work on my boards. The GPIO pin used by each board is different.

>>> @@ -404,6 +432,7 @@ int tm6000_init (struct tm6000_core *dev)
>>>  {
>>>      int board, rc=0, i, size;
>>>      struct reg_init *tab;
>>> +    u8 buf[40];
>>>     
>> Why "40" ? Please avoid using magic numbers here, especially if you're
>> not checking at the logic if you're writing outside the buffer.
>>
>>   
> It important for tm6010 init sequence to enable the demodulator, because
> the demodulator haven't found after init tuner.

Probably, there is some i2c gate to enable/disable the i2c access to the
demodulator. The better way is to add a call to the tm6000-dvb and let it
init the demodulator.

Also, since there's a gate for the demodulator, the proper way is to add
a callback to control it. Please take a look at saa7134 and seek for i2c_gate_ctrl
to see how such logic works.

>> The reset code are device dependent. Please don't remove the previous code, or you'll
>> break the init for the other devices. Instead, add a switch above, checking for your
>> specific model. The better is to have all those device-specific initializations inside
>> tm6000-cards. Please take a look on how this is solved on em28xx driver.
>>
>>   
> GPIO 1 is the demodulator reset and gpio 4 is lo when tm6010 initialize.

This depends on the device. The GPIO are just a few pins that the board designer may do
whatever they want to control other devices. So, it is up to each vendor do decide to use
GPIO 1 or GPIO 7 or GPIO 5, or... for xc3028 reset. They decide it in order to simplify
the design of the wire tracks at the board layout. So, this changes from project to project.
>>>     
>> Insead, use tm6000_get_reg() or tm6000_set_reg(). Passing the USB direction as
>> 0x40/0xc0 is very ugly, and makes the code harder to understand.
>>
>>   
> I cannot use it, because it is a i2c transfer! The reading or writing
> data is in buf. (reading can it)

So, you should use i2c_master_recv/i2c_master_send. Or even better, this code should be
on an specific i2c driver for the component that it is being controlled.

>>>     
>> Also, this is device-specific.
>>   
> after tm6000 initialize gpio 4 go to high (GPIO 4 is lo if it
> initialze). I think when it device-specific is then for all tm6010!!
> GPIO 0 and 7 ?? GPIO 5 a/d switch (from tuner to demodulator or adc).

GPIO 4 is device specific. In a matter of fact, you'll likely find several
designs that will use the same GPIO's found at their reference design (simply
because there are several boards that use exactly the same layout). But this
shouldn't be a rule.
>>>     
>> Idem. All GPIO's are  device-specific.
>>
>>   
> GPIO 2 is tuner reset and can remove, I think.

Let the tuner-xc3028 driver control the tuner reset. It will call it at the
right time.
>>>  
>>>          dvb->frontend = pseudo_zl10353_attach(dev, &config,
>>> +//        dvb->frontend = dvb_attach (zl10353_attach, &config,
>>>     
>> Don't use C99 comments. Always comment with /* */
>>
>>   
> 
> all comments except frontend attach is don't from me, but I can convert it.

Yeah, this driver has still lots of coding style problems. You may do a latter
patch just fixing coding style. Yet, when you're adding new lines of code, the
better is to avoid increading the mess.

make checkpatch is your friend: it runs a script that checks if the current changes
aren't violating coding style.

Yet, don't bother so much with this right now. The code is already messed. At the end,
we can do a big cleanup patch.


> Can you tell me how I generate a patch set (detailed once).

README.patches contains some good explanations. I submitted yesterday an update to the
mailing list.

Basically, the better is to use git or mercurial (hg) for doing your development.
Git is a some years-light ahead Mercurial in terms of functionality, so I recommend you
to use it. Git were made by Linus Torvalds to be used on kernel development, so, it has all
kind of fancy features that every Kernel developer needs, and it is very fast. The downside
is that our -git tree has about 300GB (as it contains the entire kernel since version 2.6.12),
while the -hg has 48MB. So, the download time for -git is higher. However, after downloading, it
is faster than mercurial.

At the new README.patches, I've added a few examples on how to generate patches and to generate
emails with them using git.

A similar procedure can be done with mercurial, but exporting the patches to a series of
emails is more complicated, as it doesn't have anything equivalent to "git format-patch" (at least,
I don't know any similar feature). So, with -hg, you'll have to use some tricks to get a patch
series.

-- 

Cheers,
Mauro
