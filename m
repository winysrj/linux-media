Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1752 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab1LNOxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 09:53:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
Date: Wed, 14 Dec 2011 15:53:43 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	m.szyprowski@samsung.com, jonghun.han@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com> <201112131318.54709.hverkuil@xs4all.nl> <4EE8A5D6.4030408@samsung.com>
In-Reply-To: <4EE8A5D6.4030408@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112141553.43169.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, December 14, 2011 14:34:14 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 12/13/2011 01:18 PM, Hans Verkuil wrote:
> >> are you going to carry on with the control range update patches ?
> >> I'd like to push the alpha colour control for v3.3 but it depends
> >> on the controls framework updates now.
> > 
> > Good question. I am not sure whether this is something we actually want. It 
> > would make applications much harder to write if the range of a control can 
> > suddenly change.
> > 
> > On the other hand, it might be a good solution for a harder problem which is 
> > as yet unsolved: if you have multiple inputs, and each input has a different 
> > set of controls (e.g. one input is a SDTV receiver, the other is a HDTV 
> > receiver), then you can have the situation where e.g. the contrast control is 
> > present for both inputs, but with a different range. Switching inputs would 
> > then generate a control event telling the app that the range changed.
> > 
> > But this may still be overkill...
> 
> Hmm, it doesn't look like an overkill to me. I'm certain there will be use
> cases where control range update is needed. Maybe we could specify in
> the API in what circumstances the control range update is allowed for drivers.
> So not all applications need to handle the related events.
> 
> Nevertheless I won't be pushing on this, not to mess around in the whole
> API because of some embedded systems requirements.
> So I'm going to update the range for alpha control manually in the driver
> for the time being.

I think I want to wait for other use cases before making these changes.
If it is clear that multiple drivers need this, then we can always add the
support (especially since all the hard work is already done in my patch).

Regards,

	Hans

> 
> > 
> > In other words, I don't know. Not helpful, I agree.
> 
> That was helpful anyway :-) Thanks.
> 
> 
