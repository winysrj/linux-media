Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Sun, 14 Sep 2008 16:46:01 +0200
References: <48CA0355.6080903@linuxtv.org> <200809120826.31108.hftom@free.fr>
	<48CC12BF.7050803@hauppauge.com>
In-Reply-To: <48CC12BF.7050803@hauppauge.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809141646.01263.hftom@free.fr>
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

Le Saturday 13 September 2008 21:21:35 Steven Toth, vous avez =E9crit=A0:
> > First i tried old api (kaffeine)-> everything works as expected.
> > Then i tried new API (with latest tune.c) -> nova-t and nova-s work,
> > cinergyT2 doesn't. I've also noticed that FE_SET_PROPERTY ioctl always
> > return -1, even when success..
> > Then i tried old api again -> now dvb-s doesn't lock and dvb-t always
> > lock on the freq used in tune.c
>
> Fixed in the current tree.

Indeed, cache bug is now fixed, old api works as expected in all cases. (Ex=
ept =

for the cinergyT2 case off course)

However, i see that GETting DTV_DELIVERY_SYSTEM always returns the cached =

value, so at first (after modules (re)load) it returns 0. An application =

really needs to know the delivery system (and others usefull infos) to be =

able to handle a device, like the old api FE_GET_INFO.

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
