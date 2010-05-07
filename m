Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab0EGNNq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 09:13:46 -0400
Date: Fri, 7 May 2010 09:13:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] IR/imon: remove dead IMON_KEY_RELEASE_OFFSET
Message-ID: <20100507131329.GA24239@redhat.com>
References: <20100504122030.GX29093@bicker>
 <20100504140318.GA10813@redhat.com>
 <20100504160641.GZ29093@bicker>
 <20100504191705.GB10813@redhat.com>
 <4BE3FEE0.4000502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE3FEE0.4000502@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 07, 2010 at 08:52:00AM -0300, Mauro Carvalho Chehab wrote:
> Jarod Wilson wrote:
> > On Tue, May 04, 2010 at 06:06:41PM +0200, Dan Carpenter wrote:
> >> On Tue, May 04, 2010 at 10:03:18AM -0400, Jarod Wilson wrote:
> >>> @@ -1205,7 +1204,7 @@ static u32 imon_panel_key_lookup(u64 hw_code)
> >>>  		if (imon_panel_key_table[i].hw_code == (code | 0xffee))
> >>>  			break;
> >>>  
> >>> -	keycode = imon_panel_key_table[i % IMON_KEY_RELEASE_OFFSET].keycode;
> >>> +	keycode = imon_panel_key_table[i].keycode;
> >>>  
> >>>  	return keycode;
> >>>  }
> >> There is still potentially a problem here because if we don't hit the 
> >> break statement, then we're one past the end of the array.
> > 
> > D'oh. Okay, here's v2, should fix that buglet too.
> > 
> > This hack was used when the imon driver was using internal key lookup
> > routines, but became dead weight when the driver was converted to use
> > ir-core's key lookup routines. These bits simply didn't get removed,
> > drop 'em now.
> > 
> > Pointed out by Dan Carpenter.
> > 
> > v2: fix possible attempt to access beyond end of key table array,
> > also pointed out by Dan.
> 
> -ENOSOB
> 
> Please, add your SOB here ;)

D'oh.

Signed-off-by: Jarod Wilson <jarod@redhat.com>


> > ---
> >  drivers/media/IR/imon.c |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
> > index 27743eb..efe219a 100644
> > --- a/drivers/media/IR/imon.c
> > +++ b/drivers/media/IR/imon.c
> > @@ -55,7 +55,6 @@
> >  #define BIT_DURATION	250	/* each bit received is 250us */
> >  
> >  #define IMON_CLOCK_ENABLE_PACKETS	2
> > -#define IMON_KEY_RELEASE_OFFSET		1000
> >  
> >  /*** P R O T O T Y P E S ***/
> >  
> > @@ -1199,13 +1198,14 @@ static u32 imon_panel_key_lookup(u64 hw_code)
> >  {
> >  	int i;
> >  	u64 code = be64_to_cpu(hw_code);
> > -	u32 keycode;
> > +	u32 keycode = KEY_RESERVED;
> >  
> > -	for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++)
> > -		if (imon_panel_key_table[i].hw_code == (code | 0xffee))
> > +	for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++) {
> > +		if (imon_panel_key_table[i].hw_code == (code | 0xffee)) {
> > +			keycode = imon_panel_key_table[i].keycode;
> >  			break;
> > -
> > -	keycode = imon_panel_key_table[i % IMON_KEY_RELEASE_OFFSET].keycode;
> > +		}
> > +	}
> >  
> >  	return keycode;
> >  }
> > 
> 
> 
> -- 
> 
> Cheers,
> Mauro

-- 
Jarod Wilson
jarod@redhat.com

