Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36938 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726430AbeI1SkE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 14:40:04 -0400
Date: Fri, 28 Sep 2018 15:16:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 02/17] media: v4l2: async: Allow searching for asd of
 any type
Message-ID: <20180928121631.6nobkbegwnfeerpb@valkosipuli.retiisi.org.uk>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-3-git-send-email-steve_longerbeam@mentor.com>
 <20180924140604.23e2b56f@coco.lan>
 <a8ea673c-a519-81e8-35b1-9d4a224dcbf5@mentor.com>
 <20180925192045.59c83e3d@coco.lan>
 <36fd43b2-695d-b990-bec2-c4d88ccb8e88@mentor.com>
 <20180926063335.3c3b863d@coco.lan>
 <20180926104038.tc3u7vzojumcthen@kekkonen.localdomain>
 <89ff305e-4b0a-b59d-bb4f-99e8e6cfde90@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89ff305e-4b0a-b59d-bb4f-99e8e6cfde90@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 26, 2018 at 10:49:18AM -0700, Steve Longerbeam wrote:
> Hi Mauro, Sakari,
> 
> 
> On 09/26/2018 03:40 AM, Sakari Ailus wrote:
> > Hi Mauro, Steve,
> > 
> > On Wed, Sep 26, 2018 at 06:33:35AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Tue, 25 Sep 2018 18:05:36 -0700
> > > Steve Longerbeam <steve_longerbeam@mentor.com> escreveu:
> > > 
> > > > On 09/25/2018 03:20 PM, Mauro Carvalho Chehab wrote:
> > > > > Em Tue, 25 Sep 2018 14:04:21 -0700
> > > > > Steve Longerbeam <steve_longerbeam@mentor.com> escreveu:
> > > > > > > > @@ -392,12 +406,11 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> > > > > > > >     		case V4L2_ASYNC_MATCH_CUSTOM:
> > > > > > > >     		case V4L2_ASYNC_MATCH_DEVNAME:
> > > > > > > >     		case V4L2_ASYNC_MATCH_I2C:
> > > > > > > > -			break;
> > > > > > > >     		case V4L2_ASYNC_MATCH_FWNODE:
> > > > > > > > -			if (v4l2_async_notifier_fwnode_has_async_subdev(
> > > > > > > > -				    notifier, asd->match.fwnode, i)) {
> > > > > > > > +			if (v4l2_async_notifier_has_async_subdev(
> > > > > > > > +				    notifier, asd, i)) {
> > > > > > > >     				dev_err(dev,
> > > > > > > > -					"fwnode has already been registered or in notifier's subdev list\n");
> > > > > > > > +					"asd has already been registered or in notifier's subdev list\n");
> > > > > > > Please, never use "asd" on messages printed to the user. While someone
> > > > > > > may understand it while reading the source code, for a poor use,
> > > > > > > "asd" is just a random sequence of 3 characters.
> > > > > > I will change the message to read:
> > > > > > 
> > > > > > "subdev descriptor already listed in this or other notifiers".
> > > > > Perfect!
> > > > But the error message is removed in the subsequent patch
> > > > "[PATCH 03/17] media: v4l2: async: Add v4l2_async_notifier_add_subdev".
> > > > 
> > > > I could bring it back as a dev_dbg() in v4l2_async_notifier_asd_valid(), but
> > > > this shouldn't be a dev_err() anymore since it is up to the media platform
> > > > to decide whether an already existing subdev descriptor is an error.
> > > Hmm... that's an interesting discussion... what cases do you think it
> > > would be fine to try to register twice an asd notifier?
> 
> It should be a fairly common case that a sub-device has multiple fwnode
> output ports. In that case it's possible multiple sub-devices downstream
> from it will each encounter it when parsing the fwnode graph, and attempt
> to add it to their notifiers asd_list multiple times. That isn't an error,
> any
> attempt to add it after the first add should be ignored.
> 
> imx-media is an example, there is a CSI-2 transmitter with four fwnode
> output ports for each CSI-2 virtual channel. Those channels each go to
> one of four Camera Sensor Interface in the imx6 IPU. So each CSI will
> encounter the CSI-2 transmitter when parsing its fwnode ports.
> 
> 
> > Only the error message is removed; this case is still considered an error.
> > I think it'd be better to keep this error message; it helps debugging.
> 
> Ok I will add it back, but it should be a dev_dbg().

Fine for me.

Could you address especially the author vs. SoB line difference in the set,
and re-post to the list, please?

I've pushed the latest set including my fwnode patches (which you can
ignore) to my linuxtv.org tree v4l2-fwnode branch; feel free to use these
as the basis. I've fixed a few conflicts in there in rebasing on current
media tree master.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
