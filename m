Return-path: <mchehab@pedra>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48173 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755658Ab1D1Rie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 13:38:34 -0400
Date: Thu, 28 Apr 2011 10:38:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/5] kconfig: add an option to determine a menu's
 visibility
Message-Id: <20110428103802.24c77ff4.rdunlap@xenotime.net>
In-Reply-To: <20101126081736.0ba8a90b.rdunlap@xenotime.net>
References: <4CD300AC.3010708@redhat.com>
	<1289079027-3037-2-git-send-email-lacombar@gmail.com>
	<AANLkTi=WS6cveqzxVmwC2wucaCpEJJLHXx0A8XbAChRb@mail.gmail.com>
	<4CEF8C74.8010600@suse.cz>
	<20101126161511.GD9418@sepie.suse.cz>
	<20101126081736.0ba8a90b.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 26 Nov 2010 08:17:36 -0800 Randy Dunlap wrote:

> On Fri, 26 Nov 2010 17:15:11 +0100 Michal Marek wrote:
> 
> > On Fri, Nov 26, 2010 at 11:31:16AM +0100, Michal Marek wrote:
> > > On 25.11.2010 18:06, Arnaud Lacombe wrote:
> > > > Hi folks,
> > > > 
> > > > On Sat, Nov 6, 2010 at 5:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > > >> This option is aimed to add the possibility to control a menu's visibility
> > > >> without adding dependency to the expression to all the submenu.
> > > >>
> > > >> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> > > >> ---
> > > >>  scripts/kconfig/expr.h      |    1 +
> > > >>  scripts/kconfig/lkc.h       |    1 +
> > > >>  scripts/kconfig/menu.c      |   11 +++++++++++
> > > >>  scripts/kconfig/zconf.gperf |    1 +
> > > >>  scripts/kconfig/zconf.y     |   21 ++++++++++++++++++---
> > > >>  5 files changed, 32 insertions(+), 3 deletions(-)
> > > >>
> > > > As there seem to be no interested from Michal to either, ACK, NACK, or
> > > > even comment this series, please let me withdraw these patches. If
> > > > this mail is not enough to void the patch, I hope to still be able to
> > > > withdraw my Signed-off-by from this particular series, and thus no
> > > > longer be able to certify the origin of the patches to prevent their
> > > > merge.
> > > 
> > > Hi Arnaud,
> > > 
> > > I'm sorry, I was sick for longer time and am now going through the
> > > patches that accumulated during that time. I understand your
> > > frustration, but the fact that I commented / applied some other patches
> > > yesterday and not this one does not mean that I'm ignoring it. Please
> > > accept my apologies, I'm looking at your patch right now...
> > 
> > So the patches look OK to me, I added your patches to
> > kbuild-2.6.git#menu-visibility and merged the branch to for-next. The
> > new syntax should be documented in
> > Documentation/kbuild/kconfig-language.txt, below is a first attempt at
> > it. If the patches work fine in linux-next _and_ you give me permission
> > to push them to Linus, I'll move them to rc-fixes and send a pull
> > request.
> > 
> > Michal
> > 
> > 
> > Subject: [PATCH] kconfig: Document the new "visible if" syntax

Hi,

Can we get this kconfig-language.txt patch added to the kernel source tree, please?


> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > 
> > diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
> > index 2fe93ca..2522cca 100644
> > --- a/Documentation/kbuild/kconfig-language.txt
> > +++ b/Documentation/kbuild/kconfig-language.txt
> > @@ -114,6 +114,13 @@ applicable everywhere (see syntax).
> >  	the illegal configurations all over.
> >  	kconfig should one day warn about such things.
> >  
> > +- limiting menu display: "visible if" <expr>
> > +  This attribute is only applicable to menu blocks, if the condition is
> > +  false, the menu block is not displayed to the user (the symbols
> > +  contained there can still be selected by other symbols, though). It is
> > +  similar to a conditional "prompt" attribude for individual menu
> > +  entries.
> > +
> 
> Default value of "visible" is true ??
> 
> >  - numerical ranges: "range" <symbol> <symbol> ["if" <expr>]
> >    This allows to limit the range of possible input values for int
> >    and hex symbols. The user can only input a value which is larger than
> > @@ -300,7 +307,8 @@ menu:
> >  	"endmenu"
> >  
> >  This defines a menu block, see "Menu structure" above for more
> > -information. The only possible options are dependencies.
> > +information. The only possible options are dependencies and "visible"
> > +attributes.
> >  
> >  if:
> >  
> > --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
