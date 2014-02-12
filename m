Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3387 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaBLMoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 07:44:01 -0500
Message-ID: <52FB6BB3.1060300@xs4all.nl>
Date: Wed, 12 Feb 2014 13:40:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 24/34] v4l2-ctrls/videodev2.h: add u8 and u16
 types.
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl> <1392022019-5519-25-git-send-email-hverkuil@xs4all.nl> <CAPybu_2TkODSMUCdSQ8Q1wu=Mr-gmaC_ZQQBiatOPYw=gGcu2g@mail.gmail.com> <52FB5910.9040101@xs4all.nl> <CAPybu_0Kw8-Rq2-oNmwBpF36N6HLg3vZ9CaywLsTQp+9Ym5Z8w@mail.gmail.com>
In-Reply-To: <CAPybu_0Kw8-Rq2-oNmwBpF36N6HLg3vZ9CaywLsTQp+9Ym5Z8w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/14 13:11, Ricardo Ribalda Delgado wrote:
> Hi Hans
> 
> Thanks for your reply
> 
> On Wed, Feb 12, 2014 at 12:20 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ricardo,
>>
>> On 02/12/14 11:44, Ricardo Ribalda Delgado wrote:
>>> Hello Hans
>>>
>>> In the case of U8 and U16 data types. Why dont you fill the elem_size
>>> automatically in v4l2_ctrl and request the driver to fill the field?
>>
>> When you create the control the control framework has to know the element
>> size beforehand as it will use that to allocate the memory containing the
>> control's value. The control framework is aware of the 'old' control types
>> and will fill in the elem_size accordingly, but it cannot do that in the
>> general case for these complex types. I guess it could be filled in by the
>> framework for the more common types (U8, U16) but I felt it was more
>> consistent to just require drivers to fill it in manually, rather than have
>> it set for some types but not for others.
>>
>>>
>>> Other option would be not declaring the basic data types (U8, U16,
>>> U32...) and use elem_size. Ie. If type==V4L2_CTRL_COMPLEX_TYPES, then
>>> the type is basic and elem_size is the size of the type. If the type
>>>> V4L2_CTRL_COMPLEX_TYPES the type is not basic.
>>
>> You still need to know the type. Applications have to be able to check for
>> the type, the element size by itself doesn't tell you how to interpret the
>> data, you need the type identifier as well.
> 
> I think that the driver is setting twice the same info. I see no gain
> in declaring U8, U16 types etc if we still have to set the element
> size. This is why I believe that we should only declare the "structs".

Just to make sure I understand you: for simple types like U8/U16 you want
the control framework to fill in elem_size, for more complex types (structs)
you want the driver to fill in elem_size?
 
> what about something like: V4L2_CTRL_COMPLEX_TYPE_SIGNED_INTEGER +
> size, V4L2_CTRL_COMPLEX_TYPES_UNSIGNED_INTEGER + size.... instead of
> V4L2_CTRL_COMPLEX_TYPES_U8, V4L2_CTRL_COMPLEX_TYPES_U16,
> V4L2_CTRL_COMPLEX_TYPES_U32, V4L2_CTRL_COMPLEX_TYPES_S8 ....
> 
> Btw, I am trying to implement a dead pixel control on the top of you
> api. Shall I wait until you patchset is merged or shall I send the
> patches right away?

You're free to experiment, but I am not going to ask Mauro to pull additional
patches as long as this initial patch set isn't merged.

Regards,

	Hans
