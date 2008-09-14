Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: Steven Toth <stoth@linuxtv.org>
Date: Sun, 14 Sep 2008 17:27:32 +0200
References: <48CA0355.6080903@linuxtv.org> <200809141646.01263.hftom@free.fr>
	<48CD275D.7090301@linuxtv.org>
In-Reply-To: <48CD275D.7090301@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809141727.32436.hftom@free.fr>
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

Le Sunday 14 September 2008 17:01:49 Steven Toth, vous avez =E9crit=A0:
> Christophe Thommeret wrote:
> > Le Saturday 13 September 2008 21:21:35 Steven Toth, vous avez =E9crit :
> >>> First i tried old api (kaffeine)-> everything works as expected.
> >>> Then i tried new API (with latest tune.c) -> nova-t and nova-s work,
> >>> cinergyT2 doesn't. I've also noticed that FE_SET_PROPERTY ioctl always
> >>> return -1, even when success..
> >>> Then i tried old api again -> now dvb-s doesn't lock and dvb-t always
> >>> lock on the freq used in tune.c
> >>
> >> Fixed in the current tree.
> >
> > Indeed, cache bug is now fixed, old api works as expected in all cases.
> > (Exept for the cinergyT2 case off course)
>
> Speaking of which, I looked at this yesterday. I'll post my feedback
> back to Johannes thread, where I said I'd investigate.
>
> > However, i see that GETting DTV_DELIVERY_SYSTEM always returns the cach=
ed
> > value, so at first (after modules (re)load) it returns 0. An application
> > really needs to know the delivery system (and others usefull infos) to =
be
> > able to handle a device, like the old api FE_GET_INFO.
>
> Yes, talking with Darron we're talking about being able to identify the
> existence of the API and capabilities.
>
> We have the DTV_FE_CAPABILITY_COUNT and DTV_FE_CAPABILITY (current
> defined but not connected in dvb-core) which would be the natural place
> to expose every older (and newer) feature of the demods.
>
> The command you're referring to now does exactly what it's supposed to,
> it selects your last SET value (or if the demod has provided a
> .get_proeprty() callback), the demod could chose to answer differently.
> In principle we could add a one line fix to the cx24116 demod
> "c->delivery_system =3D SYS_DVBS2;" to solve your initial problem - but I
> don't that's the correct approach.
>
> When the phase #1 work is done we'll fill out the capabilities changes
> in dvb-core and start to expose interesting features, like LNA,
> diversity, delivery systems, power controls or anything else that the
> linuxtv community thinks is generalized and useful. We will take these
> steps carefully.

Ok, good.

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
