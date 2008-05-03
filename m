Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
MIME-version: 1.0
Date: Sat, 03 May 2008 12:02:44 -0500 (CDT)
From: Jernej Tonejc <tonejc@math.wisc.edu>
In-reply-to: <47FF8E6C.8030300@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>
Message-id: <Pine.LNX.4.64.0805031148410.31846@garbadale.math.wisc.edu>
References: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
	<ea4209750804110226u18388307m48c629fe69b20d99@mail.gmail.com>
	<47FF69D7.5070209@linuxtv.org>
	<Pine.LNX.4.64.0804110900070.3892@garbadale.math.wisc.edu>
	<47FF8E6C.8030300@linuxtv.org>
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

On Fri, 11 Apr 2008, Steven Toth wrote:

> Hi Jernej,
>
> The s5h1409 is a different beast to the s5h1411, so you're wasting your time 
> trying to make that work.
>
> That being said, I'm kinda surprised you're having i2c scan issues. I don't 
> work with the dibcom src so maybe that's a true limitation of the part, or 
> maybe something else is just plain broken on your design.
>
> Googling/searching the mailing list, or reading the wiki's at linuxtv.org 
> might show a reason why I2C scanning isn't supported.
>
> In terms og the GPIO's, you'll need to understand which GPIO the xc5000 tuner 
> is attached to (because the xc5000 needs to toggle this). You might also need 
> to drive other gpio's to bring the tuner, demod or any other parts out of 
> reset - and able to respond to i2c commands. I tend to add /* comments */ 
> around the GPIO code for each product detailing any gpio's I know (or 
> suspect), which helps other devs maintain the code later in it's life.
>
> Maybe you could make some progress with understanding why I2C scanning 
> doesn't work, and perhaps dig deeping and try to establish which gpio's are 
> connected to what.
>
> With these two things, and a s5h1411 driver we should be able to get support 
> for this product pretty easily.

Hi Steve,

I managed to get the s5h1411 frontend attached for the Pinnacle HDTV PRO 
801e USB stick. I scanned through all i2c ports (in the code, command-line 
utils like i2cdump, i2cdetect don't work for some reason) and I got 
response on addresses 0x19, 0x1a, 0x44, 0x50. The first two are almost 
certainly related to the s5h1411 frontend. I suspect that xc5000 is 
sitting on 0x50. The problem however is that the reply to the 
XREG_PRODUCT_ID command is not one of the two replies that you have in 
your xc5000.c code. Originally it returned 0x423. After adding that as one 
of the replies (both for loading the fw and for not loading it), I tried 
to tune to some frequency but the tuning failed. Also, the USB device ID 
changed the next time I plugged it in, it's 10b8:0066 now (it was 
2304:0231 before). I have no idea what caused this. The device is still 
recognized (after I updated the IDs in the code) and the frontend gets 
attached and seems to work - the device accepts all commands for the 
s5h1411 part. But strangely, everytime I try to tune, the reply on 0x50 
i2c port changes. It only changes between unplugging and plugging in the 
card, not between repeated attempts to tune while the stick stays in. The 
few different replies I got so far are: 0x423 (original, with the 
original USB IDs, it never reappeared), 0x34d1, 0x14d1, 0x0f51, 0x0dd1.

The IR receiver works all the time and the dibcom firmware successfully 
loads every time.

What could be the reason for the USB device ID to change? It went from 
Pinnacle to DibCOM, so it is not completely random, but I have no idea how 
to get it back.

Jernej

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
