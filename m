Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1K45ug-00017u-Ss
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 05:13:23 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Peter Meszmer <hubblest@web.de>, bvidinli <bvidinli@gmail.com>
In-Reply-To: <200806042002.43971.hubblest@web.de>
References: <36e8a7020806040347t27206049je7e12b233ababf04@mail.gmail.com>
	<200806042002.43971.hubblest@web.de>
Date: Thu, 05 Jun 2008 05:12:44 +0200
Message-Id: <1212635564.2641.7.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] About Avermedia DVB-S Hybrid+FM A700
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

Hi,

Am Mittwoch, den 04.06.2008, 20:02 +0200 schrieb Peter Meszmer:
> Hello,
> 
> to my mind your card _should_ work. 
> I'm using a DVB-S Hybrid+FM A700 card with zzam's driver since version 
> 20080204 without any problems on vanilla kernels 2.6.* and Gentoo-patched 
> kernels. So I'm able to watch freeTV and listen to DVB-S-radio (Astra). 
> 
> Did you ever thought of building your own, fresh vanilla-kernel from the 
> sources?
> 
> Regards
> Peter

thanks, this is the only valid rule here :)

bvidinli, you can't file bugs against us from ubuntix.

:)

> 
> Am Mittwoch, 4. Juni 2008 schrieb bvidinli:
> > What is last status of driver for Avermedia DVB-S Hybrid+FM A700 ?
> >
> > as i last tested 20 days ago,
> > 1- i build using hg, from linuxtv.org, dvb drivers,
> > 2- i manually copied *.ko files to lib/modules directory, relevant dirs,
> > 3- got satellite channels list/names of channels, using kaffeine, but
> > no image/sound, i think decode fails...
> >
> > is there a recent update that i should try, or is there  a new method
> > to overcome problem of "make install not working, because of unusual
> > ubuntu directory structure for video modules...". I mean, lastly i run
> > make install, but it did not solve driver problem, "symbol not found,
> > disagrees messages on dmesg" this was because of ubuntu's choice for
> > new directory structure of media modules...
> >
> > shortly, is there  a recent update to dvb drivers for avermedia dvb-s
> > hybrid+fm a700 ?
> >
> > thanks..
> >
> > 2008/6/4, Eduard Huguet <eduardhc@gmail.com>:
> > > Good point. I think the message is more explicative this way.
> > >
> > > Best regards,
> > >   Eduard
> > >
> > > 2008/6/4 Matthias Schwarzott <zzam@gentoo.org>:
> > > > On Samstag, 17. Mai 2008, hermann pitton wrote:
> > > > > Hello,
> > > > >
> > > > > Am Sonntag, den 18.05.2008, 00:23 +0300 schrieb bvidinli:
> > > > > > Hi,
> > > > > > thank you for your answer,
> > > > > >
> > > > > > may i ask,
> > > > > >
> > > > > > what is meant by "analog  input", it is mentioned on logs that:"
> > > > > > only analog inputs supported yet.." like that..
> > > > > > is that mean: s-video, composit ?
> > > > >
> > > > > yes, only s-video and composite is enabled there.
> > > > > Better we would have print only external analog inputs.
> > > >
> > > > If there is still interest to improve the printk message, here is a
> > > > patch.
> > > >
> > > > Regards
> > > > Matthias
> 

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
