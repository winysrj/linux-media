Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bar.sig21.net ([88.198.146.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <js@sig21.net>) id 1KfCTx-0004Ig-Dz
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 13:43:06 +0200
Date: Mon, 15 Sep 2008 13:43:00 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Christophe Thommeret <hftom@free.fr>
Message-ID: <20080915114300.GB13335@linuxtv.org>
References: <48CA0355.6080903@linuxtv.org> <48CD4004.4040005@linuxtv.org>
	<200809142004.06876.hftom@free.fr>
	<200809150414.41360.hftom@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200809150414.41360.hftom@free.fr>
Cc: Steven Toth <stoth@hauppauge.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
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

On Mon, Sep 15, 2008, Christophe Thommeret wrote:
> Le Sunday 14 September 2008 20:04:06 Christophe Thommeret, vous avez =E9c=
rit=A0:
> >
> > as you expected, it's abit buggy and crashes at load ;)
> > i've searched for the alternative cinergyT2 driver.
> > it's available at: http://linuxtv.org/hg/~tmerle/cinergyT2/
> >
> > haven't tried it yet but will do (at least several people seems to have=
 it
> > working).
> =

> Have it working, not as good as Holger' one (often fails to lock) but it =

> works, with both old and new api.

Looking at the code, cinergyt2_fe_get_tune_settings() should
probably set step_size =3D max_drift =3D 0 to defeat
dvb_frontend_swzigzag_autotune().
c.f. mt352_get_tune_settings()


HTH,
Johannes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
