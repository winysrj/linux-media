Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lilly.ping.de ([83.97.42.2] ident=qmailr)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <wolfgang@leila.ping.de>) id 1K6rR5-0000eA-J9
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 20:22:12 +0200
Date: Thu, 12 Jun 2008 20:16:59 +0200
To: Dan Lita <dan.lita@sttcr.org>
Message-ID: <20080612181659.GZ25254@leila.ping.de>
References: <20B2C1F8-9DFE-43C1-BACD-22DC74AE9136@krastelcom.ru>
	<485100C3.2090908@sttcr.org>
	<B582543D-F8CE-48ED-81B9-18665F49EEB6@krastelcom.ru>
	<48512411.6000900@anevia.com>
	<41475762-773E-425C-BADA-C9FC86BA749B@krastelcom.ru>
	<485162A2.6070409@sttcr.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <485162A2.6070409@sttcr.org>
From: wolfgang@leila.ping.de (Wolfgang Wegner)
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Smit CAM problems
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

Hi Dan,

according to the DVB (ETSI) specification, CAMs can only have 5V operating
voltage. I do not know if there is any CAM around that (claims to) operate
with 3.3V, although I know there are some that better should...

Regards,
Wolfgang

On Thu, Jun 12, 2008 at 08:53:38PM +0300, Dan Lita wrote:
> Dear Vladimir,
> =

> I took a closer look on the CI-CAM adapter from Technotrend.
> There is a 3.3V voltage regulator (LM1117 DT 3.3V)
> =

> Similar, on the AD-SP400 it seems to be also a 3.3V voltage regulator =

> (marked 1084-33PE). 4046 board from Twinhan/Azurewave.
> =

> According to SMIT operation voltage for their modules is 4.5 to 5.5V
> =

> If in both cards the CAM takes power after these rectifiers =

> you cannot have a guaranteed operation.
> =

> Dan =

> =

> Vladimir Prudnikov wrote:
> >Do you think SMiT will be interested in hunting for bugs in linux  =

> >drivers? These modules apparently work fine with any other hardware  =

> >(I'm sure professional ones do!)
> >
> >Regards,
> >Vladimir
> >
> >On Jun 12, 2008, at 5:26 PM, Frederic CAND wrote:
> >
> >  =

> >>Did you try to contact SMIT support ?
> >>
> >>Vladimir Prudnikov a =E9crit :
> >>    =

> >>>Didn't try Aston CAMs with mpeg4. But they do up to 12 channels of   =

> >>>mpeg2 perfectly well. With no problems at all. SMiTs that are for  =

> >>>8  services can do only 3 to 4 for me.
> >>>I think it's some kind of a driver bug because it begins working  =

> >>>after  reinitialisation. Doesn't get hot. I have tried to call  =

> >>>Aston as well  but with no success yet.
> >>>Regards,
> >>>Vladimir
> >>>On Jun 12, 2008, at 2:56 PM, dan.lita@sttcr.org wrote:
> >>>      =

> >>>>Dear Vladimir,
> >>>>
> >>>>I read your post on linux-dvb list. We have an Aston Viaccess   =

> >>>>Professional 2.15 CAM .
> >>>>I read that you also use Aston CAMS.  My question is whether your   =

> >>>>Aston Viaccess cam can descramble H264  feeds or not?
> >>>>We have tried on a PACE HDTV receiver and a Tandberg unit and it   =

> >>>>does not descramble the H264 video pid. (black screen)
> >>>>This does not happen with Viaccess RED cam.
> >>>>
> >>>>On older Common interface adapters from Technotrend, the one for  =

> >>>>TT  Premium DVB-S card, there was a jumper for 3V or 5V cam  =

> >>>>operation.
> >>>>I assume the new CI adapter does not have such jumper. If it  =

> >>>>still  exist maybe it will be a good idea to switch from one  =

> >>>>voltage to the  other.
> >>>>Another solution is to test whether it works or not for Irdeto to   =

> >>>>use an Alphacrypt Classic CAM which, at least in theory,  =

> >>>>according  to MASCOM, supports Irdeto.
> >>>>The third thing is to notice whether the SMIT cam gets hot in   =

> >>>>operation. If it gets too hot maybe a fan similar to the one for   =

> >>>>graphics card must be put near the Common interface adapter.
> >>>>
> >>>>BTW. Do you have any e-mail address from Aston? I have tried to   =

> >>>>contact  them but there is no e-mail address in their website.
> >>>>
> >>>>Best regards,
> >>>>Dan Lita
> >>>>
> >>>>
> >>>>Vladimir Prudnikov wrote:
> >>>>        =

> >>>>>Hello!
> >>>>>
> >>>>>I'm using SMIT cams to descramble channels on TT S-1500 and TT-   =

> >>>>>S2-3200. After some time of normal operation SMIT cams drop out   =

> >>>>>and  stop decrypting the stream. It needs to be removed from the  =

> >>>>>CI  slot  and reinserted to resume normal operation. Aston CAMs  =

> >>>>>have no  such  problems, but they don't support 0x652 Irdeto.
> >>>>>I'm streaming with vlc. Tried many SMITs (Viaccess and Irdeto).   =

> >>>>>Same  problem everywhere.
> >>>>>
> >>>>>Regards,
> >>>>>Vladimir
> >>>>>
> >>>>>_______________________________________________
> >>>>>linux-dvb mailing list
> >>>>>linux-dvb@linuxtv.org
> >>>>>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>>>>
> >>>>>
> >>>>>
> >>>>>          =

> >>>_______________________________________________
> >>>linux-dvb mailing list
> >>>linux-dvb@linuxtv.org
> >>>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>>      =

> >>-- =

> >>CAND Frederic
> >>Product Manager
> >>ANEVIA
> >>    =

> >
> >
> >_______________________________________________
> >linux-dvb mailing list
> >linux-dvb@linuxtv.org
> >http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >
> >  =

> =


> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
