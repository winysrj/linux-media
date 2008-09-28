Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp28.orange.fr ([80.12.242.100])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Kk37G-0006um-69
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 22:43:43 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Sun, 28 Sep 2008 22:43:07 +0200
References: <200809282207.20443.simon@siemonsma.name>
In-Reply-To: <200809282207.20443.simon@siemonsma.name>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809282243.07333.hftom@free.fr>
Subject: Re: [linux-dvb] Can't record an encrypted channel and watch another
	in the same bouquet. (also teletext doesn't work for
	encrypted channels)
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

Le Sunday 28 September 2008 22:07:20 Simon Siemonsma, vous avez =E9crit=A0:
> I have a problem with encrypted channels.
> I have a Conax CAM Module (by Smit)
> Further I use a Technotrend T1500 Budget card with CI cart.
>
> With FTA channels everything works just fine.
> With encoded channels some things don't work.
>
> I can't record one channel and at the same time look at another channel
> from the same bouquet. (Kaffeine says: "no CAM free",

Only Kaffeine 0.8.7 support multiservices cam.

> vdr says: "Channel =

> not available"
> Teletext doesn't work (vdr says: "Page 100-00 not found")
> When I start vdr I get the following in the log file:
> "CAM 1: module present
> CAM 1: module ready
> Conax Conditional Access, 01, CAFE, BABE
> CAM 1: doesn't reply to QUERY - only a single channel can be decrypted"
>
> This looks like the CAM can't just encode one channel at a time.
>
> But on the dvbshop Website they say:
> http://www.dvbshop.net/product_info.php/info/p2194_Conax-CAM--Rev--1-2---=
-4
>-00e-by-Smit.html "MPEG DEMUX: Multi-channel SECTION and PID filter
> configurable through software"
> in vdr's CAM menu is stated: "Number of sessions: 5"
>
> This looks like the CAM can handle multiple channels at a time isn't it?
>
> Someone at
> http://www.dvbnetwork.de/index.php?option=3Dcom_fireboard&Itemid=3D27&fun=
c=3Dview
>&catid=3D2&id=3D6191#6192 (German) pointed me in the direction of the linux
> drivers.
>
> Is he right?
>
> I understood from
> http://www.linuxtv.org/docs/dvbapi/Introduction.html#SECTION0023000000000=
00
>00000 that the CAM comes before the Demuxer and: "The complete TS is passed
> through the CA hardware".

Yes.

> If I understood this right this means that onces I watch one channel in a
> bouquet the complets TS is decrypted. So all other channels and teletext
> are decrypted too.

No, the whole TS isn't decrypted. Only one (or more, if your cam can do mor=
e) =

service(s).

> This makes it extra confusing why I can't record one =

> channel and watch another in the same bouquet.
> Do I understand it wrong or are the drivers or the dvb software not mature
> enough yet.

Most probably your cam is only able to decrypt one service at a time.


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
