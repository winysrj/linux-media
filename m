Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49475 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbcCVJ0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 05:26:09 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O4F000G4OVIDT50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2016 09:26:06 +0000 (GMT)
Message-id: <56F10FAD.9020808@samsung.com>
Date: Tue, 22 Mar 2016 10:26:05 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 01/15] mediactl: Introduce v4l2_subdev structure
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
 <1453133860-21571-2-git-send-email-j.anaszewski@samsung.com>
 <56BDD32D.5010105@linux.intel.com> <56C5D204.9040101@samsung.com>
 <20160320233903.GD11084@valkosipuli.retiisi.org.uk>
In-reply-to: <20160320233903.GD11084@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 03/21/2016 12:39 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Feb 18, 2016 at 03:15:32PM +0100, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> Thanks for the review.
>>
>> On 02/12/2016 01:42 PM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> Thanks for continuing this work! And my apologies for reviewing only
>>> now... please see the comments below.
>>>
>>> Jacek Anaszewski wrote:
>>>> Add struct v4l2_subdev - a representation of the v4l2 sub-device,
>>>> related to the media entity. Add field 'sd', the pointer to
>>>> the newly introduced structure, to the struct media_entity
>>>> and move 'fd' property from struct media entity to struct v4l2_subdev.
>>>> Avoid accessing sub-device file descriptor from libmediactl and
>>>> make the v4l2_subdev_open capable of creating the v4l2_subdev
>>>> if the 'sd' pointer is uninitialized.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>   utils/media-ctl/libmediactl.c   |    4 --
>>>>   utils/media-ctl/libv4l2subdev.c |   82 +++++++++++++++++++++++++++++++--------
>>>>   utils/media-ctl/mediactl-priv.h |    5 ++-
>>>>   utils/media-ctl/v4l2subdev.h    |   38 ++++++++++++++++++
>>>>   4 files changed, 107 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
>>>> index 4a82d24..7e98440 100644
>>>> --- a/utils/media-ctl/libmediactl.c
>>>> +++ b/utils/media-ctl/libmediactl.c
>>>> @@ -525,7 +525,6 @@ static int media_enum_entities(struct media_device *media)
>>>>
>>>>   		entity = &media->entities[media->entities_count];
>>>>   		memset(entity, 0, sizeof(*entity));
>>>> -		entity->fd = -1;
>>>>   		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
>>>>   		entity->media = media;
>>>>
>>>> @@ -719,8 +718,6 @@ void media_device_unref(struct media_device *media)
>>>>
>>>>   		free(entity->pads);
>>>>   		free(entity->links);
>>>> -		if (entity->fd != -1)
>>>> -			close(entity->fd);
>>>>   	}
>>>>
>>>>   	free(media->entities);
>>>> @@ -747,7 +744,6 @@ int media_device_add_entity(struct media_device *media,
>>>>   	entity = &media->entities[media->entities_count - 1];
>>>>   	memset(entity, 0, sizeof *entity);
>>>>
>>>> -	entity->fd = -1;
>>>>   	entity->media = media;
>>>>   	strncpy(entity->devname, devnode, sizeof entity->devname);
>>>>   	entity->devname[sizeof entity->devname - 1] = '\0';
>>>> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
>>>> index 33c1ee6..3977ce5 100644
>>>> --- a/utils/media-ctl/libv4l2subdev.c
>>>> +++ b/utils/media-ctl/libv4l2subdev.c
>>>> @@ -39,13 +39,61 @@
>>>>   #include "tools.h"
>>>>   #include "v4l2subdev.h"
>>>>
>>>> +int v4l2_subdev_create(struct media_entity *entity)
>>>> +{
>>>> +	if (entity->sd)
>>>> +		return 0;
>>>> +
>>>> +	entity->sd = calloc(1, sizeof(*entity->sd));
>>>> +	if (entity->sd == NULL)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	entity->sd->fd = -1;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +int v4l2_subdev_create_with_fd(struct media_entity *entity, int fd)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	if (entity->sd)
>>>> +		return -EEXIST;
>>>> +
>>>> +	ret = v4l2_subdev_create(entity);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	entity->sd->fd = fd;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +void v4l2_subdev_release(struct media_entity *entity, bool close_fd)
>>>> +{
>>>> +	if (entity->sd == NULL)
>>>> +		return;
>>>> +
>>>> +	if (close_fd)
>>>> +		v4l2_subdev_close(entity);
>>>> +
>>>> +	free(entity->sd->v4l2_control_redir);
>>>> +	free(entity->sd);
>>>> +}
>>>> +
>>>>   int v4l2_subdev_open(struct media_entity *entity)
>>>>   {
>>>> -	if (entity->fd != -1)
>>>> +	int ret;
>>>> +
>>>> +	ret = v4l2_subdev_create(entity);
>>>
>>> The current users of v4l2_subdev_open() in libv4l2subdev do not
>>> explicitly close the sub-devices they open; thus calling
>>> v4l2_subdev_create() here creates a memory leak.
>>
>> Currently in my use cases there is no memory leak since I assumed
>> that the one who instantiates struct media_device should take
>> care of releasing it properly. I added v4l2_subdev_open_pipeline()
>> and v4l2_subdev_release_pipeline() API that is called on plugin
>> init and close respectively.
>
> I'm referring to the use of the libv4l2subdev API as it's documented; the
> media-ctl test program which also serves as a good example on the API.
>
> Any sub-device IOCTL wrapper function will call v4l2_subdev_open() which
> stores the file descriptor returned by open(2) to struct media_entity.fd.
> v4l2_subdev_close() is not called explicitly. This is currently not
> required.
>
> The file handle is not leaked, as it is closed by media_device_unref() in
> libmediactl.
>
> This patch allocates memory for each sub-device in v4l2_subdev_create()
> which is in turn called from v4l2_subdev_open(). As the calls to
> v4l2_subdev_close() (which would release memory) are lacking, the memory is
> leaked.
>
>>
>> Probably it would be good to remove v4l2_subdev_open from
>> v4l2_subdev_* prefixed API and return error if sd property
>> of passed struct media_entity is not initialized.
>
> The purpose of the libv4l2subdev library is to make accessing sub-devices
> easier, and tossing that responsibility to the user is certainly not
> advancing that goal.
>
> I've been working on extending libmediatext library into an interactive test
> program for V4L2, V4L2 sub-device and Media controller. What I've noticed
> that libv4l2subdev does not currently bend really well for that purpose;
> the data structure holding the media graph is sort of self-contained and
> cannot be extended nor it can be used to refer to something else. That's a
> bit aside from the topic of this patch, but I presume that you'd need to
> associate information to media entities as well. For this reason I presume
> that releasing the resources related to a media entity acquired for e.g.
> IOCTL is not the right way to proceed.
>
> Instead, I think the libraries (libmediactl and libv4l2subdev) need to
> manage the resources (as has been done with file handles up to now).
>
> How about adding a callback to release resources related to an entity, e.g.
> as this:
>
> 	void (*release)(struct media_entity *entity);

Thanks for the comprehensive analysis and for this hint.
It sounds reasonable.

-- 
Best regards,
Jacek Anaszewski
