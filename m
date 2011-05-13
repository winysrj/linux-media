Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:50957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1EMGqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 02:46:48 -0400
Message-ID: <4DCCD3D6.4070400@infradead.org>
Date: Fri, 13 May 2011 08:46:46 +0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manoel PN <pinusdtv@hotmail.com>
CC: linux-media@vger.kernel.org, lgspn@hotmail.com
Subject: Re: [PATCH 1/4] Modifications to the driver mb86a20s
References: <BLU157-w6C6865120D491FB84946AD8880@phx.gbl>
In-Reply-To: <BLU157-w6C6865120D491FB84946AD8880@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-05-2011 04:02, Manoel PN escreveu:
> 
> Hi to all,
> 
> I added some modifications to the driver mb86a20s and would appreciate your comments.
> 
>>
>> File: drivers/media/dvb/frontends/mb86a20s.c
>>
>> -static int debug = 1;
>> +static int debug = 0;
>> module_param(debug, int, 0644);
>> MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
>>
>  
> How is in the description by default debug is off.

Breaking it into smaller patches it the proper way to get it upstreamed. However, 
each logical change should be sent into its your own patch.

For example, in this case, you should be sending a one-line patch just fixing the
debug parameter, with a description like:

[PATCH 1/xx] Disable debug by default

The mb86a20s is producing debug information by default. This is not
the expected behavior. Also, the parameter description tells that the
default should be 0. So, fix it.

Signed-off-by: ...

> 
>>
>> -#define rc(args...)  do {
>> +#define printk_rc(args...)  do {
>>
> 
> For clarity, only rc is somewhat vague.
> 

The same as above applies here.

The first two changes are OK for me, and I would have applied them if you
were sending one logic change by patch.

>>
>> +static int mb86a20s_i2c_gate_ctrl(struct dvb_frontend *fe, int enable) 
>>
> 
> Adds the i2c_gate_ctrl to mb86a20s driver.
> 
> 
> The mb86a20s has an i2c bus which controls the flow of data to the tuner. When enabled, the data stream flowing normally through the i2c bus, when disabled the data stream to the tuner is cut and the i2c bus between mb86a20s and the tuner goes to tri-state. The data flow between the mb86a20s and its controller (CPU, USB), is not affected.
> 
> In hybrid systems with analog and digital TV, the i2c bus control can be done in the analog demodulator.
> 
>>
>> -    if (fe->ops.i2c_gate_ctrl)
>> -        fe->ops.i2c_gate_ctrl(fe, 0);
>>     val = mb86a20s_readreg(state, 0x0a) & 0xf;
>> -    if (fe->ops.i2c_gate_ctrl)
>> -        fe->ops.i2c_gate_ctrl(fe, 1);
>>
> 
> The i2c_gate_ctrl controls the i2c bus of the tuner so does not need to enable it or disable it here.
>

Those two changes are moving the responsibility of handling the i2c gate
control to happen outside the demod. If applied as-is, it will break the
boards already supported, causing a regression. One of the rules for a patch
to be applied is that no regressions are accepted. So, if you need to change
it, for whatever reason, you should take a look at the existing cases and
fix the logic (or try to) at the existing drivers.
 
> 
>>
>> +    for (i = 0; i < 20; i++) {
>> +        if (mb86a20s_readreg(state, 0x0a) >= 8) break;
>> +        msleep(100);
>> +    }
>>
> 
> Waits for the stabilization of the demodulator.

Ok, makes sense to me.

Again, this change should be separate. One of the reasons why we need
separate logical changes is that a patch from the series may cause some
regressions. By having one logical change per patch, fixing the regression
is as simple as reverting one git patch. However, if you mix two different
things at the same patch, reverting it will be very painful.
> 
>>
>> +static int mb86a20s_get_algo(struct dvb_frontend *fe)
>> +{
>> +    return DVBFE_ALGO_HW;
>> +}
>>
> 
> Because the mb86a20s_tune function was implemented.

Ok. Same as above: please break mb86a20s_tune() implementation into
a separate patch.

> 
> Thanks, best regards,
> 
> Manoel.
> 
> 
> Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
> 
> 
> 
>  		 	   		  =

