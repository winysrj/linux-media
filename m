Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp129.rog.mail.re2.yahoo.com ([206.190.53.34])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1L5jTT-0006cI-HG
	for linux-dvb@linuxtv.org; Thu, 27 Nov 2008 17:12:16 +0100
Message-ID: <492EC6BE.6090407@rogers.com>
Date: Thu, 27 Nov 2008 11:11:42 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Bob Cunningham <FlyMyPG@gmail.com>
References: <49287DCC.9040004@gmail.com>
	<37219a840811231121u1350bf61n57109a1600f6dd92@mail.gmail.com>
	<4929B192.8050707@rogers.com> <4929FE90.2050008@gmail.com>
	<492A328A.7090502@rogers.com> <492B9B98.5060603@gmail.com>
	<492CA816.7000400@rogers.com> <492CF843.5040807@gmail.com>
In-Reply-To: <492CF843.5040807@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AnyTV AUTV002 USB ATSC/QAM Tuner Stick
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

Bob Cunningham wrote:
> What are the next steps?
> 1. How much effort will be needed to make this driver work?
> 2. Do all of the pieces already exist?  (All the chips seem to be
> mentioned somewhere in the DVB tree.)
> 3. What new code is needed?
> 4. How much reverse-engineering needs to be done?  Will a full
> schematic be needed?
>
> Most importantly:
> 5. How can I help?
>
> I'm a real-time embedded systems programmer with 25 years experience,
> though most of what I've written runs on "bare metal", often without
> an OS.  I know nothing about Linux device drivers.  However, I am very
> good at getting local hardware to "play nice", first by poking it with
> a debugger, then generally by scripting through /dev/port. 
> I've never worked with hardware across the USB bus, though I have
> brought up USB interface hardware from the CPU side, and have had to
> snoop USB traffic to diagnose problems.  Unfortunately, I don't have a
> Windows system available to use to snoop the USB traffic from the
> driver provided by the vendor, though I haven't yet tried to get
> anything to work via Wine.
>
> I'll be taking lots of time off in December, and should have some time
> to put toward this project.
>
> If anyone else is curious, or wants to help, the product is here:
> http://www.dealextreme.com/details.dx/sku.15569
>
> I also found a brief description of a reference design here:
> http://www.auvitek.com/AU8522%20MT%20USB%20TV%20Stick%20Design%20Brief_R1.0.pdf

1 - probably not a lot
2 - sounds like it, but I do not know how far developed the MT2131
driver is
3 - probably just the "glue code" to tie all the pieces together
4 - likely none (there may be a chance the the components are wired up
slightly differently, such as in the case with GPIO pins, in which case
you'd have to try to discover the true configuration....schematics would
obviously help, but probably 99.99% of cases are resolved without such
aide )
5 - you can add the support for the device !  :P    Because of the
advanced state (component drivers already exist) you won't need any in
depth knowledge about the developing device drivers.  At this point, all
you will need to do is figure out where to insert the necessary glue
code in the existing modules - have a look in the source code of the
respective components (eg. /linux/drivers/media/video/au0828/ ;
/linux/drivers/media/dvb/frontends/ ; .... ).  Note that the AU0828 does
not currently support analog
(http://marc.info/?l=linux-video&m=122459807631633&w=2).

I suspect that solving the EEPROM issue is just a matter of adjusting
the code so that it is not specifically expecting a Hauppauge
signature.  Getting the device to attach the correct tuner should be, I
imagine, fairly straight forward too .  It would appear that this device
is highly similar to the Woodbury  (see:
http://marc.info/?l=linux-dvb&m=122617795121243&w=2); I do not know
whether there is significant difference between the respective MT parts
-- might be trivial, then again it might not be


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
