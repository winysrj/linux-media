Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38806.mail.mud.yahoo.com ([209.191.125.97])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1KdLos-0002Xf-8Z
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 11:17:04 +0200
Date: Wed, 10 Sep 2008 02:16:27 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <630160.40997.qm@web46116.mail.sp1.yahoo.com>
MIME-Version: 1.0
Message-ID: <260419.76903.qm@web38806.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: urishk@yahoo.com
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

Barry,

My name is Uri Shkolnik and I'm Siano's software architect.

If you would like to add a generic support for DAB, T-DMB, DAB2, DAB-IP, etc. to LinuxTV, it'll be great!

I can assist you with generic information, plus chipset specific information.

If you have a DAB related RF feed, I even can, on certain conditions, to supply you with a hardware (USB or SDIO based), I already did so before with different open source / Linux projects.

I'm not sure that DVB sub-system is the perfect location for DAB related devices, and what about multi-DTV devices? (Siano based chipsets devices support many DTV standards, DVB-x and DAB-y among them), maybe somewhere up the chain (under media/common ? elsewhere? I'm not pretending to be a Linux kernel nor LinuxTV expert).

Anyway, keep in touch, just letting you know that I'm here... (except my vacation between Sep 19th and Oct 20th :-)


Uri

--- On Wed, 9/10/08, barry bouwsma <free_beer_for_all@yahoo.com> wrote:

> From: barry bouwsma <free_beer_for_all@yahoo.com>
> Subject: Re: [linux-dvb] Multiproto API/Driver Update
> To: "Manu Abraham" <abraham.manu@gmail.com>
> Cc: linux-dvb@linuxtv.org
> Date: Wednesday, September 10, 2008, 3:52 AM
> --- On Mon, 9/8/08, Manu Abraham
> <abraham.manu@gmail.com> wrote:
> 
> > > Second, how do non-DVB-like technologies like DAB
> (Eureka-147) fit
> > > into the scope of either multiproto or S2API --
> or must they
> > > remain outside of v4l-dvb?
> > 
> > There is already a kernel module called dabusb for
> ages.
> 
> I just looked at it again, now that I know a bit more about
> how DAB works, and to confirm the impression I got earlier
> when I was thinking about seeing if I could make it work
> with my (then) new DAB-able device.
> 
> This seems to be written specifically for one particular
> product, which I don't have, and I've forgotten
> what I've
> read about it.  It seems to be mostly loading firmware to
> the device, and pulling data from it via USB.  I don't
> see any way to tune to a particular frequency, or select
> a particular service, so that's presumably done
> elsewhere,
> perhaps physically on the receiver itself.
> 
> The device I have is partly supported by the v4l-dvb
> `siano'
> directory, with hints such as
> #define MSG_SMS_DAB_CHANNEL        607
> 
> I have what looks to be a personal reply from Herr Acher
> that has helped me understand a bit more about the dabusb
> code/device, and I need to welcome the honourable Uri
> Shkolnik
> and ask questions to learn about the Siano's support of
> DAB.
> 
> 
> 
> > > And some of us non-developers have such hardware
> and want to try
> > > it with non-Windows for readily-receiveable DAB.
> > 
> > With some simple definitions ? What applications are
> used ?
> 
> I imagine I will have to hack something out of gaffer tape
> and chewing gum if I want to actually do anything...
> 
> 
> 
> Now a completely different question -- I was pleased to see
> that my not-too-old kernel compiled well with your mp_plus
> source, and I read on the Wiki that certain basic tools
> still needed to be ported to multiproto.
> 
> Something hands-on like this is probably the only way
> I'm
> ever going to get a clue about the APIs.  And it might even
> result in something useful in addition.  But I don't
> have
> any hardware which requires multiproto, if I'd need
> that
> for testing or anything.
> 
> Would it be worth it for me to attempt such a port, given
> that, or will I find it unlikely to get anywhere?  I'm
> no
> developer and no programmer, and barely a hacker...
> 
> 
> thanks,
> barry bouwsma
> 
> 
>       
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
