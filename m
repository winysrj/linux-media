Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2b.orange.fr ([80.12.242.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Kq9Uy-0008H3-GY
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 18:45:25 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b14.orange.fr (SMTP Server) with ESMTP id 65D3470000A5
	for <linux-dvb@linuxtv.org>; Wed, 15 Oct 2008 18:44:49 +0200 (CEST)
Received: from [10.0.0.1] (ANantes-256-1-120-135.w90-1.abo.wanadoo.fr
	[90.1.247.135])
	by mwinf2b14.orange.fr (SMTP Server) with ESMTP id 3353D70000A2
	for <linux-dvb@linuxtv.org>; Wed, 15 Oct 2008 18:44:49 +0200 (CEST)
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Wed, 15 Oct 2008 18:44:35 +0200
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48F42D5C.7090908@linuxtv.org> <48F4B366.7050508@linuxtv.org>
In-Reply-To: <48F4B366.7050508@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810151844.36276.hftom@free.fr>
Subject: Re: [linux-dvb] Multi-frontend patch merge (TESTERS FEEDBACK) was:
	Re: [PATCH] S2API: add multifrontend
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

Le Tuesday 14 October 2008 16:57:42 Steven Toth, vous avez =E9crit=A0:
> Andreas Oberritter wrote:
> > Hello Steve,
> >
> > Steven Toth wrote:
> >> I'm mutating the subject thread, and cc'ing the public mailing list in=
to
> >> this conversion. Now is the time to announce the intension to merge
> >> multi-frontend patches, and show that we have tested and are satisfied
> >> with it's reliability across many trees.
> >>
> >> (For those of you not familiar with the patch set, it adds
> >> 'multiple-frontends to a single transport bus' support for the HVR3000
> >> and HVR4000, and potentially another 7134 based design (the 6 way medi=
on
> >> board?).
> >
> > is this code still using more than one demux device per transport bus, =
or
> > has it already been changed to make use of the DMX_SET_SOURCE command?
>
> Yes.
>
> I'm glad you mentioned this, I discussed this at LPC with a number of
> people.
>
> The current code that's being tested in the mfe tree's implements
> multiple demux devices, that has not changed.
>
> Speaking with two other devs at LPC we discussed changing this approach
> (and the current approach for many dual channel boards), to having a
> unified single adapter device, with either multiple demux devices or
> not. As a basic discussion topic the ideal had a lot of support.
>
> A good example of this in the current kernel (without any MFE patches)
> is the current cx23885 driver, that registers adapter0 and adapter1 with
> two different ATSC frontends. I question (and argue) that it should
> really be /dev/dvb/adapter0/demux{0,1}

Yes, sounded logical to me also. The fact that "frontend" and "demux" was =

suffixed with an integer suggested that, that's why kaffeine probes =

frontend/demux >0.
I think that the actual way of populating multiple adpaters is to make thes=
e =

devices working with current apps without any modifications.
On the other hand, since only dreambox drivers seem to use multiple fronten=
ds =

on single adapter, maybe this actual (and bad, i agree) way should be kept =

and multiple frontends on single adapter reserved for exclusive frontends  =

until the api provide such properties query, so applications can assume the=
se =

frontends to be exclusive.

> The same is also true for the for the multi-frontend patches, it should
> probably change (as part of an overall adapterX overhaul) to match the
> LinuxTV DVB API and register only one demux device.
>
> That's a much larger project, and has not been addressed yet. Many users
> will probably also argue that it's unimportant work, when application
> are currently working.
>
> My opinion is that we would review the adapter usage and determine
> whether we need or want to change that. If we do change it we should
> probably add some better application interfaces from the adapter inode -
> In a model similar to the S2API has done for frontends. Applications
> would then be able to query board specific details in a way that cannot
> be easily done now.
>
> However, regardless of my opinions, it would be a mistake to hold back a
> merge of the current multi-frontend patches. Instead, we should merge
> the large number of MFE patches and start a larger adapter level
> discussion and slowly evolve with smaller patches. (We'll need someone
> to draft an RFC).
>
> Are you volunteering to address this larger subject?
>
> - Steve




-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
