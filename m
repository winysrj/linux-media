Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33396 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754018AbdJIOS0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 10:18:26 -0400
Date: Mon, 9 Oct 2017 17:18:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v15 01/32] v4l: async: Remove re-probing support
Message-ID: <20171009141823.zu6m6ir2z7id7px3@valkosipuli.retiisi.org.uk>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-2-sakari.ailus@linux.intel.com>
 <20171009082239.189b4475@vento.lan>
 <20171009140646.vqftgwkttgn33m2t@valkosipuli.retiisi.org.uk>
 <67bcf879-f8dd-094e-47ba-3be977da02b2@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67bcf879-f8dd-094e-47ba-3be977da02b2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Oct 09, 2017 at 04:08:47PM +0200, Hans Verkuil wrote:
> On 09/10/17 16:06, Sakari Ailus wrote:
> > Hi Mauro,
> > 
> > On Mon, Oct 09, 2017 at 08:22:39AM -0300, Mauro Carvalho Chehab wrote:
> >> Em Thu,  5 Oct 2017 00:50:20 +0300
> >> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >>
> >>> Remove V4L2 async re-probing support. The re-probing support has been
> >>> there to support cases where the sub-devices require resources provided by
> >>> the main driver's hardware to function, such as clocks.
> >>>
> >>> Reprobing has allowed unbinding and again binding the main driver without
> >>> explicilty unbinding the sub-device drivers. This is certainly not a
> >>> common need, and the responsibility will be the user's going forward.
> >>>
> >>> An alternative could have been to introduce notifier specific locks.
> >>> Considering the complexity of the re-probing and that it isn't really a
> >>> solution to a problem but a workaround, remove re-probing instead.
> >>
> >> If the re-probing isn't using anywhere, that sounds a nice cleanup.
> >> Did you check if this won't break any driver (like soc_camera)?
> > 
> > That was discussed earlier in the review; Laurent asked the same question.
> > 
> > Re-probing never was a proper solution to any problem; it was just a hack
> > to avoid unbinding the sensor if the bridge driver was unbound, no more: it
> > can't be generalised to support more complex use cases. Mind you, this is
> > on devices that aren't actually removable.
> > 
> > I've briefly discussed this with Laurent; the proper solution would need to
> > be implemented in the clock framework instead. There, the existing clocks
> > obtained by drivers could be re-activated when the driver for them comes
> > back.
> > 
> > My proposal is that if there's real a need to address this, then it could
> > be solved in the clock framework.
> 
> Can you add this information to the commit log?
> 
> I think that would be very helpful in the future.

Sure, how about this at the end of the current commit message:

If there is a need to support removing the clock provider in the future,
this should be implemented in the clock framework instead, not in V4L2.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
