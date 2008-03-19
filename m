Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1Jc2Dm-0001nt-FP
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 18:37:05 +0100
Received: by nf-out-0910.google.com with SMTP id d21so271547nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 10:36:56 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: "Guillaume =?iso-8859-1?q?Membr=E9?=" <guillaume.ml@gmail.com>
Date: Wed, 19 Mar 2008 18:36:51 +0100
References: <4758d4170803081118x1090f435j39f66822e28fa6a0@mail.gmail.com>
	<19a3b7a80803110450t123fb1b8k9848de7c8739fb44@mail.gmail.com>
	<4758d4170803111132g7e82c75do70fca4736bf528e2@mail.gmail.com>
In-Reply-To: <4758d4170803111132g7e82c75do70fca4736bf528e2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803191836.51210.christophpfister@gmail.com>
Cc: matthieugiroux@yahoo.fr, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Updated scan file for fr-noos-numericable
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

[ re-adding mailing list; CC'ing original submitter (not 100% sure whether =

address is correct though) ]

Am Dienstag 11 M=E4rz 2008 schrieb Guillaume Membr=E9:
> On Tue, Mar 11, 2008 at 12:50 PM, Christoph Pfister
>
> <christophpfister@gmail.com> wrote:
> > Hi,
> >
> >  2008/3/8, Guillaume Membr=E9 <guillaume.ml@gmail.com>:
> > > Hello
> > >
> >  >  Attached is a scan file for the french cable operator "Numericable".
> >  >  Hope this helps :)
> >
> >  <snip>
> >  diff -r 3cde3460d120 util/scan/dvb-c/fr-noos-numericable
> >  --- a/util/scan/dvb-c/fr-noos-numericable       Tue Mar 11 12:40:20 20=
08
> > +0100 +++ b/util/scan/dvb-c/fr-noos-numericable       Tue Mar 11 12:41:=
03
> > 2008 +0100 @@ -1,41 +1,90 @@
> >   # Cable en France
> >   # freq sr fec mod
> >   C 123000000 6875000 NONE QAM64
> >  +C 123125000 6875000 NONE QAM64
> >   C 131000000 6875000 NONE QAM64
> >  +C 131125000 6875000 NONE QAM64
> >  <snip>
> >
> >  Nearly every entry is duplicated (two frequencies are too close to
> >  each other --> both "lead" to the same transponder ...).
> >
> >  >  Regards
> >  >
> >  > Guillaume
> >
> >  Christoph
>
> Your are correct : there is two entry for each transponders but with
> my satelco easy watch dvb-c, I'm not able to detect anything with
> frequencies like 123000000 but with 123125000 it is ok.
>
> So what can we do ?

There are four possible reasons for that behaviour:
1) the card of the original submitter can deal with larger frequency offset=
s =

than yours
2) the driver of your card / the card of the original submitter is/was brok=
en
3) the provider uses slightly different channel parameters for different =

cities
4) the provider changed the channel parameters meanwhile (though - such a =

little change is quite unlikely)

@Matthieu - can you please check whether for example 123125000 works for yo=
u?

> Regards
> Guillaume

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
