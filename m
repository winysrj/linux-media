Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35258 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729387AbeK0UQb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 15:16:31 -0500
Date: Tue, 27 Nov 2018 11:19:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] media: imx274: don't declare events, they are not
 implemented
Message-ID: <20181127091914.zai73kgmam7oi33m@valkosipuli.retiisi.org.uk>
References: <20181127083445.27737-1-luca@lucaceresoli.net>
 <20181127083859.zljff4wk4hikel56@paasikivi.fi.intel.com>
 <dcd7ded2-7876-c017-0d8c-1f3d159e5d2f@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcd7ded2-7876-c017-0d8c-1f3d159e5d2f@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 10:09:08AM +0100, Luca Ceresoli wrote:
> Hi Sakari,
> 
> On 27/11/18 09:38, Sakari Ailus wrote:
> > Hi Luca,
> > 
> > On Tue, Nov 27, 2018 at 09:34:43AM +0100, Luca Ceresoli wrote:
> >> The V4L2_SUBDEV_FL_HAS_EVENTS flag should not be set, event are just
> >> not implemented.
> >>
> >> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> > 
> > The driver supports controls, and so control events can be subscribed and
> > received by the user. Therefore I don't see a reason to remove the flag.

I further missed the driver does not set the event (un)subscription
callbacks; the event support is actually not functional as a result. :-\

It's trivial to do that, see e.g. the imx319 driver.

> 
> Thanks, good to know.
> 
> Would it be worth adding a note where V4L2_SUBDEV_FL_HAS_EVENTS is
> #defined, to make this clear?

Could you send a patch? A few words should be enough, no need for a too
elaborate description I guess.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
