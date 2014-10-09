Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1105 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJIMrh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 08:47:37 -0400
Message-ID: <543683B6.1040104@xs4all.nl>
Date: Thu, 09 Oct 2014 14:46:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com
Subject: Re: [RFC PATCH 00/11] Add configuration store support
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <20141009115542.GZ2939@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141009115542.GZ2939@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/14 13:55, Sakari Ailus wrote:
> Hi Hans,
> 
> Thank you for the set, and my apologies for taking a look only now.
> 
> On Sun, Sep 21, 2014 at 04:48:18PM +0200, Hans Verkuil wrote:
>> This patch series adds support for configuration stores to the control
>> framework. This allows you to store control values for a particular
>> configuration (up to VIDEO_MAX_FRAME configuration stores are currently
>> supported). When you queue a new buffer you can supply the store ID and
>> the driver will apply all controls for that configuration store.
>>
>> When you set a new value for a configuration store then you can choose
>> whether this is 'fire and forget', i.e. after the driver applies the
>> control value for that store it won't be applied again until a new value
>> is set. Or you can set the value every time that configuration store is
>> applied.
> 
> This does work for video device nodes but not for sub-device nodes which
> have no buffer queues.

The subdevices may not have buffer queues, but the high-level media driver
will know when a subdevice has to apply a specific configuration store and
can tell the subdev to do so. That's the way I expect it to work.

> Also if you think of using just a value from the
> closest video buffer queue, that doesn't work either since there could be
> more than one of those.

Good point. One solution might be to allow for a larger range of config
store IDs (i.e., more than just 1-32, where 32 is the current maximum number
of buffers). That way different buffer queues can use unique config store
IDs. This does make the internal data structures a bit more complex, but it's
not a big deal.

> 
> Most of the time the controls that need to be applied on per-frame basis are
> present in embedded systems with complex media pipelines where most of the
> controls are present on sub-device nodes.
> 
> In other words this approach alone is not sufficient to bind control related
> configurations to individual frames. For preparing and applying
> configurations it is applicable.
> 
> Thinking about the Android camera API v3, controls are a part of the picture
> only: capture requests contain buffer sets as well. I think the concept
> makes sense also outside Android. Let's discuss this further at the Media
> summit.

Let's do that.

Regards,

	Hans

