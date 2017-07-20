Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43922 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965372AbdGTXxX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 19:53:23 -0400
Subject: Re: [RFC 11/19] v4l2-async: Register sub-devices before calling bound
 callback
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <20170718190401.14797-12-sakari.ailus@linux.intel.com>
 <03f4a632-30b8-bdc8-2b03-fa7c3eb811a1@xs4all.nl>
 <20170720160954.47rbdwpxx6d4ezvq@valkosipuli.retiisi.org.uk>
 <84bdb8a9-389b-1fe9-f050-4d4452f5aebd@xs4all.nl>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e0c00e6c-0457-305e-cd20-27478131cad0@ideasonboard.com>
Date: Fri, 21 Jul 2017 00:53:18 +0100
MIME-Version: 1.0
In-Reply-To: <84bdb8a9-389b-1fe9-f050-4d4452f5aebd@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 20/07/17 17:23, Hans Verkuil wrote:
> On 20/07/17 18:09, Sakari Ailus wrote:
>> Hi Hans,
>>
>> On Wed, Jul 19, 2017 at 01:24:54PM +0200, Hans Verkuil wrote:
>>> On 18/07/17 21:03, Sakari Ailus wrote:
>>>> The async notifier supports three callbacks to the notifier: bound, unbound
>>>> and complete. The complete callback has been traditionally used for
>>>> creating the sub-device nodes.
>>>>
>>>> This approach has an inherent weakness: if registration of a single
>>>> sub-device fails for whatever reason, it renders the entire media device
>>>> unusable even if only that piece of hardware is not working. This is a
>>>> problem in particular in systems with multiple independent image pipelines
>>>> on a single device. We have had such devices (e.g. omap3isp) supported for
>>>> a number of years and the problem is growing more pressing as time passes
>>>> so there is an incentive to resolve this.
>>>
>>> I don't think this is a good reason. If one of the subdevices fail, then your
>>> hardware is messed up and there is no point in continuing.
>>
>> That's entirely untrue in general case.

Adding my 2 cents ... because I'm hitting this ... right now.

>>
>> If you have e.g. a mobile phone with a single camera, yes, you're right.
>> But most mobile phones have two cameras these days. Embedded systems may
>> have many, think of automotive use cases: you could have five or ten
>> cameras there.
I have a MAX9286 which has 4 camera subdevices connected.

Right now, if *ONE* fails - they all fail. - This is very much undesirable
behaviour.

In this instance, when one fails (perhaps I have not connected one camera) then
the remaining camera subdevices all probe successfully, but the complete
callback is never called. Therefore the rest of my pipeline is dead, - But that
could now mean my reversing camera is not working because my wing mirror camera
was 'knocked' off... :-(


> These are all very recent developments. Today userspace can safely assume
> that either everything would be up and running, or nothing at all.

This is a strong point, and I'm struggling to decide if I agree or not :D

There are so many use cases, it's hard to make one statement fit all.

For example - currently - an analogue input source might not be connected - but
userspace may not know that, and would instead capture a black screen.

Maybe that doesn't even match ... I'm tired ;)


>> It is not feasible to prevent the entire system from working if a single
>> component is at fault --- this is really any component such as a lens
>> controller.
> 
> All I am saying is that there should be a way to indicate that you accept
> that parts are faulty, and that you (i.e. userspace) are able to detect
> and handle that.
>
> You can't just change the current behavior and expect existing applications
> to work. E.g. says a sensor failed. Today the application might detect that
> the video node didn't come up, so something is seriously wrong with the hardware
> and it shows a message on the display. If this would change and the video node
> *would* come up, even though there is no sensor the behavior of the application
> would almost certainly change unexpectedly.
> 
> How to select which behavior you want isn't easy. The only thing I can come up
> with is a module option. Not very elegant, unfortunately. But it doesn't
> belong in the DT, and when userspace gets involved it is already too late.

Yes, this sounds nasty - but 3 out of 4 working cameras being disabled / not
coming up because one failed sounds worse to me currently (I would say that ...
my cameras didn't come up) ... :-(

<thinking cap on ... going to bed>

--
Kieran

> Regards,
> 
> 	Hans
> 
