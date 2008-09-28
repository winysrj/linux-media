Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n40.bullet.mail.ukl.yahoo.com ([87.248.110.173])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1Kk3a2-00017I-6U
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 23:13:28 +0200
Date: Sun, 28 Sep 2008 16:56:43 -0400
From: Emmanuel ALLAUD <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <200809282207.20443.simon@siemonsma.name>
In-Reply-To: <200809282207.20443.simon@siemonsma.name> (from
	simon@siemonsma.name on Sun Sep 28 16:07:20 2008)
Message-Id: <1222635403l.18974l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Can't record an encrypted channel and watch
 another in the same bouquet. (also teletext doesn't work for encrypted
 channels)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 28.09.2008 16:07:20, Simon Siemonsma a =E9crit=A0:
> I have a problem with encrypted channels.
> I have a Conax CAM Module (by Smit)
> Further I use a Technotrend T1500 Budget card with CI cart.
> =

> With FTA channels everything works just fine.
> With encoded channels some things don't work.
> =

> I can't record one channel and at the same time look at another
> channel from =

> the same bouquet. (Kaffeine says: "no CAM free", vdr says: "Channel
> not =

> available"
> Teletext doesn't work (vdr says: "Page 100-00 not found")
> When I start vdr I get the following in the log file:
> "CAM 1: module present
> CAM 1: module ready
> Conax Conditional Access, 01, CAFE, BABE
> CAM 1: doesn't reply to QUERY - only a single channel can be
> decrypted"
> =

> This looks like the CAM can't just encode one channel at a time.
> =

> But on the dvbshop Website they say:
> http://www.dvbshop.net/product_info.php/info/p2194_Conax-CAM--
> Rev--1-2----4-00e-by-Smit.html
> "MPEG DEMUX: Multi-channel SECTION and PID filter configurable =

> through
> =

> software"
> in vdr's CAM menu is stated: "Number of sessions: 5"
> =

> This looks like the CAM can handle multiple channels at a time isn't
> it?
> =

> Someone at =

> http://www.dvbnetwork.de/index.php?
> option=3Dcom_fireboard&Itemid=3D27&func=3Dview&catid=3D2&id=3D6191#6192
> =

> (German) pointed me in the direction of the linux drivers.
> =

> Is he right?
> =

> I understood from =

> http://www.linuxtv.org/docs/dvbapi/
> Introduction.html#SECTION00230000000000000000
> =

> that the CAM comes before the Demuxer and: "The complete TS is passed
> through =

> the CA hardware".
> If I understood this right this means that onces I watch one channel
> in a =

> bouquet the complets TS is decrypted. So all other channels and
> teletext are =

> decrypted too. This makes it extra confusing why I can't record one
> channel =

> and watch another in the same bouquet.
> Do I understand it wrong or are the drivers or the dvb software not
> mature =

> enough yet.
> I use kernel 2.6.25.

Hi,
I have an AstonCrypt which is able to decode 2 services at the same =

time and it works beautifully with mythtv (I have a TT 32000 but the CI =

is the same and I had a 1500 and I think, but I am not sure, that it =

worked also with it).
HTH
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
