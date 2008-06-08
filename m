Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+ceff2bb65cb28e3d964d+1750+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1K5JZv-00051r-7P
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 14:00:55 +0200
Date: Sun, 8 Jun 2008 08:58:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Morgan =?ISO-8859-1?Q?T=F8rvolt?=" <morgan.torvolt@gmail.com>
Message-ID: <20080608085839.284a42d6@gaivota>
In-Reply-To: <3cc3561f0806080428n4cd2a861q62197b748274ab68@mail.gmail.com>
References: <3cc3561f0806031337v18517af4ncc6a75fa0b4a47e4@mail.gmail.com>
	<20080603191046.6b910605@gaivota>
	<3cc3561f0806032300r5bc6aa51ja7065969df1f8597@mail.gmail.com>
	<alpine.LFD.1.10.0806040544290.14367@bombadil.infradead.org>
	<3cc3561f0806080428n4cd2a861q62197b748274ab68@mail.gmail.com>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Providers in Brazil
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

On Sun, 8 Jun 2008 13:28:52 +0200
"Morgan T=F8rvolt" <morgan.torvolt@gmail.com> wrote:

> >  There are lots of DVB-S channels, most of them are free to the air. A =
good
> > place for you to take a look is Lyngsat [1]. There's also a Brazilian s=
ite
> > that have updated channel listings [2]. The last one is in Portuguese.
> >
> >  [1] http://www.lyngsat.com/freetv/Brazil.html
> >  [2] http://www.brasilsatdigital.com.br/satelites/index.htm
> >
> >  Cheers,
> >  Mauro
> =

> Thanks. I had not seen that last page you sent.
> =

> The question remaining is which of these pay-TV providers that use
> encryption and CAMs that work with linux.

AFAIK, there are only two providers that offers packages to the end users: =
Direct
TV/Sky and Tecsat. I'm not 100% sure, but suspect that Direct TV/Sky is usi=
ng
DSS. DSS is currently not supported on Linux. I'm not sure what Tecsat uses.

There are other channels that are encrypted, like TV Globo. I'm not sure wh=
at's
their business model, and if they sell content to the end users.

In thesis, Linux CAM could decrypt those channels, if you have the keycard =
and
a CAM module.

> Also, which one of these would be recommended for an english speaking cro=
wd?

There are some satellite beams that receives channels from North America and
Europe. This will depend on what position you'll point your sat antenna.

For example, if you point your antenna to Galaxy28 [1], you could receive l=
ots of
contents in English and Spanish, encrypted with Ireto 2 (see freq 11800H),
pointed to South America. To decrypt, you will need a CAM module, and a val=
id
Ireto 2 key from the content provider [2].

[1] http://www.lyngsat.com/galaxy28.html
[2] actually, I never tried to receive a non-FTA channel. So, I'm not sure =
what
crypto standards will work properly. There are some wiki's at linuxtv.org a=
bout
CAM that can be helpful to you.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
