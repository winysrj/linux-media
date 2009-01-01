Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LICOR-0004lN-M1
	for linux-dvb@linuxtv.org; Thu, 01 Jan 2009 02:30:37 +0100
From: Andy Walls <awalls@radix.net>
To: Greg <thewatchman@gmail.com>
In-Reply-To: <c715948d0812301528h5a4f2a57xa973099ffb33730@mail.gmail.com>
References: <c715948d0812301528h5a4f2a57xa973099ffb33730@mail.gmail.com>
Date: Wed, 31 Dec 2008 20:32:11 -0500
Message-Id: <1230773531.3121.13.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pcHDTV-5500 and FC10 (resend, was too big)
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

On Tue, 2008-12-30 at 17:28 -0600, Greg wrote:
> I have been trying to get my PCHD-5500 card to work  with FC10. So far
> I am able to get  the analog tuner portion of the card to work but not
> the digital. Devinheitmueller was pointing me in the direction to
> look. I am getting a crash in one of the modules, which looks like it
> is coming from the line:
> 
> div = ((frequency + t_params->iffreq) * 62500 + offset +
> tun->stepsize/2) / tun->stepsize;
> 
> 
> The crash is apparently being cased by a zero stepsize. This crash
> occured when I was scanning for channels either from mythtvset or
> Kaffeine, or a command line program that came with the card. I also
> have  Hauppague 250 card in the system which seems to work.  
> 
> If I select the digital tuner from mythtv the application just hangs
> and I get a blank screen.
> 
> I tried hacking the tuner-types.mod.c file and adding the following
> lines to it that I coppied from one of the other cards (though I
> suspect these values are not right for this card)
> 
>     [TUNER_LG_NTSC_TAPE] = { /* LGINNOTEK NTSC */
>                 .name   = "LG NTSC (TAPE series)",
>                 .params = tuner_fm1236_mk3_params,
>                 .count  = ARRAY_SIZE(tuner_fm1236_mk3_params),
>                 //adding these lines copied from above so that we have
> no-zero values
>                 .min = 16 * 53.00,
>                 .max = 16 * 803.00,
>                 .stepsize = 62500,
> 

The TAPE-Hxxx series tuners are an LG rebrand of the equivalent Phillips
tuner.  The TAPE-H091F-MK3 and TAPE-Hxxx data sheets I have say this
about the analog ranges:

Low :   55.25 - 157.25 MHz
Mid :  163.25 - 439.25 MHz
High:  445.25 - 801.25 MHz
FM:     88.00 - 108.00 MHz

The step size is programmable: 31.25 kHz, 50.00 kHz, 62.50 kHz, ...

With a control byte of 0x8e (as in the tuner_fm1236_mk3_params), you're
programming a step size of 62.50 kHz.

Of course this is an analog M/N system tuner with FM radio.  I suspect
this isn't the tuner you're looking for, for Digital TV.

Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
