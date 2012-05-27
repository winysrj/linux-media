Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62515 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2E0VyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 17:54:05 -0400
Received: by wibhn6 with SMTP id hn6so1154484wib.1
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 14:54:03 -0700 (PDT)
Message-ID: <4FC2A279.2040404@gmail.com>
Date: Sun, 27 May 2012 23:54:01 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@redhat.com,
	linux-media@vger.kernel.org, hdegoede@redhat.com
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
References: <201205261950.06022.hverkuil@xs4all.nl> <4FC12F82.6040705@gmail.com> <CALF0-+VPkbZ8sUbPmxNT46J5S8X_jwRH3Wc4yX7DUHXyjKmbEg@mail.gmail.com>
In-Reply-To: <CALF0-+VPkbZ8sUbPmxNT46J5S8X_jwRH3Wc4yX7DUHXyjKmbEg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On 05/27/2012 11:32 PM, Ezequiel Garcia wrote:
>>>> +static int buffer_prepare(struct vb2_buffer *vb)
>>>> +{
>>>> +    struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
>>>> +    struct stk1160_buffer *buf =
>>>> +                    container_of(vb, struct stk1160_buffer, vb);
>>>> +
>>>> +    /* If the device is disconnected, reject the buffer */
>>>> +    if (!dev->udev)
>>>> +            return -ENODEV;
>>>> +
>>>> +    buf->mem = vb2_plane_vaddr(vb, 0);
>>>> +    buf->length = vb2_plane_size(vb, 0);
>>
>> Where do you check if the buffer you get from vb2 has correct parameters
>> for your hardware (with current settings) to start writing data to it ?
>>
>> It seems that this driver supports just one pixel format and resolution,
>> but still would be good to do such checks in buf_prepare().
> 
> You mean I should check buf->length?

Yeah, you should validate the passed in vb2_buffer. Here is some example:
http://lxr.linux.no/#linux+v3.4/drivers/media/video/mx2_emmaprp.c#L715

IOW, you should compare value returned from vb2_plane_vaddr(vb, 0) during
streaming with value computed from pixel format and resolution -
configured with S_FMT. Rather than accepting any buffer passed to the driver
from user space.


Regards,
Sylwester
