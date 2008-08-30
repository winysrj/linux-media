Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <udo_richter@gmx.de>) id 1KZSvx-0003JX-S3
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 18:04:18 +0200
Message-ID: <48B96F5E.5050600@gmx.de>
Date: Sat, 30 Aug 2008 18:03:42 +0200
From: Udo Richter <udo_richter@gmx.de>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <48B8400A.9030409@linuxtv.org>
	<78aae6eb0808291405m452462b4l2df267c3066ec28f@mail.gmail.com>
In-Reply-To: <78aae6eb0808291405m452462b4l2df267c3066ec28f@mail.gmail.com>
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

Gr=E9goire FAVRE wrote:
> Is there a patch for VDR to use this (vdr works really well with multipro=
to
> right now, which don't mean I wouldn't choose this one, but I should try
> it before).

There is none yet of course, but once the new API is ready, it might be =

less difficult to get VDR 1.7.0 running on the new API than it looks.

One could start with my dvb-api-wrapper patch for VDR 1.7.0. (Basically =

an userspace wrapper that translates multiproto calls into old API =

calls.) To get VDR running on the new API, only three multiproto API =

calls must be translated to the new API, and these are already isolated =

in separate functions ioctl_DVBFE_SET_DELSYS(), ioctl_DVBFE_SET_PARAMS() =

and ioctl_DVBFE_GET_DELSYS(). Without taking a too deep look into the =

new API, I think this should be possible without too much trouble.

This is of course a temporary solution, nothing final. Maybe, until =

things settle, its even a good idea to get VDR working on all three =

APIs, so people can use whatever works best for them.


Cheers,

Udo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
