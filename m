Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hubblest@web.de>) id 1K3xKQ-0006tv-Dz
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 20:03:19 +0200
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id 2279DDFDF86D
	for <linux-dvb@linuxtv.org>; Wed,  4 Jun 2008 20:02:45 +0200 (CEST)
Received: from [84.180.231.107] (helo=selma)
	by smtp08.web.de with asmtp (TLSv1:AES128-SHA:128)
	(WEB.DE 4.109 #226) id 1K3xJs-0008DM-00
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 20:02:45 +0200
From: Peter Meszmer <hubblest@web.de>
To: linux-dvb@linuxtv.org
Date: Wed, 4 Jun 2008 20:02:43 +0200
References: <36e8a7020806040347t27206049je7e12b233ababf04@mail.gmail.com>
In-Reply-To: <36e8a7020806040347t27206049je7e12b233ababf04@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806042002.43971.hubblest@web.de>
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

Hello,

to my mind your card _should_ work. 
I'm using a DVB-S Hybrid+FM A700 card with zzam's driver since version 
20080204 without any problems on vanilla kernels 2.6.* and Gentoo-patched 
kernels. So I'm able to watch freeTV and listen to DVB-S-radio (Astra). 

Did you ever thought of building your own, fresh vanilla-kernel from the 
sources?

Regards
Peter

Am Mittwoch, 4. Juni 2008 schrieb bvidinli:
> What is last status of driver for Avermedia DVB-S Hybrid+FM A700 ?
>
> as i last tested 20 days ago,
> 1- i build using hg, from linuxtv.org, dvb drivers,
> 2- i manually copied *.ko files to lib/modules directory, relevant dirs,
> 3- got satellite channels list/names of channels, using kaffeine, but
> no image/sound, i think decode fails...
>
> is there a recent update that i should try, or is there  a new method
> to overcome problem of "make install not working, because of unusual
> ubuntu directory structure for video modules...". I mean, lastly i run
> make install, but it did not solve driver problem, "symbol not found,
> disagrees messages on dmesg" this was because of ubuntu's choice for
> new directory structure of media modules...
>
> shortly, is there  a recent update to dvb drivers for avermedia dvb-s
> hybrid+fm a700 ?
>
> thanks..
>
> 2008/6/4, Eduard Huguet <eduardhc@gmail.com>:
> > Good point. I think the message is more explicative this way.
> >
> > Best regards,
> >   Eduard
> >
> > 2008/6/4 Matthias Schwarzott <zzam@gentoo.org>:
> > > On Samstag, 17. Mai 2008, hermann pitton wrote:
> > > > Hello,
> > > >
> > > > Am Sonntag, den 18.05.2008, 00:23 +0300 schrieb bvidinli:
> > > > > Hi,
> > > > > thank you for your answer,
> > > > >
> > > > > may i ask,
> > > > >
> > > > > what is meant by "analog  input", it is mentioned on logs that:"
> > > > > only analog inputs supported yet.." like that..
> > > > > is that mean: s-video, composit ?
> > > >
> > > > yes, only s-video and composite is enabled there.
> > > > Better we would have print only external analog inputs.
> > >
> > > If there is still interest to improve the printk message, here is a
> > > patch.
> > >
> > > Regards
> > > Matthias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
