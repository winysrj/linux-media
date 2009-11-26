Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45146 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbZKZXXJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 18:23:09 -0500
Date: Thu, 26 Nov 2009 15:23:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126232311.GD6936@core.coreip.homeip.net>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com> <20091126053109.GE23244@core.coreip.homeip.net> <A910E742-51B5-45E0-AD80-B9AE0728D9FB@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A910E742-51B5-45E0-AD80-B9AE0728D9FB@wilsonet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 01:16:01AM -0500, Jarod Wilson wrote:
> On Nov 26, 2009, at 12:31 AM, Dmitry Torokhov wrote:
> 
> > On Mon, Nov 23, 2009 at 11:37:53PM -0500, Jarod Wilson wrote:
> >> On 11/23/2009 12:37 PM, Dmitry Torokhov wrote:
> >>> On Mon, Nov 23, 2009 at 03:14:56PM +0100, Krzysztof Halasa wrote:
> >>>> Mauro Carvalho Chehab<mchehab@redhat.com>  writes:
> >>>> 
> >>>>> Event input has the advantage that the keystrokes will provide an unique
> >>>>> representation that is independent of the device.
> >>>> 
> >>>> This can hardly work as the only means, the remotes have different keys,
> >>>> the user almost always has to provide customized key<>function mapping.
> >>>> 
> >>> 
> >>> Is it true? I would expect the remotes to have most of the keys to have
> >>> well-defined meanings (unless it is one of the programmable remotes)...
> >> 
> >> Its the cases like programmable universal remotes that really throw  
> >> things for a loop. That, and people wanting to use random remote X that  
> >> came with the amp or tv or set top box, with IR receiver Y.
> > 
> > Right, but still the keys usually do have the well-defined meaning,
> 
> Except when they don't. I have two very similar remotes, one that was bundled with a system from CaptiveWorks, and one that was bundled with an Antec Veris IR/LCD (SoundGraph iMON rebrand). Outside of the Antec remote having a mouse pad instead of up/down/left/right/enter, they have an identical layout, and the keys in the same locations on the remotes send the same IR signal. But the button names vary a LOT between the two. So on the DVD key on the Antec and the MUTE key on the CW send the same signal. Same with Audio vs. Eject, TV vs. History, etc. Moral of the story is that not all IR protocols spell things out particularly well for what a given code should actually mean.

I guess we are talking about different things. While the 2 remotes may
use different protocols to communicate and may use the same codes to
mean different things they buttons have well-defined meaning and we
could map that to input keycodes. Then what is left is to load the
proper mapping for particular device into the kernel. This can be done
either automatically (when we know the mapping) or with the help of the
user (owner of the system).

> 
> > teh
> > issue is in mapping raw code to the appropriate keycode. This can be
> > done either by lirc config file (when lirc is used) or by some other
> > means.
> 
> The desire to map a button press to multiple keystrokes isn't uncommon either, though I presume that's doable within the input layer context too.

No, at present we expect 1:1 button->event mapping leaving macro
expansion (i.e. KEY_PROG1 -> "do some multi-step sequence" to
userspace).

-- 
Dmitry
