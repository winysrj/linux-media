Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41592 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750998AbdBTW0y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 17:26:54 -0500
Date: Tue, 21 Feb 2017 00:26:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170220222618.GZ16975@valkosipuli.retiisi.org.uk>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170214224750.GE11317@amd>
 <f3ba8ca3-0931-604e-d84c-43c0e43857db@linux.intel.com>
 <20170215080909.GA3693@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170215080909.GA3693@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, Feb 15, 2017 at 09:09:09AM +0100, Pavel Machek wrote:
> Hi!
> 
> > On 02/15/17 00:47, Pavel Machek wrote:
> > > On Tue 2017-02-14 14:20:22, Sakari Ailus wrote:
> > >> Add a V4L2 control class for voice coil lens driver devices. These are
> > >> simple devices that are used to move a camera lens from its resting
> > >> position.
> > >>
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > 
> > > Looks good to me.
> > > 
> > > I wonder... should we somehow expose the range of diopters to
> > > userspace? I believe userland camera application will need that
> > > information.
> > 
> > It'd certainly be useful to be able to provide more information.
> > 
> > The question is: where to store it, and how? It depends on the voice
> > coil, the spring constant, the lens and the distance of the lens from
> > the sensor --- at least. Probably the sensor size as well.
> > 
> > On voice coil lenses it is also somewhat inexact.
> 
> I was thinking read-only attribute providing minimum and maximum
> diopters in case there's linear relationship as on N900.
> 
> +#define V4L2_CID_VOICE_DIOPTERS_AT_REST (V4L2_CID_VOICE_COIL_CLASS_BASE + 2)
> +#define V4L2_CID_VOICE_DIOPTERS_AT_MAX (V4L2_CID_VOICE_COIL_CLASS_BASE + 3)

Where do you store that information and how? Should the user be also told
how the applied current affects the value?

I also wonder whether that's the best way to provide the information to the
user --- we have things such as devices that are a part of a camera module
and telling the user on which side of the device the camera is located.

We've been planning to have a property API for this to provide the user with
a tree of key-value pairs, with details unsettled as of yet, so it's
certainly nothing that could be used yet.

Do you have a user application that could make use of such information?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
