Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51546 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751050AbdJ0IaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 04:30:04 -0400
Date: Fri, 27 Oct 2017 11:30:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 17/32] v4l: async: Prepare for async sub-device
 notifiers
Message-ID: <20171027083001.4zaeaewb2zyqatu6@valkosipuli.retiisi.org.uk>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-18-sakari.ailus@linux.intel.com>
 <20171026221051.GK2297@bigcity.dyn.berto.se>
 <20171027081002.GL2297@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171027081002.GL2297@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 27, 2017 at 10:10:02AM +0200, Niklas Söderlund wrote:
> > > @@ -151,6 +152,31 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> > >  	return 0;
> > >  }
> > >  
> > > +/* Test all async sub-devices in a notifier for a match. */
> > > +static int v4l2_async_notifier_try_all_subdevs(
> > > +	struct v4l2_async_notifier *notifier)
> > > +{
> > > +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> > > +	struct v4l2_subdev *sd, *tmp;
> > > +
> > > +	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > > +		struct v4l2_async_subdev *asd;
> > > +		int ret;
> > > +
> > > +		asd = v4l2_async_find_match(notifier, sd);
> > > +		if (!asd)
> > > +			continue;
> > > +
> > > +		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
> > > +		if (ret < 0) {
> > > +			mutex_unlock(&list_lock);
> 
> The mutex should not be unlocked here, as the caller will also unlock it 
> if ret is none zero. You fix this in 18/32 so the end result is OK but I 
> think its better to fix this in this patch.

Good catch. I've sent v16.1 of these and forgot the change log. There are
no other changes than fixing this, i.e. the end result is the same.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
