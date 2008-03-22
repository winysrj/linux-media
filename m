Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1Jd3Gl-0003Jj-BR
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 13:56:22 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1466938fge.25
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 05:56:15 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Mar 2008 13:56:06 +0100
References: <200803212024.17198.christophpfister@gmail.com>
	<200803220732.06390@orion.escape-edv.de>
In-Reply-To: <200803220732.06390@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803221356.06976.christophpfister@gmail.com>
Cc: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

Am Samstag 22 M=E4rz 2008 schrieb Oliver Endriss:
> Christoph Pfister wrote:
> > Hi,
> >
> > Can somebody please pick up those patches (descriptions inlined)?
>
> Are these patches well-tested?

It's the initial post; so far it's only me who tested them carefully :)

The first one is pretty straightforward and shouldn't have any negative sid=
e =

effects (because it changes behaviour in the case where the current code =

simply fails with "ejected 3" error).
The second one is used in the same way for "similar" cards.

> > <<<fix-budget-av-cam.diff>>>
>
> Looks ok to me.
>
> @budget-av users who own a CAM:
>
> Please test this patch!
>
> > <<<fix-knc1-dvbs-ci.diff>>>
> >        case SUBID_DVBS_KNC1:
> >        case SUBID_DVBS_KNC1_PLUS:
> >        case SUBID_DVBS_EASYWATCH_1:
> >+               budget_av->reinitialise_demod =3D 1;
> >
> > Fix CI interface on (some) KNC1 DVBS cards
> > Quoting the commit introducing reinitialise_demod (3984 / by adq):
> > "These cards [KNC1 DVBT and DVBC] need special handling for CI -
> > reinitialising the frontend device when the CI module is reset."
> > Apparently my 1894:0010 also needs that fix, because once you initialise
> > CI/CAM you lose lock. Signed-off-by: Christoph Pfister
> > <pfister@linuxtv.org>
>
> Are you _sure_ that 'reinitialise_demod =3D 1' is required by all 3 card
> types,

Of course not - I don't own a heap of cards ;)
I applied it to all 3 types because Andrew did the same for a couple of =

dvb-c/t cards - at the moment all dvb-c/t cards inside budget-av use =

reinitialise_demod =3D 1.
(It could even be needed for one of the remaining dvb-s cards - who knows .=
..)

> and does not hurt for SUBID_DVBS_KNC1_PLUS (1131:0011, 1894:0011) =

> and SUBID_DVBS_EASYWATCH_1 (1894:001a)?

It's quite unlikely that there are any negative side effects given that it'=
s =

quite widespread inside budget-av. As long as you don't use a cam the effec=
t =

is zero anyway - for the other case I can't give guarantees (an unnecessary =

demod reinit after resetting the cam likely seems to be the only possible =

drawback).

> CU
> Oliver

Thanks,

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
