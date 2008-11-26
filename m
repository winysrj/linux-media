Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp21.orange.fr ([80.12.242.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1L5Qj7-0000oA-CM
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 21:11:10 +0100
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Wed, 26 Nov 2008 21:10:40 +0100
References: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
	<3cc3561f0811251034v7ac1a77dt7a2233a62b6a8f1c@mail.gmail.com>
	<492DA760.2050401@iki.fi>
In-Reply-To: <492DA760.2050401@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811262110.41681.hftom@free.fr>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

Le mercredi 26 novembre 2008 20:45:36 Seppo Ingalsuo, vous avez =E9crit=A0:
> Morgan T=F8rvolt wrote:
> > In all honesty, having this as a user setting,
> > it would only need to be set once, which hardly qualify as hard work.
>
> I fully support Klaus' opinion. My motherboard bios and udev initialize
> my three DVB cards into "random" order that is depending whether the
> boot was cold or warm. Application level setting of dvbN device
> capabilities would not work for me reliably.

Since there is no way to uniquely identify a device, your problem could =

remain.
Anyway, i agree that querying such capabilities (and more in future) is =

needed.
Just a matter of time.
Klaus' proposal would work, but i'm not sure it's the right way, looks old =

fashion. I think the right way is to use the new API. Steven already had id=
eas =

in this matter but was too buzy. Let's hope he comes soon on this issue. =

(maybe end of week)

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
