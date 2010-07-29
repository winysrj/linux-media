Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab0G2Tdw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 15:33:52 -0400
Date: Thu, 29 Jul 2010 15:21:50 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: maximlevitsky@gmail.com, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
Message-ID: <20100729192150.GC7507@redhat.com>
References: <1280414519.29938.53.camel@maxim-laptop>
 <BTlN15rJjFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BTlN15rJjFB@christoph>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 29, 2010 at 06:58:00PM +0200, Christoph Bartelmus wrote:
> Hi Maxim,
> 
> on 29 Jul 10 at 17:41, Maxim Levitsky wrote:
> [...]
> >>> Note that I send timeout report with zero value.
> >>> I don't think that this value is importaint.
> >>
> >> This does not sound good. Of course the value is important to userspace
> >> and 2 spaces in a row will break decoding.
> >>
> >> Christoph
> 
> > Could you explain exactly how timeout reports work?
> 
> It all should be documented in the interface description. Jarod probably  
> can point you where it can be found.

There's a start to interface documentation at
Documentation/DocBook/v4l/lirc_device_interface.xml, and it does cover
timeout report usage.

(Side note: I forgot, Mauro asked if we could flesh out that document even
further with descriptions of the assorted defines beyond just the ioctls.
I'm going to scribble that on my TODO list right now...)

-- 
Jarod Wilson
jarod@redhat.com

