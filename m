Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaJIIVK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Oct 2014 04:21:10 -0400
Message-ID: <54364566.9030102@redhat.com>
Date: Thu, 09 Oct 2014 10:20:54 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/1] Add a libv4l plugin for Exynos4 camera
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com> <1412757980-23570-2-git-send-email-j.anaszewski@samsung.com> <54353124.1060704@redhat.com> <54353AA3.3040506@samsung.com>
In-Reply-To: <54353AA3.3040506@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/08/2014 03:22 PM, Jacek Anaszewski wrote:
> Hi Hans,
> 
> On 10/08/2014 02:42 PM, Hans de Goede wrote:

<snip>

>>> +    }
>>> +
>>> +    /* refresh device topology data after linking */
>>> +    release_entities(mdev);
>>> +
>>> +    ret = get_device_topology(mdev);
>>> +
>>> +    /* close media device fd as it won't be longer required */
>>> +    close(mdev->media_fd);
>>> +
>>> +    if (ret < 0)
>>> +        goto err_get_dev_topology;
>>> +
>>> +    /* discover a pipeline for the capture device */
>>> +    ret = discover_pipeline_by_fd(mdev, fd);
>>> +    if (ret < 0)
>>> +        goto err_discover_pipeline;
>>
>> There does not seem to be any code here to ensure that this plugin does
>> not bind to non exonys4 fimc devices. Please fix that.
> 
> There is. Please look above at the
> 
> "if (!capture_entity(media_entity_name))" condition above.

I already checked that, that just checks for the string "capture", which is
way too generic, please add a more narrow guard.

Regards,

Hans
