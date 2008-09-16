Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bar.sig21.net ([88.198.146.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <js@sig21.net>) id 1Kfi1b-0007jE-En
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 23:23:57 +0200
Date: Tue, 16 Sep 2008 23:24:05 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Christophe Thommeret <hftom@free.fr>
Message-ID: <20080916212405.GA10971@linuxtv.org>
References: <48CA0355.6080903@linuxtv.org> <200809150414.41360.hftom@free.fr>
	<20080915114300.GB13335@linuxtv.org>
	<200809160458.49923.hftom@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200809160458.49923.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
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

On Tue, Sep 16, 2008 at 04:58:49AM +0200, Christophe Thommeret wrote:
> Le Monday 15 September 2008 13:43:00 Johannes Stezenbach, vous avez =E9cr=
it=A0:
> > On Mon, Sep 15, 2008, Christophe Thommeret wrote:
> > > Le Sunday 14 September 2008 20:04:06 Christophe Thommeret, vous avez =
=E9crit=A0:
> > > > as you expected, it's abit buggy and crashes at load ;)
> > > > i've searched for the alternative cinergyT2 driver.
> > > > it's available at: http://linuxtv.org/hg/~tmerle/cinergyT2/
> > > >
> > > > haven't tried it yet but will do (at least several people seems to =
have
> > > > it working).
> > >
> > > Have it working, not as good as Holger' one (often fails to lock) but=
 it
> > > works, with both old and new api.
> >
> > Looking at the code, cinergyt2_fe_get_tune_settings() should
> > probably set step_size =3D max_drift =3D 0 to defeat
> > dvb_frontend_swzigzag_autotune().
> > c.f. mt352_get_tune_settings()
> =

> Thanx for the hint, unfortunately it doesn't help.
> In fact, if i set a larger timeout (time after which kaffeine gives up an=
d =

> report tuning failure), say 5000ms, it always locks.
> The average lock time is about 2000ms, but sometimes it goes up to 4000 a=
nd =

> sometimes it's only 200, randomly for all freqs.
> If you have any idea, you are welcome :)

Not really and I can't test myself since I don't have any hw.

Holger's cinergyT2 driver sets the FE once (on FE_SET_FRONTEND),
and then queries regularly (every 333ms or CONFIG_DVB_CINERGYT2_QUERY_INTER=
VAL)
for the status. It NEVER retries the tuning like dvb_frontend_swzigzag_auto=
tune()
might do, and the step_size =3D max_drift =3D 0 is supposed to prevent
that, but maybe dvb_frontend_swzigzag_autotune() logic is broken?
A printk in the new cinergyT2 driver should tell.

BTW, the cinergyT2 firmware is Open Source, you can find it in
http://linuxtv.org/cgi-bin/viewcvs.cgi/dvb-hw/dvbusb-fx2/termini/
if you are interested. But there is no magic in the firmware,
it just writes mt352 regs on FE_SET_FRONTEND and reads the
status reg for FE_READ_STATUS. That's all.


Johannes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
