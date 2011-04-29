Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab1D2MHl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 08:07:41 -0400
Message-ID: <4DBAAA5A.2050803@redhat.com>
Date: Fri, 29 Apr 2011 14:08:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yordan Kamenov <ykamenov@mm-sol.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH 1/1 v3] libv4l: Add plugin support to libv4l
References: <cover.1297680043.git.ykamenov@mm-sol.com> <234f9f1fbf05f602d2a079962305e050976f1c58.1297680043.git.ykamenov@mm-sol.com> <4DB961A3.70000@redhat.com> <4DBA7D13.2080805@mm-sol.com>
In-Reply-To: <4DBA7D13.2080805@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 04/29/2011 10:55 AM, Yordan Kamenov wrote:
> Hans de Goede wrote:
>> Hi,
>>
> Hi Hans,
>
> Thanks for your comments.
>> First of all my apologies for taking so long to get around to
>> reviewing this.
>>
>> Over all it looks good, I've put some small remarks inline, if
>> you fix these I can merge this. I wonder though, given the recent
>> limbo around Nokia's change of focus, if there are any plans to
>> actually move forward with a plugin using this... ?
>>
>> The reason I'm asking is that adding the plugin framework if nothing
>> is going to use it seems a bit senseless.
> We are working on a "media controller" plugin which allows
> a traditional v4l2 application to work with Media Controller
> framework. The idea is when the application opens /dev/video0, then
> the plugin initializes media controller and creates appropriate pipeline,
> after that the plugin redirects all ioctl's from the application to this
> pipeline and on close call the pipeline is deinitialized.

Cool.

>>
>> Regards,
>>
>> Hans
>>
>>
>> On 02/14/2011 12:02 PM, Yordan Kamenov wrote:
> [snip]
>>
>>> diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
>>> index e251085..03f34ad 100644
>>> --- a/lib/libv4l2/v4l2convert.c
>>> +++ b/lib/libv4l2/v4l2convert.c
>>> @@ -46,7 +46,6 @@
>>> LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
>>> {
>>> int fd;
>>> - struct v4l2_capability cap;
>>> int v4l_device = 0;
>>>
>>> /* check if we're opening a video4linux2 device */
>>> @@ -76,14 +75,6 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
>>> if (fd == -1 || !v4l_device)
>>> return fd;
>>>
>>> - /* check that this is an v4l2 device, libv4l2 only supports v4l2 devices */
>>> - if (SYS_IOCTL(fd, VIDIOC_QUERYCAP,&cap))
>>> - return fd;
>>> -
>>> - /* libv4l2 only adds functionality to capture capable devices */
>>> - if (!(cap.capabilities& V4L2_CAP_VIDEO_CAPTURE))
>>> - return fd;
>>> -
>>> /* Try to Register with libv4l2 (in case of failure pass the fd to the
>>> application as is) */
>>> v4l2_fd_open(fd, 0);
>>
>> Hmm, why are you removing this check ?
>>
> In case of above example of media controller plugin when the application opens
> /dev/video0, then this plugin should be used. But in media controller framework
> /dev/video0 file might correspond to a subdevice which is not a capture device and
> this fd will not be registered in libv4l2 at all.
>

Ok, on second thought this is fine, you can leave it in :)

Regards,

Hans
