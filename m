Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54150 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752015AbbFJVfB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 17:35:01 -0400
Date: Thu, 11 Jun 2015 00:34:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bryan Wu <cooloney@gmail.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, mchehab@osg.samsung.com
Subject: Re: [PATCH v10 2/8] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20150610213458.GQ5904@valkosipuli.retiisi.org.uk>
References: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com>
 <1433754145-12765-3-git-send-email-j.anaszewski@samsung.com>
 <CAK5ve-+FojRu1Ti3doEUJrf+QF-=Hb7ku_wZZEP2TEnS0PK=2g@mail.gmail.com>
 <CAK5ve-L6MJ0RfE+9Spp1YCu3MZAJSNnK8pBX0bc_G_4dL6812w@mail.gmail.com>
 <CAK5ve-+Yni0P2ZrS-boF9iRs2aqJGB73x87KZdmKckfe650N0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-+Yni0P2ZrS-boF9iRs2aqJGB73x87KZdmKckfe650N0Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

On Wed, Jun 10, 2015 at 11:12:50AM -0700, Bryan Wu wrote:
> On Wed, Jun 10, 2015 at 11:01 AM, Bryan Wu <cooloney@gmail.com> wrote:
> > On Wed, Jun 10, 2015 at 10:57 AM, Bryan Wu <cooloney@gmail.com> wrote:
> >> On Mon, Jun 8, 2015 at 2:02 AM, Jacek Anaszewski
> >> <j.anaszewski@samsung.com> wrote:
> >>> This patch adds helper functions for registering/unregistering
> >>> LED Flash class devices as V4L2 sub-devices. The functions should
> >>> be called from the LED subsystem device driver. In case the
> >>> support for V4L2 Flash sub-devices is disabled in the kernel
> >>> config the functions' empty versions will be used.
> >>>
> >>
> >> Please go ahead with my Ack
> >>
> >> Acked-by: Bryan Wu <cooloney@gmail.com>
> >>
> >
> > I found the rest of LED patches depend on this one. What about merging
> > this through my tree?
> >
> > -Bryan
> >
> >
> 
> Merged into my -devel branch and it won't be merged into 4.2.0 merge
> window but wait for one more cycle, since now it's quite late in 4.1.0
> cycle.

Thanks!!

I briefly discussed this with Mauro (cc'd), this should be fine indeed.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
