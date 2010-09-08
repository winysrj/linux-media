Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:36502 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0IHXJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 19:09:50 -0400
Date: Thu, 9 Sep 2010 01:09:46 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 4/6] Input: winbond-cir - switch to using new keycode
 interface
Message-ID: <20100908230946.GB7121@hardeman.nu>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <20100908074200.32365.98120.stgit@hammer.corenet.prv>
 <20100908211617.GB13938@hardeman.nu>
 <20100908230003.GB9405@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100908230003.GB9405@core.coreip.homeip.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 04:00:04PM -0700, Dmitry Torokhov wrote:
> On Wed, Sep 08, 2010 at 11:16:17PM +0200, David Härdeman wrote:
> > On Wed, Sep 08, 2010 at 12:42:00AM -0700, Dmitry Torokhov wrote:
> > > Switch the code to use new style of getkeycode and setkeycode
> > > methods to allow retrieving and setting keycodes not only by
> > > their scancodes but also by index.
> > > 
> > > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > > ---
> > > 
> > >  drivers/input/misc/winbond-cir.c |  248 +++++++++++++++++++++++++-------------
> > >  1 files changed, 163 insertions(+), 85 deletions(-)
> > 
> > Thanks for doing the conversion for me, but I think you can skip this 
> > patch. The driver will (if I understood your patchset correctly) still 
> > work with the old get/setkeycode ioctls and I have a patch lined up that 
> > converts winbond-cir.c to use ir-core which means all of the input 
> > related code is removed.
> > 
> 
> Yes, it should still work with old get/setkeycode. What are the plans
> for your patch? .37 or later?

Up to Mauro but I believe it's .37 (sometime after your input patches 
land).

-- 
David Härdeman
