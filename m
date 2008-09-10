Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2e.orange.fr ([80.12.242.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KdRKy-0007Yv-Kv
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 17:10:34 +0200
From: Christophe Thommeret <hftom@free.fr>
To: Steven Toth <stoth@hauppauge.com>
Date: Wed, 10 Sep 2008 17:10:19 +0200
References: <48B8400A.9030409@linuxtv.org> <200809101340.09702.hftom@free.fr>
	<48C7CDCF.9090300@hauppauge.com>
In-Reply-To: <48C7CDCF.9090300@hauppauge.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809101710.19695.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

Le Wednesday 10 September 2008 15:38:23 Steven Toth, vous avez =E9crit=A0:
> > Is this card able to deliver both S and T at the same time?
>
> No, the hardware can do S/S2 or T.

> The driver in the S2API tree only has S/S2 enabled (for the time being).

So, maybe we have to think a bit about how to add support for this kind of =

device.
I mean, if the driver provides different adapters/frontends (say =

adapter0/frontend0 and adapter1/frontend0), a typical application will see =

these as separate devices, and then when a user watch a S channel, the app =

assumes that the T frontend is free while in fact it's not.
For example, Kaffeine updates its channels list according to which channels =

can be viewed (based on which frontends are free). So, if you are recording=
 a =

S channel, all channels on this freq are shown as available and all T =

channels are also shown as available. But in the HVR4000 case, it's false, =

since the T tuner isn't free.

Maybe a solution could be to have :
- adapter0/frontend0 -> S/S2 tuner
- adapter0/frontend1 -> T tuner

So applications could know that these 2 frontends are exclusive.
That would not require any API change, but would have to be a rule followed=
 by =

all drivers.


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
