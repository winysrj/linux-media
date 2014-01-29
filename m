Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3970 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaA2HsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jan 2014 02:48:00 -0500
Message-ID: <52E8B217.4070101@xs4all.nl>
Date: Wed, 29 Jan 2014 08:47:35 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFCv3 PATCH 00/22] Add support for complex controls
References: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl> <CAPybu_2TbWi6Vpo=hY2A=u3rfkUYazWf3za2CvwHaqZqu_wHuQ@mail.gmail.com>
In-Reply-To: <CAPybu_2TbWi6Vpo=hY2A=u3rfkUYazWf3za2CvwHaqZqu_wHuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo!

On 01/28/2014 06:18 PM, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> Congratulations for the set, I think it is a step in the right direction.

Good to hear!

> I have some questions. I hope I havent entered the discussion too late.
> 
> 1) One problem that I am facing now is how to give userland a list of
> "dead pixels". Could we also add a v4l2_prop_type_matrix_pixel? I
> believe it could be useful for more people. Or do we have another
> standard way to do it now?

Sure this would be possible. Add a struct v4l2_point { __u32 x, y; } and
you can make a V4L2_CID_DEADPIXELS array control. I'm assuming the dead pixels
list is determined during the probe() function? If so, then the driver can
just create a control with the size of the number of dead pixels. If it is
more dynamic, then that is a bit of a problem since the size of the control
is fixed at creation.

> 
> 
> 2)  Assuming selection is a property. id will tell if we are setting
> CAPTURE_CROP, CAPTURE_COMPOSE, OUTPUT_CROP or OUTPUT_COMPOSE and type
> will tell if it is an array or a single element?

Are you talking userspace or kernelspace? In the kernel there is a is_matrix
field in v4l2_ctrl that tells whether the control is a matrix or not.

In userspace you need to check the rows/cols fields from the new VIDIOC_QUERY_EXT_CTRL
ioctl. The type field refers to the type of each element.

Originally I had a 'MATRIX' flag in the type, but that proved too cumbersome.

> 
> something like:
> type=V4L2_PROP_TYPE_MATRIX | V4L2_PROP_TYPE_SELECTION ?
> type= V4L2_PROP_TYPE_SELECTION ;
> 
> On the patchset there is nothing about selections. Or I am missing something?

Not this one, once this is merged I plan on adding the selection support. The
RFCv1 code has (primitive) selection support, for more up to date code see also
this tree:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/propapi-doc

Regards,

	Hans

> 
> 
> 
> Thanks!
> 
> On Mon, Jan 27, 2014 at 3:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> This patch series adds support for complex controls (aka 'Properties') to
>> the control framework. It is the first part of a larger patch series that
>> adds support for configuration stores, motion detection matrix controls and
>> support for 'Multiple Selections'.
>>
>> This patch series is based on this RFC:
>>
>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/71822
>>
>> A more complete patch series (including configuration store support and the
>> motion detection work) can be found here:
>>
>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/propapi-doc
>>
>> This patch series is a revision of RFCv2:
>>
>> http://www.spinics.net/lists/linux-media/msg71828.html
>>
>> Changes since RFCv2 are:
>>
>> - incorporated Sylwester's comments
>> - split up patch [20/21] into two: one for the codingstyle fixes in the example
>>   code, one for the actual DocBook additions.
>> - fixed a bug in patch 6 that broke the old-style VIDIOC_QUERYCTRL. Also made
>>   the code in v4l2_query_ext_ctrl() that sets the mask/match variables more
>>   readable. If I had to think about my own code, then what are the chances others
>>   will understand it? :-)
>> - dropped the support for setting/getting partial matrices. That's too ambiguous
>>   at the moment, and we can always add that later if necessary.
>>
>> The API changes required to support complex controls are minimal:
>>
>> - A new V4L2_CTRL_FLAG_HIDDEN has been added: any control with this flag (and
>>   complex controls will always have this flag) will never be shown by control
>>   panel GUIs. The only way to discover them is to pass the new _FLAG_NEXT_HIDDEN
>>   flag to QUERYCTRL.
>>
>> - A new VIDIOC_QUERY_EXT_CTRL ioctl has been added: needed to get the number of elements
>>   stored in the control (rows by columns) and the size in byte of each element.
>>   As a bonus feature a unit string has also been added as this has been requested
>>   in the past. In addition min/max/step/def values are now 64-bit.
>>
>> - A new 'p' field is added to struct v4l2_ext_control to set/get complex values.
>>
>> - A helper flag V4L2_CTRL_FLAG_IS_PTR has been added to tell apps whether the
>>   'value' or 'value64' fields of the v4l2_ext_control struct can be used (bit
>>   is cleared) or if the 'p' pointer can be used (bit it set).
>>
>> Once everyone agrees with this API extension I will make a next version of this
>> patch series that adds the Motion Detection support for the solo6x10 and go7007
>> drivers that can now use the new matrix controls. That way actual drivers will
>> start using this (and it will allow me to move those drivers out of staging).
>>
>> Regards,
>>
>>         Hans
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

