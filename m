Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54271 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932408AbbFJV4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 17:56:00 -0400
Date: Thu, 11 Jun 2015 00:55:27 +0300
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
Message-ID: <20150610215527.GS5904@valkosipuli.retiisi.org.uk>
References: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com>
 <1433754145-12765-3-git-send-email-j.anaszewski@samsung.com>
 <CAK5ve-+FojRu1Ti3doEUJrf+QF-=Hb7ku_wZZEP2TEnS0PK=2g@mail.gmail.com>
 <CAK5ve-L6MJ0RfE+9Spp1YCu3MZAJSNnK8pBX0bc_G_4dL6812w@mail.gmail.com>
 <CAK5ve-+Yni0P2ZrS-boF9iRs2aqJGB73x87KZdmKckfe650N0Q@mail.gmail.com>
 <20150610213458.GQ5904@valkosipuli.retiisi.org.uk>
 <CAK5ve-+g6t-kpCpkD__-iANAaJTKgZ8W-4A11NAhMkj5Q0v07w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-+g6t-kpCpkD__-iANAaJTKgZ8W-4A11NAhMkj5Q0v07w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

On Wed, Jun 10, 2015 at 02:39:09PM -0700, Bryan Wu wrote:
> On Wed, Jun 10, 2015 at 2:34 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Bryan,
> >
> > On Wed, Jun 10, 2015 at 11:12:50AM -0700, Bryan Wu wrote:
> >> On Wed, Jun 10, 2015 at 11:01 AM, Bryan Wu <cooloney@gmail.com> wrote:
> >> > On Wed, Jun 10, 2015 at 10:57 AM, Bryan Wu <cooloney@gmail.com> wrote:
> >> >> On Mon, Jun 8, 2015 at 2:02 AM, Jacek Anaszewski
> >> >> <j.anaszewski@samsung.com> wrote:
> >> >>> This patch adds helper functions for registering/unregistering
> >> >>> LED Flash class devices as V4L2 sub-devices. The functions should
> >> >>> be called from the LED subsystem device driver. In case the
> >> >>> support for V4L2 Flash sub-devices is disabled in the kernel
> >> >>> config the functions' empty versions will be used.
> >> >>>
> >> >>
> >> >> Please go ahead with my Ack
> >> >>
> >> >> Acked-by: Bryan Wu <cooloney@gmail.com>
> >> >>
> >> >
> >> > I found the rest of LED patches depend on this one. What about merging
> >> > this through my tree?
> >> >
> >> > -Bryan
> >> >
> >> >
> >>
> >> Merged into my -devel branch and it won't be merged into 4.2.0 merge
> >> window but wait for one more cycle, since now it's quite late in 4.1.0
> >> cycle.
> >
> > Thanks!!
> >
> > I briefly discussed this with Mauro (cc'd), this should be fine indeed.
> >
> 
> I just got an email reporting a building error.
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
> devel
> head:   c7551d847a2336c299dff27b33ff48913fb11ee3
> commit: badd9dba592c55f7a7b1f2b59ecdf0345ca56f01 [23/26] media: Add
> registration helpers for V4L2 flash sub-devices
> config: i386-allyesconfig (attached as .config)
> reproduce:
>   git checkout badd9dba592c55f7a7b1f2b59ecdf0345ca56f01
>   # save the attached .config to linux build tree
>   make ARCH=i386
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/media/v4l2-core/v4l2-flash-led-class.c: In function
> 'v4l2_flash_init':
> 
> drivers/media/v4l2-core/v4l2-flash-led-class.c:646:4: error: 'struct
> v4l2_subdev' has no member named 'of_node'
> 
>      sd->of_node = of_node;
>        ^
>    drivers/media/v4l2-core/v4l2-flash-led-class.c:662:8: error:
> 'struct v4l2_subdev' has no member named 'of_node'
>      if (sd->of_node)
>            ^
>    drivers/media/v4l2-core/v4l2-flash-led-class.c:663:17: error:
> 'struct v4l2_subdev' has no member named 'of_node'
>       of_node_get(sd->of_node);
>                     ^
>    drivers/media/v4l2-core/v4l2-flash-led-class.c: In function
> 'v4l2_flash_release':
>    drivers/media/v4l2-core/v4l2-flash-led-class.c:696:8: error:
> 'struct v4l2_subdev' has no member named 'of_node'
>      if (sd->of_node)
>            ^
>    drivers/media/v4l2-core/v4l2-flash-led-class.c:697:17: error:
> 'struct v4l2_subdev' has no member named 'of_node'
>       of_node_put(sd->of_node);
>                     ^
> 
> vim +646 drivers/media/v4l2-core/v4l2-flash-led-class.c

Oh dear. I briefly forgot the dependency to the patch Jacek also referred
to:

<URL:http://www.spinics.net/lists/linux-media/msg90846.html>

That's v1.2 I just sent in order to address Laurent's concern. I'd like to
get an ack from him on that though, but he probably won't be able to give
one until tomorrow evening Finnish time.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
