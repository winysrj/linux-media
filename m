Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4985 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BEOhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 09:37:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: firedtv and removal of old IEEE1394 stack
Date: Sat, 5 Feb 2011 15:36:57 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201102031706.12714.hverkuil@xs4all.nl> <20110205152122.3b566ef0@stein>
In-Reply-To: <20110205152122.3b566ef0@stein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102051536.57958.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, February 05, 2011 15:21:22 Stefan Richter wrote:
> On Feb 03 Hans Verkuil wrote:
> > Hi Stefan,
> > 
> > I discovered (somewhat to my surprise) that the IEEE1394 stack was removed
> > from the kernel in 2.6.37. Your commit 66fa12c571d35e3cd62574c65f1785a460105397
> > indicates that the ieee1394 firedtv code can be removed in an indepedent commit.
> > 
> > It seems that this was forgotten since the firedtv-1394.c source is still
> > present.
> 
> It is not forgotten, just delayed. :-)
> 
> > Is it OK if I remove it? I assume that anything that depends on DVB_FIREDTV_IEEE1394
> > can be deleted.
> 
> This stuff can be removed indeed, and will be.  After that, some further
> simplifications are possible since the backend abstraction is no longer
> necessary.

I posted a patch for this already after I discovered that it wasn't build at all
anymore due to incorrect Kconfig dependencies.

If you can Ack this patch (or comment on it if there are problems with it),
then that would be very helpful.

http://git.linuxtv.org/hverkuil/media_tree.git?a=commit;h=f02c316436eef3baf349c489545edc7ade419ff6

It just removes the 1394 parts and fixes the Kconfig dependencies.

> > It would be nice to remove this since building the firedtv driver for older kernels
> > always gives problems on ubuntu due to some missing ieee1394 headers.
> 
> How so?  Then there is something wrong with the backported sources.  If
> CONFIG_IEEE1394 is not defined, neither make nor gcc ever see anything
> that includes ieee1394 headers.  Vice versa regarding CONFIG_FIREWIRE and
> the newer firewire headers.

It is possible using a special build environment to build the latest media
drivers on older kernels. This is a service to our end-users and hopefully
increases our test coverage. But if you compile the latest drivers against an
older kernel that still has the IEEE1394 stack, then anything that still
depends on it gets enabled again.

Anyway, this is very specific to the media subsystem and does not affect the
current kernel. It will resolve itself automatically once the IEEE1394 code is
removed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
