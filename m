Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38804.mail.mud.yahoo.com ([209.191.125.95])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1KhnZa-0007YE-Qe
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 17:43:43 +0200
Date: Mon, 22 Sep 2008 08:43:04 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: =?iso-8859-1?Q?Javier_G=E1lvez_Guerrero?=
	<javier.galvez.guerrero@gmail.com>
In-Reply-To: <145d4e1a0809220502v56020205o54fd186b227bdee7@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <546961.66460.qm@web38804.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-H support
Reply-To: urishk@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>




--- On Mon, 9/22/08, Javier G=E1lvez Guerrero <javier.galvez.guerrero@gmail=
.com> wrote:

> From: Javier G=E1lvez Guerrero <javier.galvez.guerrero@gmail.com>
> Subject: Re: [linux-dvb] DVB-H support
> To: urishk@yahoo.com
> Cc: linux-dvb@linuxtv.org
> Date: Monday, September 22, 2008, 3:02 PM
> Hi Uri,
> =

> Thanks for your answer.
> =


Welcome

> 2008/9/22 Uri Shkolnik <urishk@yahoo.com>
> =

> > Hi,
> >
> > yep, you can do it with any Siano chipset based
> device.
> =

> =

> Do you know any specific device with Siano chipset that
> works properly or
> any device will do?
>

Since I'm Siano's software architect I can't (or won't) recommend any speci=
fic hardware manufacturer from all who use Siano's chipsets (you can unders=
tand me here....)

Please refer to other people from this ML regarding this issue. =

 =

> =

> > How are you going to deal with ESG and HO?
> >
> =

> I want to develop a handover framework for IEEE 802.11 //
> 3G // DVB-H

I don't think that it's feasible to combine those standards HO to single fr=
amework. The HO schemes and guidelines are totally different. =


> networks, dealing with different parameters depending on
> what drivers API
> allowed me, but basically the signal strength would be the
> main one.

Signal strength can not be a sole parameter, even not the major one. You sh=
ould use the strength, SNR, BER, RSSI, geographic network data and other fo=
r good algorithm for DVB-H HO.

> =

> Regarding the ESG I don't know how to deal with it as
> I'm a complete novice
> with LinuxTV/dvb-utils. First I wanted to know if it was
> possible to get
> DVB-H streams with it and what hardware would be proper. I
> supposed that
> demuxing and selecting the contents would be nearly the
> same that in DVB-T,
> as the main difference is the time slicing in DVB-H
> streams.
> =


Not so easily. DVB-H is RTP based, so the content is delivered using IP mul=
ticast. True you can pass the entire non-PSI/SI ES (meaning most of the TS)=
 to the IP stack, but this is not feasible for weak machine (embedded) and =
even for strong machines it will take lots of CPU resources. In order to kn=
ow which ES to extract, you need the parse the ESG (xml based).

> Anyway, do you have any idea or piece of advice? Is what I
> want to do
> possible or not?
> =


Sure it's possible, but its a big task....

> >
> >
> >
> > Best Regards,
> >
> > Uri Shkolnik
> >
> >
> >
> > --- On Mon, 9/22/08, Javier G=E1lvez Guerrero <
> > javier.galvez.guerrero@gmail.com> wrote:
> >
> > > From: Javier G=E1lvez Guerrero
> <javier.galvez.guerrero@gmail.com>
> > > Subject: [linux-dvb] DVB-H support
> > > To: linux-dvb@linuxtv.org
> > > Date: Monday, September 22, 2008, 11:01 AM
> > > Hi everyone,
> > >
> > > Has anyone succeed in receiving a DVB-H stream
> with
> > > dvb-utils? If so, which
> > > hardware have you used?
> > >
> > > Any help is much appreciated.
> > >
> > > Regards,
> > > Javi
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > >
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >
> >
> >


      =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
