Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1626 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1GZOT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 10:19:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Some comments on the new autocluster patches
Date: Tue, 26 Jul 2011 16:19:47 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E0DE283.2030107@redhat.com> <201107261126.22285.hverkuil@xs4all.nl> <4E2EC67E.6010300@redhat.com>
In-Reply-To: <4E2EC67E.6010300@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107261619.47827.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, July 26, 2011 15:51:58 Hans de Goede wrote:

<snip>

> > OK, so we have two scenarios:
> >
> > 1) There is a manual setting which is constant until explicitly changed, when e.g.
> > gain switches from auto mode to manual mode then the actual used gain is reset to
> > this manual setting.
> >
> > In this case the e.g. gain control is *not* marked volatile, but just inactive.
> > If the hardware can return the gain as set by the autogain circuit, then that has
> > to be exported as a separate read-only control (e.g. 'Current Gain').
> >
> >
> > 2) There is a single gain setting / register, which is active when the control is in
> > manual mode and inactive and volatile when in auto mode. When auto mode gets switched
> > off, the gain stays at the last value set by auto mode.
> >
> > This scenario is only possible, of course, if you can obtain the gain value as set
> > by the autogain circuitry.
> >
> 
> I fully agree with the above, +1
> 
> > An open question is whether writing to an inactive and volatile control should return
> > an error or not.
> 
> I would prefer an error return.

I am worried about backwards compatibility, though. Right now inactive controls
can be written safely. Suddenly you add the volatile flag and doing the same thing
causes an error.

Also, a program that saves control values will have to skip any control that:

1) Is read or write only
2) Is inactive and volatile

The first is obvious, but the second not so much.

Another reason for not returning an error is that it makes v4l2-ctrls.c more complex: if
autogain is on and I call VIDIOC_S_EXT_CTRLS to set autogain to off and gain to a new
manual value, then it is quite difficult to detect that in this case setting gain is OK
(since autogain is turned off at the same time).

The more I think about it, the more I think this should just be allowed. The value
disappears into a black hole, but at least it won't break any apps.

Regards,

	Hans

> 
> > Webcams should follow scenario 2 (if possible).
> >
> > It is less obvious what to recommend for video capture devices. I'd leave it up to
> > the driver for now.
> 
> Sounds good to me.
> 
> Regards,
> 
> Hans
> 
