Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39103 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934859AbdGTQXr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 12:23:47 -0400
Subject: Re: [RFC 11/19] v4l2-async: Register sub-devices before calling bound
 callback
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <20170718190401.14797-12-sakari.ailus@linux.intel.com>
 <03f4a632-30b8-bdc8-2b03-fa7c3eb811a1@xs4all.nl>
 <20170720160954.47rbdwpxx6d4ezvq@valkosipuli.retiisi.org.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <84bdb8a9-389b-1fe9-f050-4d4452f5aebd@xs4all.nl>
Date: Thu, 20 Jul 2017 18:23:38 +0200
MIME-Version: 1.0
In-Reply-To: <20170720160954.47rbdwpxx6d4ezvq@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/07/17 18:09, Sakari Ailus wrote:
> Hi Hans,
> 
> On Wed, Jul 19, 2017 at 01:24:54PM +0200, Hans Verkuil wrote:
>> On 18/07/17 21:03, Sakari Ailus wrote:
>>> The async notifier supports three callbacks to the notifier: bound, unbound
>>> and complete. The complete callback has been traditionally used for
>>> creating the sub-device nodes.
>>>
>>> This approach has an inherent weakness: if registration of a single
>>> sub-device fails for whatever reason, it renders the entire media device
>>> unusable even if only that piece of hardware is not working. This is a
>>> problem in particular in systems with multiple independent image pipelines
>>> on a single device. We have had such devices (e.g. omap3isp) supported for
>>> a number of years and the problem is growing more pressing as time passes
>>> so there is an incentive to resolve this.
>>
>> I don't think this is a good reason. If one of the subdevices fail, then your
>> hardware is messed up and there is no point in continuing.
> 
> That's entirely untrue in general case.
> 
> If you have e.g. a mobile phone with a single camera, yes, you're right.
> But most mobile phones have two cameras these days. Embedded systems may
> have many, think of automotive use cases: you could have five or ten
> cameras there.

These are all very recent developments. Today userspace can safely assume
that either everything would be up and running, or nothing at all.

> It is not feasible to prevent the entire system from working if a single
> component is at fault --- this is really any component such as a lens
> controller.

All I am saying is that there should be a way to indicate that you accept
that parts are faulty, and that you (i.e. userspace) are able to detect
and handle that.

You can't just change the current behavior and expect existing applications
to work. E.g. says a sensor failed. Today the application might detect that
the video node didn't come up, so something is seriously wrong with the hardware
and it shows a message on the display. If this would change and the video node
*would* come up, even though there is no sensor the behavior of the application
would almost certainly change unexpectedly.

How to select which behavior you want isn't easy. The only thing I can come up
with is a module option. Not very elegant, unfortunately. But it doesn't
belong in the DT, and when userspace gets involved it is already too late.

Regards,

	Hans
