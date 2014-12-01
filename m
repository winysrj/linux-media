Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21399 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaLAOVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 09:21:07 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFW00GVKQNWNKB0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Dec 2014 14:23:56 +0000 (GMT)
Message-id: <547C794C.1090105@samsung.com>
Date: Mon, 01 Dec 2014 15:21:00 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 05/11] mediactl: Add media device graph helpers
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-6-git-send-email-j.anaszewski@samsung.com>
 <20141128170655.GO8907@valkosipuli.retiisi.org.uk>
 <547C4FA3.30605@samsung.com> <547C5F4A.7050400@linux.intel.com>
In-reply-to: <547C5F4A.7050400@linux.intel.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/01/2014 01:30 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> Jacek Anaszewski wrote:
> ...
>>>> +int media_get_busy_pads_by_entity(struct media_device *media,
>>>> +                struct media_entity *entity,
>>>> +                unsigned int type,
>>>> +                struct media_pad **busy_pads,
>>>> +                int *num_busy_pads)
>>>
>>> Are you looking for enabled links that someone else would have
>>> configured
>>> here?
>>
>> The assumption is made here that there will be no concurrent users of
>> a media device and an entity will have no more than one link connected
>> to its sink pad. If this assumption is not valid than all the links
>> in the pipeline would have to be defined in the media config and
>> the pipeline would have to be only validated not discovered.
>> By pipeline validation I mean checking whether all config links are
>> enabled
>
> You do get an error from MEDIA_IOC_LINK_SETUP if enabling a link fails.

My intention here was to discuss the situation when there is more
than one active link connected to an entity sink pad(s).

There are two options:
a) more than one active link connected to the same sink pad
    (I don't know if this has been ever considered a valid arrangement)
b) more than one active link connected to separate sink pads
    if the same entity.

In both cases discovering a pipeline will require different approach
than in the recent patch set, where there are only configurable
links expected in the media config and those fixed aren't taken
into account. After the config links are set up, the pipeline
is discovered by walking from the sink entity upstream, until
the entity with no sink pads is encountered.

If more than one link is connected to the sink pad(s) of
an entity the situation becomes ambiguous.

Therefore I propose to define all the links for the pipeline
in the media config. The fixed links could be marked with
relevant flags. By validating the pipeline I meant checking
whether all links from the media configuration file are
active.

>>> I think we should have a more generic solution to that. This one still
>>> does
>>> not guard against concurrent user space processes that attempt to
>>> configure
>>> the media device.
>>> One possibility would be to add IOCTLs to grant and release exclusive
>>> write
>>> (i.e. change configuration) access to the device. Once streaming is
>>> started,
>>> exclusive access could be released by the user. I wonder what Laurent
>>> would
>>> think about that. I think this would be very robust --- one could
>>> start with
>>> resetting all the links one can, and then configure those that are
>>> needed;
>>> if this fails, then the pipeline is already used by someone else and
>>> streaming cannot taken place on it. No cleanup of the configuration is
>>> needed.
>>
>> This approach would preclude having more than one pipeline configured
>> in a media device.
>
> That's not true. You can *configure* a single pipeline at once, but once
> that one is streaming (or write access is allowed from other file
> handles again), you can configure another one that does no conflict with
> the first one.

OK, I missed that.

>>> But this is definitely out of scope of this patchset (also because
>>> this is
>>> for the user space).
>>
>> Taking into account that there are cases when it would be useful
>> to allow for having more than one active pipelines in a media device
>> I think that we would require changes in the media controller API.
>>
>> I would hide from the user a possibility of reconfiguring the links
>> one by one, but instead provide an ioctl which would accept
>> a definition of a whole pipeline to be linked. Something
>> similar to extended controls.
>> A user space process calling such an ioctl would take the ownership
>> of the all involved sub-devices, and their linkage couldn't be
>> reconfigured until released.
>
> That does not mean someone else could reconfigure the links before you
> attempt to start streaming.

Therefore this ioctl should lock media device until VIDIOC_STREAMON
on the configured pipeline. I am not sure about other implications and
feasibility of such a design though.

Best Regards,
Jacek Anaszewski
