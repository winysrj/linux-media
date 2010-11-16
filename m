Return-path: <mchehab@pedra>
Received: from pfepa.post.tele.dk ([195.41.46.235]:33609 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab0KPVwV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:52:21 -0500
Date: Tue, 16 Nov 2010 22:52:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] kconfig: add an option to determine a menu's
	visibility
Message-ID: <20101116215219.GA19230@merkur.ravnborg.org>
References: <4CD300AC.3010708@redhat.com> <1289079027-3037-2-git-send-email-lacombar@gmail.com> <AANLkTinwmSOSnQ6SsLy4ijXmocccX=o+iHh+9otfmAmN@mail.gmail.com> <4CE2C2F9.9010801@redhat.com> <AANLkTim6VNvSTWOC_jZR09ktRaKUFaGorPz-cpS5bG7C@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim6VNvSTWOC_jZR09ktRaKUFaGorPz-cpS5bG7C@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 16, 2010 at 04:41:06PM -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Tue, Nov 16, 2010 at 12:44 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em 15-11-2010 14:57, Arnaud Lacombe escreveu:
> >> Hi all
> >>
> >> On Sat, Nov 6, 2010 at 5:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> >>> This option is aimed to add the possibility to control a menu's visibility
> >>> without adding dependency to the expression to all the submenu.
> >>>
> >>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> >>> ---
> >>>  scripts/kconfig/expr.h      |    1 +
> >>>  scripts/kconfig/lkc.h       |    1 +
> >>>  scripts/kconfig/menu.c      |   11 +++++++++++
> >>>  scripts/kconfig/zconf.gperf |    1 +
> >>>  scripts/kconfig/zconf.y     |   21 ++++++++++++++++++---
> >>>  5 files changed, 32 insertions(+), 3 deletions(-)
> >>>
> >> Michal, I don't think you commented on this ? Mauro, has it been
> >> worked around differently ?
> >
> > Those patches worked fine, and solved all problems we had (I just had to touch
> > on two other menus that are used, as I answered upstream).
> >
> > I prefer if Michal could forward those patches upstream, so, there's my ack:
> >
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >
> It would seem Michal is not around lately, his only passage on
> linux-kbuild@ is nearly a week old.
> 
> Sam, by any chance, could you comment on these patches so that we
> could keep moving forward ?
I will try to take a look in the weekend - daytime job keeps me busy as usual.

> 
> Thanks,
>  - Arnaud
> 
> ps: yes, I know, I did not upgrade the documentation.
And I will toast you for that when I look at the patches :-)

	Sam
