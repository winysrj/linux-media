Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36430 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3IKJe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 05:34:58 -0400
Received: by mail-ob0-f177.google.com with SMTP id f8so8220959obp.36
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 02:34:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52303233.6060504@xs4all.nl>
References: <CAPybu_3cOLztceJoNwyZQGuC8maNYKuunbxJRHt7X6nQHmCyhw@mail.gmail.com>
 <1378888254-5236-1-git-send-email-ricardo.ribalda@gmail.com> <52303233.6060504@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 11 Sep 2013 11:34:37 +0200
Message-ID: <CAPybu_18+43UTxyxTRJ8DNqfxTOs+o3yv=32AaO7LHh9926QDg@mail.gmail.com>
Subject: Re: [PATCH] RFC: Support for multiple selections
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thanks for your feedback

On Wed, Sep 11, 2013 at 11:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Ricardo,
>
> On 09/11/2013 10:30 AM, Ricardo Ribalda Delgado wrote:
>> A new id field is added to the struct selection. On devices that
>> supports multiple sections this id indicate which of the selection to
>> modify.
>>
>> A new control V4L2_CID_SELECTION_BITMASK selects which of the selections
>> are used, if the control is set to zero the default rectangles are used.
>>
>> This is needed in cases where the user has to change multiple selections
>> at the same time to get a valid combination.
>>
>> On devices where the control V4L2_CID_SELECTION_BITMASK does not exist,
>> the id field is ignored
>
> This feels like a hack to me. A big problem I have with using a control here
> is that with a control you can't specify for which selection target it is.
>

I am not sure that I understand what you mean here.

If you set the control to 0x1 you are using selection 0, if you set
the control to 0x5, you are using selection 0 and 2.


> If you want to set multiple rectangles, why not just pass them directly? E.g.:
>
> struct v4l2_selection {
>         __u32                   type;
>         __u32                   target;
>         __u32                   flags;
>         union {
>                 struct v4l2_rect        r;
>                 struct v4l2_rect        *pr;
>         };
>         __u32                   rectangles;
>         __u32                   reserved[8];
> };
>
> If rectangles > 1, then pr is used.
>

The structure is passed in a ioctl and I dont think that it is a good
idea that you let the kernel get/set a memory address not encapsulated
in it. I can see that it could lead to security breaches if there is a
mistake on the handling.

> It's a bit more work to add this to the core code (VIDIOC_SUBDEV_G/S_SELECTION
> should probably be changed at the same time and you have to fix existing drivers
> to check/set the new rectangles field), but it scales much better.

Also, we would be broking the ABI. Rectangles is not a mandatory
field, and has a value != 0.

What we could do is leave the V4L2_CID_SELECTION_BITMASK  out of the
api, but keep the id field on the structure, so the user can define a
private control to do whatever he needs with the id field, wekeep the
ABI compatibility and no big changes are needed.


Thaks!

>
> Regards,
>
>         Hans
>
>>
