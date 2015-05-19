Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48841 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbbESG3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 02:29:46 -0400
Message-ID: <555AD847.20800@xs4all.nl>
Date: Tue, 19 May 2015 08:29:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DocBook/media: fix querycap error code
References: <5549B63F.7020009@xs4all.nl> <20150518161751.57127058@recife.lan>
In-Reply-To: <20150518161751.57127058@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/18/2015 09:17 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 06 May 2015 08:35:43 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> The most likely error you will get when calling VIDIOC_QUERYCAP for a
>> device node that does not support it is ENOTTY, not EINVAL.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  Documentation/DocBook/media/v4l/vidioc-querycap.xml | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
>> index 20fda75..131abca 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
>> @@ -54,7 +54,7 @@ kernel devices compatible with this specification and to obtain
>>  information about driver and hardware capabilities. The ioctl takes a
>>  pointer to a &v4l2-capability; which is filled by the driver. When the
>>  driver is not compatible with this specification the ioctl returns an
>> -&EINVAL;.</para>
>> +error, most likely the &ENOTTY;.</para>
> 
> Hmm... "likely"...
> 
> This is not nice... This is an specification. It should properly define
> the error code, and not let the user to guess.
> 
> This should be, instead:
> 	"All V4L2 drivers should support VIDIOC_QUERYCAP."

That's what the first line of this QUERYCAP page says. If you are a V4L2
driver, then this ioctl will be supported. This patch is about what happens
when you give it to a non-v4l2 driver.

> 
> The Documentation already points to to the generic error codes, 
> with would actually happen only in the case something goes deadly wrong. 
> There are very few error codes that could actually happen on this point,
> like EFAULT, if, for some reason, the Kernel fails to copy data to 
> userspace, or ENODEV is a device got removed.
> 
> Of course, if onse sends this ioctl to a non-v4l2 device, an error
> code will be returned, but the actual error code will depend on the
> device where this is sent, as, except if one janitor did a huge
> changeset fixing this, I'm almost sure that not all devices will
> return ENOTTY when an ioctl is not implemented.
> 
> Yet, for userspace, it is safe to assume that, if VIDIOC_QUERYCAP
> fails, either the device is not V4L2 or the V4L2 device won't work
> anyway, as there's something really broken there.

Right. So which is why I made the change: we don't control what other subsystems
do, so all I can say is that you get an error back, which is most likely ENOTTY.

Since what such a subsystem returns is out of scope of the spec, I cannot say
that it will be one specific error (after all, we returned EINVAL for a long time
instead of ENOTTY when we got an unknown ioctl).

So I don't see the problem with this patch.

If you prefer I can change it to: "...returns an error, either the &ENOTTY; or the &EINVAL;."

I would be comfortable with that since those two are the main possibilities.

Regards,

	Hans

> 
> Regards,
> Mauro
> 
> 
>>  
>>      <table pgwide="1" frame="none" id="v4l2-capability">
>>        <title>struct <structname>v4l2_capability</structname></title>

