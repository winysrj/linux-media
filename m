Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.pena.perez@gmail.com>) id 1KreqD-0004yp-Bg
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 22:25:35 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1149668fga.25
	for <linux-dvb@linuxtv.org>; Sun, 19 Oct 2008 13:25:29 -0700 (PDT)
Message-ID: <28a25ce0810191325r7b1e3903jae703a79477e2758@mail.gmail.com>
Date: Sun, 19 Oct 2008 22:25:29 +0200
From: "=?ISO-8859-1?Q?Rom=E1n?=" <roman.pena.perez@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20081019142030.GA10261@geppetto>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081016190946.GB25806@geppetto> <20081019142030.GA10261@geppetto>
Subject: Re: [linux-dvb] v4l-dvb gspca modules conflict with standalone
	gspca module
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

2008/10/19 Stefano Sabatini <stefano.sabatini-lala@poste.it>:
>
> BTW I wonder why v4l-dvb includes the gspca modules, which seem to be
> related more to the gspca cameras than to DVB devices
>
> Regards.
>

I wonder as well. The standalone driver works with my webcam, but the
v4l-dvb one provokes a kernel panic on my system, after a short period
of using it (or it used to; admittedly it's been quite a while -a few
months- since I last tried).

-- =

           Rom=E1n

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
