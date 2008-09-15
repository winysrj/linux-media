Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2f.orange.fr ([80.12.242.151])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Kf3bV-0006Y9-5c
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 04:14:21 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Mon, 15 Sep 2008 04:14:41 +0200
References: <48CA0355.6080903@linuxtv.org> <48CD4004.4040005@linuxtv.org>
	<200809142004.06876.hftom@free.fr>
In-Reply-To: <200809142004.06876.hftom@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809150414.41360.hftom@free.fr>
Cc: Steven Toth <stoth@hauppauge.com>
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

Le Sunday 14 September 2008 20:04:06 Christophe Thommeret, vous avez =E9cri=
t=A0:
> Le Sunday 14 September 2008 18:47:00 Steven Toth, vous avez =E9crit=A0:
> > Steven Toth wrote:
> > > Johannes Stezenbach wrote:
> > >> On Fri, Sep 12, 2008, Steven Toth wrote:
> > >>> Christophe Thommeret wrote:
> > >>>> As far  as i understand, the cinergyT2 driver is a bit unusual, e.=
g.
> > >>>> dvb_register_frontend is never called (hence no dtv_* log messages=
).
> > >>>> I don't know if there is others drivers like this, but this has to
> > >>>> be investigated cause rewritting all drivers for S2API could be a
> > >>>> bit of work :)
> > >>>>
> > >>>> P.S.
> > >>>> I think there is an alternate driver for cinergyT2 actually in
> > >>>> developement but idon't remember where it's located neither its
> > >>>> state.
> > >>>
> > >>> Good to know. (I also saw your followup email). I have zero
> > >>> experience with the cinergyT2 but the old api should still be worki=
ng
> > >>> reliably. I plan to investigate this, sounds like a bug! :)
> > >>
> > >> Holger was of the opinion that having the demux in dvb-core
> > >> was stupid for devices which have no hw demux, so he
> > >> programmed around dvb-core. His plan was to add a
> > >> mmap-dma-buffers kind of API to the frontend device,
> > >> but it never got implemented.
> > >>
> > >> Anyway, it's bad if one driver is different than all the others.
> > >
> > > Hmm, I didn't realize this, good to know.
> > >
> > > Now it's peaked my interest, I'll have to look at the code.
> > >
> > > The existing API should still work at a bare minimum, if it's not - it
> > > needs to.
> >
> > So I looked the the cinergyT2 code, that's a complete eye-opener. It has
> > it's own ioctl handler, outside of dvb-core.
> >
> > It's a good news / bad news thing.
> >
> > The good news is that this driver will not be effected by the S2API
> > changes, so nothing can break.
> >
> > The bad news is that this driver will not be effected by the S2API
> > changes, so it doesn't get the benefit.
> >
> > Regardless of S2API or multiproto, I see no reason why we shouldn't
> > bring this driver back into dvb-core.
> >
> > I don't have a device to test, but here's a patch (0% tested, with bugs
> > probably) that converts the module back to a regular dvb-core compatible
> > device, so the S2API would work with this. If anyone wants to test this,
> > and finds bugs - I won't get back to this driver for a couple of weeks -
> > so your patches would be welcome. :)
> >
> > Frankly, is S2API is selected for merge and we have enough users of the
> > current non-dvb-core driver, I'll probably re-write it from the spec.
> >
> > So much to do, so little time.
> >
> > - Steve
>
> Steve,
>
> as you expected, it's abit buggy and crashes at load ;)
> i've searched for the alternative cinergyT2 driver.
> it's available at: http://linuxtv.org/hg/~tmerle/cinergyT2/
>
> haven't tried it yet but will do (at least several people seems to have it
> working).

Have it working, not as good as Holger' one (often fails to lock) but it =

works, with both old and new api.
So, one problem less :)

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
