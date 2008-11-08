Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sat, 8 Nov 2008 08:15:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Andre Kelmanson" <akelmanson@gmail.com>
Message-ID: <20081108081508.496f6582@pedra.chehab.org>
In-Reply-To: <a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<200811011459.17706.hverkuil@xs4all.nl>
	<20081102022728.68e5e564@pedra.chehab.org>
	<a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
Mime-Version: 1.0
Cc: Vitaly Wool <vwool@ru.mvista.com>, Dan
	Kreiser <kreiser@informatik.hu-berlin.de>,
	Lukas Kuna <lukas.kuna@evkanet.net>, acano@fastmail.fm, John
	Stowers <john.stowers.lists@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>,
	Zhenyu Wang <zhen78@gmail.com>,
	v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
	em28xx <em28xx@mcentral.de>, greg@kroah.com,
	Stefan Vonolfen <stefan.vonolfen@gmail.com>,
	Stephan Berberig <s.berberig@arcor.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Frank Neuber <fn@kernelport.de>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
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
List-ID: <video4linux-list@redhat.com>

On Sat, 8 Nov 2008 03:50:20 -0200
"Andre Kelmanson" <akelmanson@gmail.com> wrote:

> Dears,
> =

> I'm using this version of em28xx for a long time and it's working fine. It
> has three very important features for me. The first one is Kaiomy device,
> the second one is the new em28xx-audoep module and the third one is PAL-M
> support. Kaiomy and PAL-M support were developed based on my support on t=
he
> em28xx mailinglist.
> =

> Now I can use my device (Kaiomy) outside Windows with sound (em28xx-audio=
ep)
> and colors (PAL-M)! I'm using this version everyday with no problems.
> =

> Because of this, it will be nice if this work could be included in the
> kernel code. What do you (other users) think about having that driver in
> kernel?

Andr=E9,

First of all, the big issue why we aren't merging em28xx improvements from
Markus is that he is not following the rules.

For example, you said that you've contributed with Markus tree.

However, on Markus pull request, I see no patch from you on his series of p=
atches. =


The correct procedure would be just to forward your patch as-is, adding wit=
h his SOB bellow yours.

Not doing this, he would be considered as the author of your patch. IANAL, =
but
this doesn't seem to be right, from GPL's perspective. Probably, there are
other patches there not authored by Markus that are just merged inside his =
big patch.

About PAL-M, this always worked at the upstream driver. I have myself lots =
of
em28xx devices, all working in colors with PAL-M, and with audio. I live in
Brazil, so I always check if PAL-M is ok ;)

If you want to have your device supported, just send us a patch against the
upstream driver.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
