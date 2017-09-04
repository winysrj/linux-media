Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42809 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753885AbdIDRir (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 13:38:47 -0400
Subject: Re: [PATCH v7 15/18] v4l2-fwnode: Add convenience function for
 parsing generic references
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-16-sakari.ailus@linux.intel.com>
 <0bb75f81-cc81-a4bf-f2af-41862c1d777a@xs4all.nl>
 <20170904163400.z26qmxuejhgdcmrw@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3921fde8-6192-87d7-9c5d-5dd2035a9565@xs4all.nl>
Date: Mon, 4 Sep 2017 19:38:42 +0200
MIME-Version: 1.0
In-Reply-To: <20170904163400.z26qmxuejhgdcmrw@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2017 06:34 PM, Sakari Ailus wrote:
>>>  MODULE_LICENSE("GPL");
>>>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>>>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
>>> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
>>> index 6d125f26ec84..52f528162818 100644
>>> --- a/include/media/v4l2-fwnode.h
>>> +++ b/include/media/v4l2-fwnode.h
>>> @@ -254,4 +254,32 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>>>  			      struct v4l2_fwnode_endpoint *vep,
>>>  			      struct v4l2_async_subdev *asd));
>>>  
>>> +/**
>>> + * v4l2_fwnode_reference_parse - parse references for async sub-devices
>>> + * @dev: the device node the properties of which are parsed for references
>>
>> the device node whose properties are...
> 
> Both mean the same thing.

Yes, but I think your sentence is a bit awkward. Just my opinion, though.

Regards,

	Hans
