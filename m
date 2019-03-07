Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2E7C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B39F20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:05:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="CFpk4UjS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfCGJFs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 04:05:48 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:58172 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCGJFs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 04:05:48 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D38D1242;
        Thu,  7 Mar 2019 10:05:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551949545;
        bh=bETkKpfIxVDd05sLCFCWM320QSLHS3fSCZtwgFUaWHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CFpk4UjSs5+W+6vC9xh6F7wWuSKMyhwWmwIHAfFB2jNKdxLAONhJm4QJt8fS5Xrh6
         Y+NKaAgfycV6uIs46ZG0DnH/YwrtCCgNLTQDsk9LPOBmUZDbfs57Izo+aHNZWR4bUc
         BqG/obUsn4ZP2e4sPbFtiq2v2wA/KVd20pWyr1c4=
Date:   Thu, 7 Mar 2019 11:05:38 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCHv2 6/9] v4l2-subdev: add release() internal op
Message-ID: <20190307090538.GE4804@pendragon.ideasonboard.com>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-7-hverkuil-cisco@xs4all.nl>
 <20190305194608.GG14928@pendragon.ideasonboard.com>
 <2e867e73-f7c6-2beb-67d1-b1caa88e391d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2e867e73-f7c6-2beb-67d1-b1caa88e391d@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Thu, Mar 07, 2019 at 09:54:53AM +0100, Hans Verkuil wrote:
> On 3/5/19 8:46 PM, Laurent Pinchart wrote:
> > On Tue, Mar 05, 2019 at 10:58:44AM +0100, hverkuil-cisco@xs4all.nl wrote:
> >> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>
> >> If the subdevice created a device node, then the v4l2_subdev cannot
> >> be freed until the last user of the device node closes it.
> >>
> >> This means that we need a release() callback in v4l2_subdev_internal_ops
> >> that is called from the video_device release function so the subdevice
> >> driver can postpone freeing memory until the that callback is called.
> >>
> >> If no video device node was created then the release callback can
> >> be called immediately when the subdev is unregistered.
> >>
> >> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-device.c | 19 ++++++++++++++-----
> >>  include/media/v4l2-subdev.h           |  3 +++
> >>  2 files changed, 17 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> >> index e0ddb9a52bd1..7cca0de1b730 100644
> >> --- a/drivers/media/v4l2-core/v4l2-device.c
> >> +++ b/drivers/media/v4l2-core/v4l2-device.c
> >> @@ -216,10 +216,18 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> >>  }
> >>  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
> >>  
> >> +static void v4l2_subdev_release(struct v4l2_subdev *sd)
> >> +{
> >> +	struct module *owner = !sd->owner_v4l2_dev ? sd->owner : NULL;
> >> +
> >> +	if (sd->internal_ops && sd->internal_ops->release)
> >> +		sd->internal_ops->release(sd);
> >> +	module_put(owner);
> >> +}
> >> +
> >>  static void v4l2_device_release_subdev_node(struct video_device *vdev)
> >>  {
> >> -	struct v4l2_subdev *sd = video_get_drvdata(vdev);
> >> -	sd->devnode = NULL;
> >> +	v4l2_subdev_release(video_get_drvdata(vdev));
> >>  	kfree(vdev);
> >>  }
> >>  
> >> @@ -318,8 +326,9 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
> >>  		media_device_unregister_entity(&sd->entity);
> >>  	}
> >>  #endif
> >> -	video_unregister_device(sd->devnode);
> >> -	if (!sd->owner_v4l2_dev)
> >> -		module_put(sd->owner);
> >> +	if (sd->devnode)
> >> +		video_unregister_device(sd->devnode);
> >> +	else
> >> +		v4l2_subdev_release(sd);
> >>  }
> > 
> > Don't we also need to handle the error path in
> > v4l2_device_register_subdev_nodes() ?
> 
> No, in the error path of v4l2_device_register_subdev_nodes() the registered
> video devices are simply unregistered, and so they will do the clean up
> via v4l2_device_release_subdev_node(). Nothing changes there.

You're right, my bad. In that case,

> >>  EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
> >> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >> index 349e1c18cf48..2f2d1c8947e6 100644
> >> --- a/include/media/v4l2-subdev.h
> >> +++ b/include/media/v4l2-subdev.h
> >> @@ -757,6 +757,8 @@ struct v4l2_subdev_ops {
> >>   *
> >>   * @close: called when the subdev device node is closed.
> >>   *
> >> + * @release: called when the subdev device node is released.
> >> + *
> > 
> > I think this should be expanded a bit. First of all, we should mention
> > what happens when the subdev doesn't have a device node, and then we
> > should also explain what drivers are supposed to do in this operation.
> 
> I'll extend this a bit.

With the documentation expanded,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> > At what point do you think we should add a WARN_ON(!sd->internal_ops ||
> > !sd->internal_ops->release) ?
> 
> I wondered about that myself. I think the first step is to make the
> regression test for the virtual drivers work flawlessly (i.e. no more
> compliance errors/warnings/kernel oopses/warnings), then I want to extend
> the regression test so you can run it for other drivers than the virtual
> drivers.
> 
> After that I plan on asking the maintainers of the drivers that use the MC
> to run the test and see if they hit this issue (they likely will). Once
> enough of those drivers have been fixed we can add this warning.
> 
> That was the long answer, the short answer is: hopefully by the end of this year :-)

:-) The plan sounds good to me.

> > I expect we'll need to refcount the subdev structure, with the
> > video_device only having one of the multiple references to the subdev,
> > but that can be implemented later. Overall this moves us in the right
> > direction, thank you for your work.
> 
> Yeah, I need to do more testing for this. One test that isn't in the regression
> test is unbinding subdevs, but not the main bridge device.

That will be another big can of worms :-S

Another issue that needs to be tackled is the race between userspace and
unbind. Once the unbind function returns access to the device isn't
allowed anymore, so we need to ensure that we block unbind until all
userspace calls return, and that we block new ones once unbind has
started (I believe we've discussed this face-to-face with Sakari a
couple of years ago). Do you plan to work on that too ? I think it's
more important than the subdev partial unbind, as it can really lead to
crashes when hot-pluggable devices are removed.

> If refcounting is really necessary, then such a test should uncover
> this. It's getting quite difficult to understand all the dependencies.
> 
> >>   * .. note::
> >>   *	Never call this from drivers, only the v4l2 framework can call
> >>   *	these ops.
> >> @@ -766,6 +768,7 @@ struct v4l2_subdev_internal_ops {
> >>  	void (*unregistered)(struct v4l2_subdev *sd);
> >>  	int (*open)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
> >>  	int (*close)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
> >> +	void (*release)(struct v4l2_subdev *sd);
> >>  };
> >>  
> >>  #define V4L2_SUBDEV_NAME_SIZE 32

-- 
Regards,

Laurent Pinchart
