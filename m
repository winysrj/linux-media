Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Andy Walls <awalls@radix.net>
To: Patrick Boisvenue <patrbois@magma.ca>
In-Reply-To: <48CFA104.1070602@magma.ca>
References: <48C659C5.8000902@magma.ca> <48C732DE.2030902@linuxtv.org>
	<1221087304.2648.7.camel@morgan.walls.org> <48C86857.70603@magma.ca>
	<1221095447.2648.69.camel@morgan.walls.org>	
	<48CAB3EA.5050600@magma.ca>
	<37219a840809121141j2b2cedf9mf5b0edd005a9daba@mail.gmail.com>
	<48CABF2A.9090407@magma.ca> <48CAC019.9050604@magma.ca>
	<1221269154.2648.79.camel@morgan.walls.org>
	<d9def9db0809150935p5fb08b41x1474322a08c3d291@mail.gmail.com>
	<48CFA104.1070602@magma.ca>
Date: Tue, 16 Sep 2008 19:35:18 -0400
Message-Id: <1221608118.4511.2.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
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

On Tue, 2008-09-16 at 08:05 -0400, Patrick Boisvenue wrote:
> 
> Markus Rechberger wrote:
> > On Sat, Sep 13, 2008 at 3:25 AM, Andy Walls <awalls@radix.net> wrote:
> >> On Fri, 2008-09-12 at 15:16 -0400, Patrick Boisvenue wrote:
> >>> Patrick Boisvenue wrote:
> >>>> Michael Krufky wrote:
> >>>>> On Fri, Sep 12, 2008 at 2:24 PM, Patrick Boisvenue <patrbois@magma.ca> wrote:
> >>>>>> Andy Walls wrote:
> >>>>>>> On Wed, 2008-09-10 at 20:37 -0400, Patrick Boisvenue wrote:
> >>>>>>>> Andy Walls wrote:
> >>>>>>>>> On Tue, 2008-09-09 at 22:37 -0400, Steven Toth wrote:
> >>>>>>>>>> Patrick Boisvenue wrote:
> >>>>>>>>>>> Steven Toth wrote:
> >>>>>>>>>>>> Patrick Boisvenue wrote:

> > 
> > don't load i2c-dev
> > 
> > Markus

Markus,

Nice catch.

Regards,
Andy
 
> 
> Good call, that was it.  Re-compiling my kenrel without I2C_DEV allowed 
> the firmware to load and dvbscan to work as expected.
> 
> Thanks,
> ...Patrick
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
