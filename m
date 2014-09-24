Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIXJRg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 05:17:36 -0400
Message-ID: <54228C39.7080207@linux.intel.com>
Date: Wed, 24 Sep 2014 12:17:45 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Set entity->links NULL in cleanup
References: <1401197269-18773-1-git-send-email-sakari.ailus@linux.intel.com> <3533594.Ac4LJj8QGP@avalon> <20140717115349.GN16460@valkosipuli.retiisi.org.uk> <4899501.NLaQ1XGmm5@avalon>
In-Reply-To: <4899501.NLaQ1XGmm5@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Oops. this got buried in my inbox...

Laurent Pinchart wrote:
> On Thursday 17 July 2014 14:53:49 Sakari Ailus wrote:
>> On Thu, Jul 17, 2014 at 01:43:09PM +0200, Laurent Pinchart wrote:
>>> On Tuesday 27 May 2014 16:27:49 Sakari Ailus wrote:
>>>> Calling media_entity_cleanup() on a cleaned-up entity would result into
>>>> double free of the entity->links pointer and likely memory corruption as
>>>> well.
>>>
>>> My first question is, why would anyone do that ? :-)
>>
>> Because it makes error handling easier. Many cleanup functions work this
>> way, but not media_entity_cleanup().
>
> Do the cleanup functions support being called multiple times, or do they just
> support being called on memory that has been zeroed and not further
> initialized ? The media_entity_cleanup() function supports the latter.

I'd hope they wouldn't be called multiple times, or on memory that's not 
been zeroed, but in that case it's better to behave rather than corrupt 
system memory. That could be an indication of other problems, too, so 
one could consider adding WARN_ON() to this as well. What do you think?

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
