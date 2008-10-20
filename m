Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1Ks0ZR-0001Hk-S3
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 21:37:46 +0200
Received: from geppetto.reilabs.com (78.15.179.122) by relay-pt1.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 48FBCA4D0000A178 for linux-dvb@linuxtv.org;
	Mon, 20 Oct 2008 21:37:37 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1Ks0YQ-0001dQ-84
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 21:36:38 +0200
Date: Mon, 20 Oct 2008 21:36:32 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: linux-dvb@linuxtv.org
Message-ID: <20081020193632.GA5685@geppetto>
References: <20081016190946.GB25806@geppetto> <20081019142030.GA10261@geppetto>
	<28a25ce0810191325r7b1e3903jae703a79477e2758@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <28a25ce0810191325r7b1e3903jae703a79477e2758@mail.gmail.com>
Subject: Re: [linux-dvb] v4l-dvb gspca modules conflict with
	standalone	gspca module
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

On date Sunday 2008-10-19 22:25:29 +0200, Rom=E1n wrote:
> 2008/10/19 Stefano Sabatini <stefano.sabatini-lala@poste.it>:
> >
> > BTW I wonder why v4l-dvb includes the gspca modules, which seem to be
> > related more to the gspca cameras than to DVB devices
[...]
> I wonder as well. The standalone driver works with my webcam, but the
> v4l-dvb one provokes a kernel panic on my system, after a short period
> of using it (or it used to; admittedly it's been quite a while -a few
> months- since I last tried).

For the archive: gspca based cameras finally stopped to work with the
v4l-dvb modules on linux-2.6.26, reinstalling the kernel and the
standalone module fixed it.

Please could the core devs clarify the situation for what regards
gscpa modules in v4l-dvb?

Thanks, regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
