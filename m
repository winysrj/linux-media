Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JfIGL-0006oe-UU
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 18:21:12 +0100
Received: by fg-out-1718.google.com with SMTP id 22so286502fge.25
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 10:20:57 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 28 Mar 2008 18:20:54 +0100
References: <200803212024.17198.christophpfister@gmail.com>
	<200803220732.06390@orion.escape-edv.de>
In-Reply-To: <200803220732.06390@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803281820.54243.christophpfister@gmail.com>
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
>
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
> types, and does not hurt for SUBID_DVBS_KNC1_PLUS (1131:0011, 1894:0011)
> and SUBID_DVBS_EASYWATCH_1 (1894:001a)?

Do you want me to limit reinitialise_demod to the one type of card I'm usin=
g =

or is it ok for you this way?

(I'll repost a modified version of the first patch removing the 0xff check =

altogether later today ...)

> CU
> Oliver

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
