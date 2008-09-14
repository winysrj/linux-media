Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ket7I-00058Q-5S
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 17:02:25 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7600DTGXR1NC10@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 11:01:50 -0400 (EDT)
Date: Sun, 14 Sep 2008 11:01:49 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809141646.01263.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48CD275D.7090301@linuxtv.org>
MIME-version: 1.0
References: <48CA0355.6080903@linuxtv.org> <200809120826.31108.hftom@free.fr>
	<48CC12BF.7050803@hauppauge.com> <200809141646.01263.hftom@free.fr>
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
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

Christophe Thommeret wrote:
> Le Saturday 13 September 2008 21:21:35 Steven Toth, vous avez =E9crit :
>>> First i tried old api (kaffeine)-> everything works as expected.
>>> Then i tried new API (with latest tune.c) -> nova-t and nova-s work,
>>> cinergyT2 doesn't. I've also noticed that FE_SET_PROPERTY ioctl always
>>> return -1, even when success..
>>> Then i tried old api again -> now dvb-s doesn't lock and dvb-t always
>>> lock on the freq used in tune.c
>> Fixed in the current tree.
> =

> Indeed, cache bug is now fixed, old api works as expected in all cases. (=
Exept =

> for the cinergyT2 case off course)

Speaking of which, I looked at this yesterday. I'll post my feedback =

back to Johannes thread, where I said I'd investigate.

> =

> However, i see that GETting DTV_DELIVERY_SYSTEM always returns the cached =

> value, so at first (after modules (re)load) it returns 0. An application =

> really needs to know the delivery system (and others usefull infos) to be =

> able to handle a device, like the old api FE_GET_INFO.
> =


Yes, talking with Darron we're talking about being able to identify the =

existence of the API and capabilities.

We have the DTV_FE_CAPABILITY_COUNT and DTV_FE_CAPABILITY (current =

defined but not connected in dvb-core) which would be the natural place =

to expose every older (and newer) feature of the demods.

The command you're referring to now does exactly what it's supposed to, =

it selects your last SET value (or if the demod has provided a =

.get_proeprty() callback), the demod could chose to answer differently. =

In principle we could add a one line fix to the cx24116 demod =

"c->delivery_system =3D SYS_DVBS2;" to solve your initial problem - but I =

don't that's the correct approach.

When the phase #1 work is done we'll fill out the capabilities changes =

in dvb-core and start to expose interesting features, like LNA, =

diversity, delivery systems, power controls or anything else that the =

linuxtv community thinks is generalized and useful. We will take these =

steps carefully.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
