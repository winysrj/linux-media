Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LKBOk-0006qa-2B
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 13:51:07 +0100
Date: Tue, 06 Jan 2009 13:50:32 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <49634AFE.2080405@borodulin.fi>
Message-ID: <20090106125032.258680@gmx.net>
MIME-Version: 1.0
References: <49634AFE.2080405@borodulin.fi>
To: Pauli Borodulin <pauli@borodulin.fi>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] The status and future of Mantis driver
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

> Heya!
> =

> I found out that there is some new activity on Manu Abraham's Mantis =

> driver, so I thought I could throw in some thoughts about it.
> =

> I have been using Manu's Mantis driver (http://www.jusst.de/hg/mantis) =

> for over two years now. I have a VP-2033 card (DVB-C) and at least for =

> the last year the driver has worked without any hickups in my daily =

> (VDR) use. For a long time I have thought that the driver should already =

> be merged to the v4l-dvb tree.
> =

> Igor M. Liplianin has created a new tree =

> (http://mercurial.intuxication.org/hg/s2-liplianin) with the description =

> "DVB-S(S2) drivers for Linux". Mantis driver was merged into the tree in =

> October and since then some fixes has also been applied to the driver. =

> Some of these fixes already exist in Manu's tree, some don't. Both trees =

> are missing the remote control support for VP-2033 and VP-2040.

Is s2-liplianin working for you (apart from the remote control support) ?

> Until merging of the driver into s2-liplianin, there was a single tree =

> for the Mantis driver development. Now that there are two trees, I fear =

> that the development could scatter if there's no clear idea how the =

> driver is going to get into v4l-dvb. =


The major difference between the two repositories is that s2-liplianin uses=
 the
S2API (API v5, which has already been released in kernel 2.6.28) and Manu's=
 tree uses
the Multiproto API (which will not be released). So s2-liplianin is much cl=
oser to
v4l-dvb and could easily be merged in.  I saw that Igor synchronized with v=
4l-dvb
just 2 days ago. So s2-liplianin is the main mantis repository. Manu's tree=
 hasn't
been touched for 3 months.

> Also, the driver is not only =

> DVB-S(S2), but it also contains support for VP-2033 (DVB-C), VP-2040 =

> (DVB-C) and VP-3030 (DVB-T). DVB-S(S2) stuff will probably greatly(?) =

> delay getting the support for DVB-C/T Mantis cards into v4l-dvb.

Why will it delay it?

> For my personal use I have created a patch against the latest v4l-dvb =

> based on Manu's Mantis tree including the remote control support for =

> VP-2033 and VP-2040. =


Great! Please post your remote control patch to the mailing list. It would =
be
best to patch s2-liplianin if possible but Manu's tree is probably no diffe=
rent for
this.

> But what I would really like to see is Mantis =

> driver merged into v4l-dvb and later into mainstream.

Me too, I would like to see s2-liplianin merged into v4l-dvb as soon as pos=
sible.

> Igor, what are your thoughts about the Mantis driver? How about the =

> other Mantis users, like Marko Ristola, Roland Scheidegger, and Kristian =

> Slavov?
> =

> Regards,
> Pauli Borodulin

Regards,
Hans

-- =

Release early, release often.

Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL =

f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T4569a

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
