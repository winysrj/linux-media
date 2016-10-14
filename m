Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34657 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751359AbcJNRas (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:30:48 -0400
Message-ID: <1476466227.11834.84.camel@pengutronix.de>
Subject: Re: [PATCH 02/22] [media] v4l2-async: allow subdevices to add
 further subdevices to the notifier waiting list
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ian Arkver <ian.arkver.dev@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Date: Fri, 14 Oct 2016 19:30:27 +0200
In-Reply-To: <01c2f0df-6485-9427-c25f-69ac447653d8@gmail.com>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-3-p.zabel@pengutronix.de>
         <20161007224321.GC9460@valkosipuli.retiisi.org.uk>
         <1476460116.11834.42.camel@pengutronix.de>
         <01c2f0df-6485-9427-c25f-69ac447653d8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 14.10.2016, 18:06 +0100 schrieb Ian Arkver:
> On 14/10/16 16:48, Philipp Zabel wrote:
> > Am Samstag, den 08.10.2016, 01:43 +0300 schrieb Sakari Ailus:
> > [...]
> > [...]
> >>> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> >>> index 8e2a236..e4e4b11 100644
> >>> --- a/include/media/v4l2-async.h
> >>> +++ b/include/media/v4l2-async.h
> >>> @@ -114,6 +114,18 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >>>   				 struct v4l2_async_notifier *notifier);
> >>>   
> >>>   /**
> >>> + * __v4l2_async_notifier_add_subdev - adds a subdevice to the notifier waitlist
> >>> + *
> >>> + * @v4l2_notifier: notifier the calling subdev is bound to
> >> s/v4l2_//
> > I'd be happy to, but why should the v4l2 prefix be removed?
> >
> > regards
> > Philipp
> I think Sakari is just pointing out that the comment doesn't match the 
> function argument name.

Ouch, that's very obvious now that I understand :)
Thank you for pointing this out.

regards
Philipp

