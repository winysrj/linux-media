Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cable-85.28.84.48.coditel.net ([85.28.84.48]
	helo=ibiza.bxl.tuxicoman.be)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gmsoft@tuxicoman.be>) id 1KTOcJ-0003OR-4s
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 00:14:55 +0200
Date: Thu, 14 Aug 2008 00:14:19 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: "Konstantin Dimitrov" <kosio.dimitrov@gmail.com>
Message-ID: <20080814001419.618d60a2@bleh.bxl.tuxicoman.be>
In-Reply-To: <8103ad500808131244l1bb786e9mf519e3d7e93d76b7@mail.gmail.com>
References: <20080813123241.0f7cffca@bleh.bxl.tuxicoman.be>
	<8103ad500808130637v50e9a64eg6eb1fbdd32071971@mail.gmail.com>
	<20080813210018.465bbef4@bleh.bxl.tuxicoman.be>
	<8103ad500808131244l1bb786e9mf519e3d7e93d76b7@mail.gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CT-3650 driver effort
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



Hi Konstantin,

It seems that you are right. The tuner is actually TDA8274, not
TDA8264. Sorry for the typo.

Looking at other drivers like the saa7134 one, it seems that there may
be more work to do to get the TDA10048 to work. Also, the demod
TDA10046 has special code to work with this tuner. I'm wondering if the
same applies for TDA10048.

Unfortunately, I'm kinda stuck right now. Maybe the next step would be
to sniff what the windows driver sends via USB but I don't have any
windows install to try with.


Any suggestions ?


Regards,
  Guy



On Wed, 13 Aug 2008 22:44:48 +0300
"Konstantin Dimitrov" <kosio.dimitrov@gmail.com> wrote:

> hi again Guy,
> 
> sorry, but i don't know what tuner is used in CT-3650. in you first
> mail you said that the tuner in CT-3650 is TDA8264 and it works with
> DVB-C. under "tuner" i mean PLL (Phase Locked Loop) integrated
> circuit. personally, i'm not an expert, but i doubt that there are
> different PLLs for DVB-C and DVB-T. i assume there is one PLL: TDA8264
> for both DVB-T and DVB-C and two demodulator one for DVB-T: TDA10048
> and one for DVB-C: TDA10023. so, maybe you can't attach to the tuner,
> because you've already attached to that tuner in the DVB-C code. or
> maybe if there is separate (second) tuner for DVB-T you are using
> wrong I2C device address when you try to attach. i hope that will help
> you.
> 
> regards,
> konstantin
> 
> On Wed, Aug 13, 2008 at 10:00 PM, Guy Martin <gmsoft@tuxicoman.be>
> wrote:
> >
> > Hi Konstantin,
> >
> > Thanks for that. I'm now able to get the firmware uploaded.
> >
> > However I can't attach the DVB-T tuner. I guess it has a TDA18211
> > but I'm not 100% sure about this. Is there another way to find out
> > rather than unsoldering the tuner ?
> >
> > Thanks,
> >  Guy
> >
> > On Wed, 13 Aug 2008 16:37:11 +0300
> > "Konstantin Dimitrov" <kosio.dimitrov@gmail.com> wrote:
> >
> >> hi Guy,
> >>
> >> you can easily get (extract) the TDA10048 firmware from the
> >> Technotrend CT-3650 Windows drivers:
> >>
> >> 1) wget
> >> http://technotrend-online.com/download/software/bda/usb2driver//ttusb2bda_1.0.2.20.zip
> >>
> >> 2) unzip -jo ttusb2bda_1.0.2.20.zip
> >> ttusb2bda_1.0.2.20/ttusb2bda.sys
> >>
> >> 3) dd if=ttusb2bda.sys of=dvb-fe-tda10048-1.0.fw bs=1 skip=532560
> >> count=24878
> >>
> >> best wishes,
> >> konstantin
> >>
> >> 2008/8/13 Guy Martin <gmsoft@tuxicoman.be>:
> >> >
> >> > Hi all,
> >> >
> >> > I'm currently trying to get the CT-3650 working.
> >> > It has the following chips :
> >> >  - TDA8264 (tuner)
> >> >  - TDA10023 (DVB-C demod)
> >> >  - TDA10048 (DVB-T demod)
> >> >
> >> >
> >> > I'm able to get the DVB-C frontend working using the attached
> >> > patch. However I can't test the DVB-T nor the CI.
> >> >
> >> > To test the DVB-T frontend, I'm missing dvb-fe-tda10048-1.0.fw
> >> > which I can't find anywhere.
> >> >
> >> > Regarding the CI, I'm only watching FTA so I won't be able to
> >> > test that.
> >> >
> >> >
> >> > Please review the attached patch. If I'm given the tda10048
> >> > firmware I should probably get it to work.
> >> >
> >> >
> >> > Regards,
> >> >  Guy
> >> >
> >> > --
> >> > Guy Martin
> >> > Gentoo Linux - HPPA port lead
> >> >
> >> > _______________________________________________
> >> > linux-dvb mailing list
> >> > linux-dvb@linuxtv.org
> >> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >> >
> >
> >
> > --
> > Guy Martin
> > Gentoo Linux - HPPA port lead
> >


-- 
Guy Martin
Gentoo Linux - HPPA port lead

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
