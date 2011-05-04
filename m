Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:60421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab1EDUj1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 16:39:27 -0400
Date: Wed, 4 May 2011 13:36:13 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix cx88 remote control input
Message-ID: <20110504203613.GA1091@kroah.com>
References: <1302267045.1749.38.camel@gagarin>
 <4DBEFD02.70906@redhat.com>
 <1304407514.1739.22.camel@gagarin>
 <D7FAB30A-E204-47B9-A7A0-E3BF50EE7FBD@wilsonet.com>
 <4DC1B41D.9090200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC1B41D.9090200@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, May 04, 2011 at 05:16:29PM -0300, Mauro Carvalho Chehab wrote:
> Hi Lawerence,
> 
> Em 03-05-2011 14:19, Jarod Wilson escreveu:
> > On May 3, 2011, at 3:25 AM, Lawrence Rust wrote:
> > 
> >> On Mon, 2011-05-02 at 15:50 -0300, Mauro Carvalho Chehab wrote:
> >>> Em 08-04-2011 09:50, Lawrence Rust escreveu:
> >>>> This patch restores remote control input for cx2388x based boards on
> >>>> Linux kernels >= 2.6.38.
> >>>>
> >>>> After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
> >>>> control input of my Hauppauge Nova-S plus was no longer functioning.  
> >>>> I posted a question on this newsgroup and Mauro Carvalho Chehab gave
> >>>> some helpful pointers as to the likely cause.
> >>>>
> >>>> Turns out that there are 2 problems:
> >>>>
> >>>> 1. In the IR interrupt handler of cx88-input.c there's a 32-bit multiply
> >>>> overflow which causes IR pulse durations to be incorrectly calculated.
> 
> I'm adding the patch for it today on my linux-next tree. I'll probably send
> upstream on the next couple days.
> 
> >>>>
> >>>> 2. The RC5 decoder appends the system code to the scancode and passes
> >>>> the combination to rc_keydown().  Unfortunately, the combined value is
> >>>> then forwarded to input_event() which then fails to recognise a valid
> >>>> scancode and hence no input events are generated.
> 
> In this case, a patch should be sent to -stable in separate.
> 
> Greg,
> 
> On 2.6.38, there are two RC5 keytables for Hauppauge devices, one with incomplete
> scancodes (just 8 bits for each key) and the other one with 14 bits. One patch
> changed the IR handling for cx88 to accept 14-bits for scancodes, but the change
> didn't switch to the complete table.
> 
> For 2.6.39, all keytables for Hauppauge (4 different tables) were unified into
> just one keytable. So, on 2.6.39-rc, the cx88 code already works fine for 64-bits
> kernels, and the fix for 32-bits is undergoing.
> 
> In the case of 2.6.38 kernel, the Remote Controller is broken for both kernels.
> The fix is as simple as:
> 
> --- a/drivers/media/video/cx88/cx88-input.c
> +++ b/drivers/media/video/cx88/cx88-input.c
> @@ -283,7 +283,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
> 	case CX88_BOARD_PCHDTV_HD3000:
> 	case CX88_BOARD_PCHDTV_HD5500:
> 	case CX88_BOARD_HAUPPAUGE_IRONLY:
> -		ir_codes = RC_MAP_HAUPPAUGE_NEW;
> +		ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
> 		ir->sampling = 1;
> 		break;
> 	case CX88_BOARD_WINFAST_DTV2000H:
> 
> 
> But this change diverges from upstream, due to the table unify. Would such patch
> be acceptable for stable, even not having a corresponding upstream commit?

Yes, as long as .39 is working properly.  We take patches in -stable for
stuff like this at times, it just needs to be specified exactly like you
did above.  Want me to take this patch as-is for .38-stable?

thanks,

greg k-h
