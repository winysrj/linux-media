Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KdRhJ-0000SJ-60
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 17:33:37 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Wed, 10 Sep 2008 17:33:29 +0200
References: <48B8400A.9030409@linuxtv.org> <48C7CDCF.9090300@hauppauge.com>
	<200809101710.19695.hftom@free.fr>
In-Reply-To: <200809101710.19695.hftom@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809101733.29910.janne-dvb@grunau.be>
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

On Wednesday 10 September 2008 17:10:19 Christophe Thommeret wrote:
> Le Wednesday 10 September 2008 15:38:23 Steven Toth, vous avez =E9crit=A0:
> > > Is this card able to deliver both S and T at the same time?
> >
> > No, the hardware can do S/S2 or T.
> >
> > The driver in the S2API tree only has S/S2 enabled (for the time
> > being).
>
> So, maybe we have to think a bit about how to add support for this
> kind of device.
>
> Maybe a solution could be to have :
> - adapter0/frontend0 -> S/S2 tuner
> - adapter0/frontend1 -> T tuner
>
> So applications could know that these 2 frontends are exclusive.
> That would not require any API change, but would have to be a rule
> followed by all drivers.

The experimental HVR4000 does this already and we have at least initial =

support for that in mythtv.

I don't think this was the intended use of multiple frontends in the DVB =

API but AFAIK all dual tuners drivers uses multiple adapters.

I like this approach.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
