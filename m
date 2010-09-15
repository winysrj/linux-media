Return-path: <mchehab@pedra>
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:45626 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0IOVEW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 17:04:22 -0400
Date: Thu, 16 Sep 2010 00:04:19 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 5/6] Input: ati-remote2 - switch to using new keycode
 interface
Message-ID: <20100915210419.GA6052@sci.fi>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <20100908074205.32365.68835.stgit@hammer.corenet.prv>
 <20100909124003.GT10135@sci.fi>
 <20100913162807.GA14598@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100913162807.GA14598@core.coreip.homeip.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Sep 13, 2010 at 09:28:07AM -0700, Dmitry Torokhov wrote:
> On Thu, Sep 09, 2010 at 03:40:04PM +0300, Ville Syrjälä wrote:
> > On Wed, Sep 08, 2010 at 12:42:05AM -0700, Dmitry Torokhov wrote:
> > > Switch the code to use new style of getkeycode and setkeycode
> > > methods to allow retrieving and setting keycodes not only by
> > > their scancodes but also by index.
> > > 
> > > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > > ---
> > > 
> > >  drivers/input/misc/ati_remote2.c |   93 +++++++++++++++++++++++++++-----------
> > >  1 files changed, 65 insertions(+), 28 deletions(-)
> > > 
> > > diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
> > > index 2325765..b2e0d82 100644
> > > --- a/drivers/input/misc/ati_remote2.c
> > > +++ b/drivers/input/misc/ati_remote2.c
> > > @@ -483,51 +483,88 @@ static void ati_remote2_complete_key(struct urb *urb)
> > >  }
> > >  
> > >  static int ati_remote2_getkeycode(struct input_dev *idev,
> > > -				  unsigned int scancode, unsigned int *keycode)
> > > +				  struct input_keymap_entry *ke)
> > >  {
> > >  	struct ati_remote2 *ar2 = input_get_drvdata(idev);
> > >  	unsigned int mode;
> > > -	int index;
> > > +	int offset;
> > > +	unsigned int index;
> > > +	unsigned int scancode;
> > > +
> > > +	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
> > > +		index = ke->index;
> > > +		if (index >= (ATI_REMOTE2_MODES - 1) *
> >                                                ^^^^
> > That -1 looks wrong. Same in setkeycode().
> > 
> 
> Yes, indeed. Thanks for noticing.

I fixed this bug locally and gave this a short whirl with my RWII.
I tried both the old and new style keycode ioctls. Everything
worked as expected.

So if you want more tags feel free to add my Acked-by and Tested-by
for this (assuming the off-by-one fix is included) and you can add my
Tested-by for patch 1/6 as well.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
