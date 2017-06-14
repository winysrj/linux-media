Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37170 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750728AbdFNLQq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 07:16:46 -0400
Date: Wed, 14 Jun 2017 14:16:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [patch, libv4l]: add sdlcam example for testing digital still
 camera functionality
Message-ID: <20170614111609.GQ12407@valkosipuli.retiisi.org.uk>
References: <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170521103315.GA10716@amd>
 <57f24742-f039-dce3-8c8f-65b114dfd7d2@xs4all.nl>
 <20170529073227.GA11921@amd>
 <9c846164-a7aa-eb2f-a78f-c14685ab248f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c846164-a7aa-eb2f-a78f-c14685ab248f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Pavel, Mauro, others,

On Mon, May 29, 2017 at 10:02:26AM +0200, Hans Verkuil wrote:
> On 05/29/2017 09:32 AM, Pavel Machek wrote:
> >On Mon 2017-05-29 08:13:22, Hans Verkuil wrote:
> >>Hi Pavel,
> >>
> >>On 05/21/2017 12:33 PM, Pavel Machek wrote:
> >>>Add simple SDL-based application for capturing photos. Manual
> >>>focus/gain/exposure can be set, flash can be controlled and
> >>>autofocus/autogain can be selected if camera supports that.
> >>>
> >>>It is already useful for testing autofocus/autogain improvements to
> >>>the libraries on Nokia N900.
> >>>
> >>>Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >>
> >>I think this is more suitable as a github project. To be honest, I feel that
> >>v4l-utils already contains too many random utilities, so I prefer not to add
> >>to that.
> >
> >>On the other hand, there is nothing against sharing this as on github as it
> >>certainly can be useful.
> >
> >Can I get you to reconsider that?
> >
> >Originally, I planed to keep the utility separate, but then I got
> >comments from Mauro ( https://lkml.org/lkml/2017/4/24/457 ) explaining
> >that hard sdl dependency is not acceptable etc, and how I should do
> >automake.
> >
> >So I had a lot of fun with automake integration, and generally doing
> >things right.
> >
> >So getting "we all ready have too many utilities" _now_ is quite an
> >unwelcome surprise.
> 
> Too many *random* utilities.
> 
> Utilities like v4l2-ctl are tied closely to the kernel and are updated whenever
> new APIs appear. But yet another viewer?
> 
> Mauro, I find that v4l-utils is a bit polluted with non-core utilities.
> IMHO it should only contain the core libv4l2, core utilities and driver-specific
> utilities. I wonder if we should make a media-utils-contrib for all the non-core
> stuff.
> 
> What is your opinion?

One of the purposes the v4l-utils repository has is that the distributions
get these programs included to their v4l-utils package as it's typically
called. It's debatable whether or how much it should contain device specific
or otherwise random projects, but having a common location for such programs
has clear benefits, too.

Based on how this one looks it is definitely not an end user application (I
hope I'm not miscategorising it) and as Pavel mentioned, it has been useful
in testing automatic focus / gain control on N900.

Just my 5 euro cents...

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
