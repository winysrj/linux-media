Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1519 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3FJNgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 09:36:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC v3 2/3] media: added managed v4l2 control initialization
Date: Mon, 10 Jun 2013 15:36:09 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com> <20130606214107.GD3103@valkosipuli.retiisi.org.uk> <51B4C3ED.40006@gmail.com>
In-Reply-To: <51B4C3ED.40006@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101536.09629.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun June 9 2013 20:05:33 Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 06/06/2013 11:41 PM, Sakari Ailus wrote:
> ...
> >>>>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>>>> index ebb8e48..f47ccfa 100644
> >>>>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>>>> @@ -1421,6 +1421,38 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
> >>>>>>    }
> >>>>>>    EXPORT_SYMBOL(v4l2_ctrl_handler_free);
> >>>>>>
> >>>>>> +static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
> >>>>>> +{
> >>>>>> +	struct v4l2_ctrl_handler **hdl = res;
> >>>>>> +
> >>>>>> +	v4l2_ctrl_handler_free(*hdl);
> >>>>>
> >>>>> v4l2_ctrl_handler_free() acquires hdl->mutex which is independent of the
> >>>>> existence of hdl. By default hdl->lock is in the handler, but it may also be
> >>>>> elsewhere, e.g. in a driver-specific device struct such as struct
> >>>>> smiapp_sensor defined in drivers/media/i2c/smiapp/smiapp.h. I wonder if
> >>>>> anything guarantees that hdl->mutex still exists at the time the device is
> >>>>> removed.
> >>>>
> >>>> If it is a driver-managed lock, then the driver should also be responsible for
> >>>> that lock during the life-time of the control handler. I think that is a fair
> >>>> assumption.
> >>>
> >>> Agreed.
> >>>
> >>>>> I have to say I don't think it's neither meaningful to acquire that mutex in
> >>>>> v4l2_ctrl_handler_free(), though, since the whole going to be freed next
> >>>>> anyway: reference counting would be needed to prevent bad things from
> >>>>> happening, in case the drivers wouldn't take care of that.
> >>>>
> >>>> It's probably not meaningful today, but it might become meaningful in the
> >>>> future. And in any case, not taking the lock when manipulating internal
> >>>> lists is very unexpected even though it might work with today's use cases.
> >>>
> >>> I simply don't think it's meaningful to acquire a lock related to an
> >>> object when that object is being destroyed. If something else was
> >>> holding that lock, you should not have begun destroying that object in
> >>> the first place. This could be solved by reference counting the handler
> >>> which I don't think is needed.
> >>
> >> Right now the way controls are set up is very static, but in the future I
> >> expect to see more dynamical behavior (I'm thinking of FPGAs supporting
> >> partial reconfiguration). In cases like that it you do want to take the
> >> lock preventing others from making modifications while the handler is
> >> freed. I am well aware that much more work will have to be done if we want
> >> to support such scenarios, but it is one reason why I would like to keep
> >> the lock there.
> >
> > I'm ok with that.
> >
> > How about adding a note to the comment above devm_v4l2_ctrl_handler_init()
> > that the function cannot be used with drivers that wish to use their own
> > lock?
> 
> But wouldn't it be a false statement ? The driver can still control the
> cleanup sequence by properly ordering the initialization sequence. So as
> long as it is ensured the mutex is destroyed after the controls handler
> (IOW, the mutex is created before the controls handler using the devm_*
> API) everything should be fine, shouldn't it ?

It should indeed. I really don't see the problem here.

Regards,

	Hans
