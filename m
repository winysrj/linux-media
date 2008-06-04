Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1K3qqj-0007Hm-Ff
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 13:08:14 +0200
Received: by py-out-1112.google.com with SMTP id a29so17773pyi.0
	for <linux-dvb@linuxtv.org>; Wed, 04 Jun 2008 04:08:09 -0700 (PDT)
Message-ID: <36e8a7020806040408w4e9fbfadn6b4e2b0326f5a4e9@mail.gmail.com>
Date: Wed, 4 Jun 2008 14:08:08 +0300
From: bvidinli <bvidinli@gmail.com>
To: "Eduard Huguet" <eduardhc@gmail.com>
In-Reply-To: <617be8890806040359i1669a4d3n2421bd7daea5351c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <36e8a7020806040347t27206049je7e12b233ababf04@mail.gmail.com>
	<617be8890806040359i1669a4d3n2421bd7daea5351c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] About Avermedia DVB-S Hybrid+FM A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

i can confirm that:
1- i tried free-to-air, non-encrypted channels, still no sound (i
mean, som meaningless/strange sounds is heard), and no (meaningless,
mixed) video, this seems like, a codec problem, or i may mis placed
some *.ko files... i am not sure, if you know, you may suggest which
files to place where...

2- i also tested freetoair, non-encrypted radio chnnels, but no result.

i cannot confirm that:
i dont know if i have a mpeg-2 decoder..  how may i check, and what do
i need to install ?

agai may i ask:
1- is make install problem solved  for ubuntu ? it does not work out of box=
...

2- is there a schedule for other inputs of fm a700 card ?

Note:
i worked for this card to work so much because, i plan to produce a
set-top-box in my region, and i will produce many of them once i get
success... any help is welcome... we may also make a business
agreement with whoever wants, regarding linux/video subjects...

thanks..
Bahattin,


04.06.2008 tarihinde Eduard Huguet <eduardhc@gmail.com> yazm=FD=FE:
> Hi,
>     If you managed to get a channel list from Kaffeine then the card is
> mostly working, if I'm not wrong. I mean, if the driver is able to tune to
> the satellite frequency and get the channel list names, then it should be
> also capable of receiving the video / audio stream.
>
> Maybe I'm wrong, but check that you are trying to see FTA (Free to Air,
> non-encrypted) channels and that you have a valid MPEG-2 decoder installe=
d.
> Also try to listen to a non-encripted DVB-S radio channel. If it works, t=
hen
> it's possibly a video codec problem.
>
> Best regards,
>   Eduard Huguet
>
>
>
> 2008/6/4 bvidinli <bvidinli@gmail.com>:
>
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
> >
> >
> > 2008/6/4, Eduard Huguet <eduardhc@gmail.com>:
> > > Good point. I think the message is more explicative this way.
> > >
> > > Best regards,
> > >   Eduard
> > >
> > >
> > >
> > > 2008/6/4 Matthias Schwarzott <zzam@gentoo.org>:
> > >
> > >
> > > >
> > > > On Samstag, 17. Mai 2008, hermann pitton wrote:
> > > >
> > > > > Hello,
> > > > >
> > > > > Am Sonntag, den 18.05.2008, 00:23 +0300 schrieb bvidinli:
> > > > > > Hi,
> > > > > > thank you for your answer,
> > > > > >
> > > > > > may i ask,
> > > > > >
> > > > > > what is meant by "analog  input", it is mentioned on logs that:"
> only
> > > > > > analog inputs supported yet.." like that..
> > > > > > is that mean: s-video, composit ?
> > > > >
> > > > > yes, only s-video and composite is enabled there.
> > > > > Better we would have print only external analog inputs.
> > > > >
> > > >
> > > > If there is still interest to improve the printk message, here is a
> patch.
> > > >
> > > > Regards
> > > > Matthias
> > > >
> > >
> > >
> >
> >
> > --
> > =DD.Bahattin Vidinli
> > Elk-Elektronik M=FCh.
> > -------------------
> > iletisim bilgileri (Tercih sirasina gore):
> > skype: bvidinli (sesli gorusme icin, www.skype.com)
> > msn: bvidinli@iyibirisi.com
> > yahoo: bvidinli
> >
> > +90.532.7990607
> > +90.505.5667711
> >
>
>


-- =

=DD.Bahattin Vidinli
Elk-Elektronik M=FCh.
-------------------
iletisim bilgileri (Tercih sirasina gore):
skype: bvidinli (sesli gorusme icin, www.skype.com)
msn: bvidinli@iyibirisi.com
yahoo: bvidinli

+90.532.7990607
+90.505.5667711
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
