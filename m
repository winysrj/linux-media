Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rehuapila.uta.fi ([153.1.1.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pauli@borodulin.fi>) id 1JyQzG-0004XD-GE
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 14:30:39 +0200
Message-ID: <4832C453.5070306@borodulin.fi>
Date: Tue, 20 May 2008 15:30:11 +0300
From: Pauli Borodulin <pauli@borodulin.fi>
MIME-Version: 1.0
To: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
References: <482E114E.1000609@borodulin.fi>	<d9def9db0805161621n1a291192n8c15db11949b3dad@mail.gmail.com>	<4831B058.1030107@borodulin.fi>	<4831B70D.8050809@tungstengraphics.com>	<4831CC3F.803@borodulin.fi>
	<48320E0B.8090501@tungstengraphics.com>
	<48326CC4.7010401@borodulin.fi> <4832BE7D.2080808@hispeed.ch>
In-Reply-To: <4832BE7D.2080808@hispeed.ch>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Updated Mantis VP-2033 remote control patch for
 Manu's jusst.de Mantis branch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> On 20.05.2008 08:16, Pauli Borodulin wrote:
 >> [...]
>> Btw I found these in dvb-usb-remote.c:
>>
>>      input_dev->rep[REP_PERIOD] = d->props.rc_interval;
>>      input_dev->rep[REP_DELAY]  = d->props.rc_interval + 150;
>>
>> So there seems to be some configurable auto-repeat functionality in 
>> input layer. I guess I'll experiment with those even tho' RCs delays are 
>> a bit crappy, since it's a pretty painful to go through a long list of 
>> recordings without any auto-repeat...

Roland Scheidegger wrote:
> If you change these values (to anything but zero) before
> input_register_device, the input driver will just disable auto-repeat
> (or rather, you'd need to handle it yourself in the driver with the
> appropriate timer func, and I didn't feel like duplicating half the code
> of the input driver). input_register_device also says all capabilities
> must be set up before calling it, when I tried to change those values
> afterwards it didn't seem to work (though maybe I made some testing
> error, I can't see why it shouldn't work). I guess a REP_DELAY a bit
> over the initial delay (like 300ms) should work, and a REP_PERIOD of
> about 100 (which would give you about 50% chance of stopping pressing
> keys exactly) might be reasonable - though it really is annoying if you
> can't stop exactly (but it's not solvable - either live with slow repeat
> or live with that).

In dvb/ttpci/budget-ci.c there's a note:

         /* note: these must be after input_register_device */
         input_dev->rep[REP_DELAY] = 400;
         input_dev->rep[REP_PERIOD] = 250;

I wondered why and proceeded to kernel's drivers/input/input.c. There's
a note in input_register_device:

/*
  * If delay and period are pre-set by the driver, then autorepeating
  * is handled by the driver itself and we don't do it in input.c.
  */

init_timer(&dev->timer);
if (!dev->rep[REP_DELAY] && !dev->rep[REP_PERIOD]) {
	dev->timer.data = (long) dev;
	dev->timer.function = input_repeat_key;
	dev->rep[REP_DELAY] = 250;
	dev->rep[REP_PERIOD] = 33;
}

So it is different whether you set REP_DELAY & REP_PERIOD before or 
after calling input_register_device. If you set them before, it seems 
you are also expected to provide your own input_repeat_key function. If 
after, then... I guess input layer uses it's own logic, but just using 
customized REP_DELAY and REP_PERIOD.

I don't know why for example ttpci/av7110_ir.c uses it's own 
input_repeat_key function instead of using the logic provided by input 
layer. I will probably find this out later today when trying to 
experiment auto-repeat functionality.

Regards,
Pauli Borodulin

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
