Return-path: <mchehab@pedra>
Received: from cantor.suse.de ([195.135.220.2]:36696 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1EBPdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 11:33:08 -0400
Date: Mon, 2 May 2011 17:33:06 +0200
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/5] kconfig: add an option to determine a menu's
 visibility
Message-ID: <20110502153305.GB15769@sepie.suse.cz>
References: <4CD300AC.3010708@redhat.com>
 <1289079027-3037-2-git-send-email-lacombar@gmail.com>
 <AANLkTi=WS6cveqzxVmwC2wucaCpEJJLHXx0A8XbAChRb@mail.gmail.com>
 <4CEF8C74.8010600@suse.cz>
 <20101126161511.GD9418@sepie.suse.cz>
 <20101126081736.0ba8a90b.rdunlap@xenotime.net>
 <20110428103802.24c77ff4.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428103802.24c77ff4.rdunlap@xenotime.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Apr 28, 2011 at 10:38:02AM -0700, Randy Dunlap wrote:
> On Fri, 26 Nov 2010 08:17:36 -0800 Randy Dunlap wrote:
> 
> > On Fri, 26 Nov 2010 17:15:11 +0100 Michal Marek wrote:
> > > Subject: [PATCH] kconfig: Document the new "visible if" syntax
> 
> Hi,
> 
> Can we get this kconfig-language.txt patch added to the kernel source tree, please?

Thanks for the reminder, I pushed it to kbuild-2.6.git#kconfig now.

Michal
> 
> 
> > > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > > 
> > > diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
> > > index 2fe93ca..2522cca 100644
> > > --- a/Documentation/kbuild/kconfig-language.txt
> > > +++ b/Documentation/kbuild/kconfig-language.txt
> > > @@ -114,6 +114,13 @@ applicable everywhere (see syntax).
> > >  	the illegal configurations all over.
> > >  	kconfig should one day warn about such things.
> > >  
> > > +- limiting menu display: "visible if" <expr>
> > > +  This attribute is only applicable to menu blocks, if the condition is
> > > +  false, the menu block is not displayed to the user (the symbols
> > > +  contained there can still be selected by other symbols, though). It is
> > > +  similar to a conditional "prompt" attribude for individual menu
> > > +  entries.
> > > +
> > 
> > Default value of "visible" is true ??
> > 
> > >  - numerical ranges: "range" <symbol> <symbol> ["if" <expr>]
> > >    This allows to limit the range of possible input values for int
> > >    and hex symbols. The user can only input a value which is larger than
> > > @@ -300,7 +307,8 @@ menu:
> > >  	"endmenu"
> > >  
> > >  This defines a menu block, see "Menu structure" above for more
> > > -information. The only possible options are dependencies.
> > > +information. The only possible options are dependencies and "visible"
> > > +attributes.
> > >  
> > >  if:
> > >  
> > > --
