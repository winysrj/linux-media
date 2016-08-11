Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42737
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbcHKQOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 12:14:12 -0400
Subject: Re: [PATCH 2/8] [media] v4l2-async: call registered_async after
 subdev registration
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
 <1454699398-8581-3-git-send-email-javier@osg.samsung.com>
 <20160811111042.GQ3182@valkosipuli.retiisi.org.uk>
 <20160811111817.GS3182@valkosipuli.retiisi.org.uk>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-ID: <7c4b87b3-38e9-6b4e-730e-d65b0d72dd1d@osg.samsung.com>
Date: Thu, 11 Aug 2016 12:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <20160811111817.GS3182@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

Thanks a lot for your feedback.

On 08/11/2016 07:18 AM, Sakari Ailus wrote:
> On Thu, Aug 11, 2016 at 02:10:43PM +0300, Sakari Ailus wrote:

[snip]

>>>  
>>> +	ret = v4l2_subdev_call(sd, core, registered_async);
>>> +	if (ret < 0) {
>>> +		if (notifier->unbind)
>>> +			notifier->unbind(notifier, sd, asd);
>>> +		return ret;
>>> +	}
>>> +
>>>  	if (list_empty(&notifier->waiting) && notifier->complete)
>>>  		return notifier->complete(notifier);
>>
>> I noticed this just now but what do you need this and the next patch for?
>>
>> We already have a callback for the same purpose: it's
>> v4l2_subdev_ops.internal_ops.registered(). And there's similar
>> unregistered() callback as well.
>>

Oh, I missed we already had those calls. When adding the connector
support, I looked at struct v4l2_subdev_core_ops and didn't find a
callback that fit but didn't notice we already had a .registered()
in struct struct v4l2_subdev_internal_ops. Sorry about that...

>> Could you use these callbacks instead?

Yes, those can be used indeed. I'll post patches using that instead
and removing the .registered_async callback since as you said isn't
really needed.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
