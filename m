Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: Johannes Stezenbach <js@linuxtv.org>
Date: Tue, 16 Sep 2008 04:58:49 +0200
References: <48CA0355.6080903@linuxtv.org> <200809150414.41360.hftom@free.fr>
	<20080915114300.GB13335@linuxtv.org>
In-Reply-To: <20080915114300.GB13335@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809160458.49923.hftom@free.fr>
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

Le Monday 15 September 2008 13:43:00 Johannes Stezenbach, vous avez =E9crit=
=A0:
> On Mon, Sep 15, 2008, Christophe Thommeret wrote:
> > Le Sunday 14 September 2008 20:04:06 Christophe Thommeret, vous avez =

=E9crit=A0:
> > > as you expected, it's abit buggy and crashes at load ;)
> > > i've searched for the alternative cinergyT2 driver.
> > > it's available at: http://linuxtv.org/hg/~tmerle/cinergyT2/
> > >
> > > haven't tried it yet but will do (at least several people seems to ha=
ve
> > > it working).
> >
> > Have it working, not as good as Holger' one (often fails to lock) but it
> > works, with both old and new api.
>
> Looking at the code, cinergyt2_fe_get_tune_settings() should
> probably set step_size =3D max_drift =3D 0 to defeat
> dvb_frontend_swzigzag_autotune().
> c.f. mt352_get_tune_settings()

Thanx for the hint, unfortunately it doesn't help.
In fact, if i set a larger timeout (time after which kaffeine gives up and =

report tuning failure), say 5000ms, it always locks.
The average lock time is about 2000ms, but sometimes it goes up to 4000 and =

sometimes it's only 200, randomly for all freqs.
If you have any idea, you are welcome :)

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
