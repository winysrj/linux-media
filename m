Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@kaiser-linux.li>) id 1Ks1N4-0006H0-5C
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 22:29:01 +0200
Received: from localhost (localhost.lie-comtel.li [127.0.0.1])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id A729D9FEC19
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 21:28:54 +0100 (GMT-1)
Received: from [192.168.0.16] (217-173-228-198.cmts.powersurf.li
	[217.173.228.198])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 754CA9FEC16
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 21:28:54 +0100 (GMT-1)
Message-ID: <48FCEA05.7060600@kaiser-linux.li>
Date: Mon, 20 Oct 2008 22:28:53 +0200
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20081016190946.GB25806@geppetto>
	<20081019142030.GA10261@geppetto>	<28a25ce0810191325r7b1e3903jae703a79477e2758@mail.gmail.com>
	<20081020193632.GA5685@geppetto>
In-Reply-To: <20081020193632.GA5685@geppetto>
Subject: Re: [linux-dvb] v4l-dvb gspca modules conflict
 with	standalone	gspca module
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

Stefano Sabatini wrote:
> On date Sunday 2008-10-19 22:25:29 +0200, Rom=E1n wrote:
>> 2008/10/19 Stefano Sabatini <stefano.sabatini-lala@poste.it>:
>>> BTW I wonder why v4l-dvb includes the gspca modules, which seem to be
>>> related more to the gspca cameras than to DVB devices
> [...]
>> I wonder as well. The standalone driver works with my webcam, but the
>> v4l-dvb one provokes a kernel panic on my system, after a short period
>> of using it (or it used to; admittedly it's been quite a while -a few
>> months- since I last tried).
> =

> For the archive: gspca based cameras finally stopped to work with the
> v4l-dvb modules on linux-2.6.26, reinstalling the kernel and the
> standalone module fixed it.
> =

> Please could the core devs clarify the situation for what regards
> gscpa modules in v4l-dvb?
> =

> Thanks, regards.
> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hello Stefano

The gspca module V1 was developed outside of the kernel tree. Therefor, =

it was possible to add "in kernel" video decompression/decoding, which =

is not allowed and not good to do in kernel space. But this was a great =

success to add more than 220 webcams to the Linux World.

Now, gspca V1 is moving to gspca V2 to support V4L2. Jean-Francois Moine =

(moinejf@free.fr) did a rewrite to support V4L2 with gspca. Thus, its =

called gspca V2. He removed all the not allowed decoding process which =

was done in kernel space with the old gspca.

Now, gspca V2 got included into the kernel! (Big step forward)

Hans de Goede (j.w.r.degoede@hhs.nl) is writing a user space lib to =

convert/decode all the stuff which was done in the old gspca in kernel =

space, his lib does it now in user space. That's the way to go!

The development of this is rather new and I think it is not included in =

any distro at the moment. But it will be soon.

So, please drop the the old gspca V1 and help testing gspca V2!

BTW: gspca is in v4l-dvb because v4l is for analogue deceives and dvb is =

for digital devices. gspca fits perfect into v4l!

Thomas

PS: Pixart, but now free time to do more, sorry.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
