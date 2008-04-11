Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JkLuD-0003Xl-Ci
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 18:15:18 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18be07c9.dyn.optonline.net [24.190.7.201]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZ60063154CKLB0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 11 Apr 2008 12:14:38 -0400 (EDT)
Date: Fri, 11 Apr 2008 12:14:36 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <Pine.LNX.4.64.0804110900070.3892@garbadale.math.wisc.edu>
To: Jernej Tonejc <tonejc@math.wisc.edu>
Message-id: <47FF8E6C.8030300@linuxtv.org>
MIME-version: 1.0
References: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
	<ea4209750804110226u18388307m48c629fe69b20d99@mail.gmail.com>
	<47FF69D7.5070209@linuxtv.org>
	<Pine.LNX.4.64.0804110900070.3892@garbadale.math.wisc.edu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV HD pro USB stick 801e
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

Jernej Tonejc wrote:
>>>
>>>     DIBcom 0700C-XCCXa-G
>>>     USB 2.0 D3LTK.1
>>>     0804-0100-C
>>>     -----------------
>>
>> Hmm. I haven't really used the dibcom src but I think this is already 
>> supported.
> Yes, this part works (I think this is responsible for attaching the IR 
> remote controler and the remote works).
> 
>>
>>>     SAMSUNG
>>>     S5H1411X01-Y0
>>>     NOTKRSUI H0801
>>
>> I have a driver for this, I hope to release it shortly.
> 
> I think this is the main problem for me so far. Without a frontend 
> attached it doesn't try to attach the tuner and the code for s5h1409 
> just doesn't find the demod at any address (I tried everything from 

Yeah, don't use the s5h1409, you're wasting your time.

...


>> The community could use more developers, why not roll up your sleeves 
>> and help solve your problem - and the problem for others? Everyone has 
>> to start somewhere and usually when would-be developers ask questions 
>> - everyone is willing to help.
> 
> I'll try to do my best - the problem is that I don't know where to begin
> and which parts are needed for the thing to work. It seems to me that 
> getting the code for s5h1411 would be the start since the dib0700 part 
> does work up to attaching the frontend. The /dev/dvb/adapter0/ folder 
> contains:
> crw-rw---- 1 root video 212, 4 2008-04-11 09:02 demux0
> crw-rw---- 1 root video 212, 5 2008-04-11 09:02 dvr0
> crw-rw---- 1 root video 212, 7 2008-04-11 09:02 net0
> 
> 
> I think the s5h1409 code is just not compatible with s5h1411. Also, the 
> GPIO settings are currently just copied from some other frontend 
> attaching function (stk7070pd_frontend_attach0):
> 
> static int s5h1411_frontend_attach(struct dvb_usb_adapter *adap)
> {
>         dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
>         msleep(10);
>         dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
>         dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
>         dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
>         dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
> 
>         dib0700_ctrl_clock(adap->dev, 72, 1);
> 
>         msleep(10);
>         dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
>         msleep(10);
>         dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
> 
>         /*dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
>                 &dib7070p_dib7000p_config); */
> 
>         adap->fe = dvb_attach(s5h1409_attach, &pinnacle_801e_config,
>                         &adap->dev->i2c_adap );
>         return adap->fe == NULL ? -ENODEV : 0;
> }

Wow, is this how the attach code inside the dibcom driver really looks? Eek.


> 
> I have NO idea what should be set to what values. Also, what is the 
> equivalent of dib7000p_i2c_enumeration for s5h14xx family? (it's 
> commented out in the above code as it does not work.
> Also, I have no previous experience with DVB stuff so I really don't 
> know which parts are independent from each other and how to test various 
> things on the device.

Hi Jernej,

The s5h1409 is a different beast to the s5h1411, so you're wasting your 
time trying to make that work.

That being said, I'm kinda surprised you're having i2c scan issues. I 
don't work with the dibcom src so maybe that's a true limitation of the 
part, or maybe something else is just plain broken on your design.

Googling/searching the mailing list, or reading the wiki's at 
linuxtv.org might show a reason why I2C scanning isn't supported.

In terms og the GPIO's, you'll need to understand which GPIO the xc5000 
tuner is attached to (because the xc5000 needs to toggle this). You 
might also need to drive other gpio's to bring the tuner, demod or any 
other parts out of reset - and able to respond to i2c commands. I tend 
to add /* comments */ around the GPIO code for each product detailing 
any gpio's I know (or suspect), which helps other devs maintain the code 
later in it's life.

Maybe you could make some progress with understanding why I2C scanning 
doesn't work, and perhaps dig deeping and try to establish which gpio's 
are connected to what.

With these two things, and a s5h1411 driver we should be able to get 
support for this product pretty easily.

Regards,

- Steve





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
