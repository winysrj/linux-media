Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from v-smtp-auth-relay-4.gradwell.net ([79.135.125.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <chris@slavesoftware.co.uk>) id 1JzjOY-0004tC-Pm
	for linux-dvb@linuxtv.org; Sat, 24 May 2008 04:22:08 +0200
Message-ID: <48377BC1.2090807@slavesoftware.co.uk>
Date: Sat, 24 May 2008 03:21:53 +0100
From: Chris Hodgkins <chris@slavesoftware.co.uk>
MIME-Version: 1.0
To: Pauli Borodulin <pauli@borodulin.fi>
References: <482E114E.1000609@borodulin.fi>	<d9def9db0805161621n1a291192n8c15db11949b3dad@mail.gmail.com>	<4831B058.1030107@borodulin.fi>	<4831B70D.8050809@tungstengraphics.com>	<4831CC3F.803@borodulin.fi>	<48320E0B.8090501@tungstengraphics.com>	<48326CC4.7010401@borodulin.fi>
In-Reply-To: <48326CC4.7010401@borodulin.fi>
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

On 20.05.2008 08:16, Pauli Borodulin wrote:
>> On 19.05.2008 20:51, Pauli Borodulin wrote:
>  >> [...]
>>> What comes to auto-repeat... With your version of the patch it works 
>>> equally well/badly on 2033 as it did with the earlier version.
> 
> Roland Scheidegger wrote:
>> Just curious, what's the native repeat rate (what it prints out with
>> verbose set time between irqs) with this card?
> 
> Initial delay ~270ms and repeats ~220ms.
Ah so exactly the same as for my remote. Interesting...

> 
> Btw I found these in dvb-usb-remote.c:
> 
>      input_dev->rep[REP_PERIOD] = d->props.rc_interval;
>      input_dev->rep[REP_DELAY]  = d->props.rc_interval + 150;
> 
> So there seems to be some configurable auto-repeat functionality in 
> input layer. I guess I'll experiment with those even tho' RCs delays are 
> a bit crappy, since it's a pretty painful to go through a long list of 
> recordings without any auto-repeat...
If you change these values (to anything but zero) before
input_register_device, the input driver will just disable auto-repeat
(or rather, you'd need to handle it yourself in the driver with the
appropriate timer func, and I didn't feel like duplicating half the code
of the input driver). input_register_device also says all capabilities
must be set up before calling it, when I tried to change those values
afterwards it didn't seem to work (though maybe I made some testing
error, I can't see why it shouldn't work). I guess a REP_DELAY a bit
over the initial delay (like 300ms) should work, and a REP_PERIOD of
about 100 (which would give you about 50% chance of stopping pressing
keys exactly) might be reasonable - though it really is annoying if you
can't stop exactly (but it's not solvable - either live with slow repeat
or live with that).

Roland



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
