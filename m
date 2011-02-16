Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:59671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab1BPVH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 16:07:28 -0500
Date: Wed, 16 Feb 2011 12:50:43 -0800
From: Greg KH <greg@kroah.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, gregkh@suse.de,
	stable@kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [stable] [PATCH 0/4] gspca fix backports for 2.6.36
Message-ID: <20110216205043.GC5115@kroah.com>
References: <20110106092836.14a0da68@gaivota>
 <20110106135640.57fd23b8@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106135640.57fd23b8@tele>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 06, 2011 at 01:56:40PM +0100, Jean-Francois Moine wrote:
> On Thu, 6 Jan 2011 09:28:36 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > This patch series backport POWER INV fixes for sonixj sensors.
> > 
> > Jean,
> > 
> > I'm currently without any sensorj camera. Could you please test this
> > backport? Greg already backported two patches of this series. Those
> > patches should be applied after stable patches he sent yesterday
> > (151/152 and 152/152). All patches are at the ML.
> 
> Hi Mauro,
> 
> I have no sonixj webcam and my contacts would not know how to test.
> 
> The patches seem fine to me. Anyway, if there is no error while
> patching and compiling, they should work.

Oops, I see this now, sorry.

.36 is now end-of-life, I suggest using .37 as these changes are all
there.

thanks,

greg k-h
