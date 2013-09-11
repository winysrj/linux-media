Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53318 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3IKHiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 03:38:24 -0400
Received: by mail-oa0-f51.google.com with SMTP id h1so8818796oag.24
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 00:38:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <522F97B8.5000101@gmail.com>
References: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
 <5228FB2E.5050503@gmail.com> <CAPybu_2_kyqcmV0zh42X0LG+QvTDmFMJ_ywUsoe5WGh2k71S3Q@mail.gmail.com>
 <20130910214140.GD2057@valkosipuli.retiisi.org.uk> <522F97B8.5000101@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 11 Sep 2013 09:38:04 +0200
Message-ID: <CAPybu_3KpwBA2765gaxqyq6FAKctNMXz5cGJSwZrrM7Yjq9sEQ@mail.gmail.com>
Subject: Re: RFC> multi-crop
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Thanks for your comments

On Wed, Sep 11, 2013 at 12:05 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi All,
>
> On 09/10/2013 11:41 PM, Sakari Ailus wrote:
>>
>> Hi Ricardo,
>>
>> On Fri, Sep 06, 2013 at 10:30:18AM +0200, Ricardo Ribalda Delgado wrote:
>>>
>>> Hi Sylvester
>>>
>>> Thanks for your response
>>>
>>> Unfortunately, the v4l2_crop dont have any reserved field :(
>>
>>
>> Don't worry about v4lw_crop. we have selections now. :-)
>
>
> True, I belive no possibility of extending struct v4l2_crop was one of
> the reasons why the selections API has benn introduced. The selections
> API provides superset of functionality of the original cropping API and
> G/S_CROP/CROPCAP ioctls should be considered deprecated.
>

We should update the doc to tell the user that the crop api will be
superseded soon by the selection api.

>>> struct v4l2_crop {
>>> __u32 type; /* enum v4l2_buf_type */
>>> struct v4l2_rect        c;
>>> };
>>>
>>> And changing that ABI I dont think is an option.
>>>
>>> What about a new call: G/S_READOUT .that uses a modified
>>> v4l2_selection as you propose?
>>
>>
>> Could this functionality be added to the ex$sting selection API, with a
>> possible extension in a for of a new field, say, "id" to tell which one is
>> being changed?
>
>
> +1, that was my idea as well.
>

This looks like the right way to do it. I only see an issue. Lets say
we have a hw that needs all the selection to have the same width.

The user creates selection 0, 1 and 2 with width 100. Now he wants
them to be 200 witdh.

He changes selection 0, but because the driver returns -EINVAL (or
resizes the selection to 100, to fit the old selections).

So the user cannot change the size anymore :(

>>> That call selects the readable areas from the sensor.
>>>
>>> The new structure could be something like:
>>>
>>> #define SELECTION_BITMAP 0xffffffff
>>> #define SELECTION_RESET 0xfffffffe
>>> #define SELECTION_MAX_AREAS 32
>>> struct v4l2_selection {
>>> __u32 type;
>>> __u32 target;
>>> __u32                   flags;
>>> union {
>>>     struct v4l2_rect        r;
>>>     __u32 bitmap;
>>> };
>>> __u32 n;
>>> __u32                   reserved[8];
>>> };
>>>
>>> n chooses the readout area to choose, up to 32.
>>>
>>> When n is == 0xffffffff the user wants to change the bitmap that
>>> selects which areas are enabled.
>>>    When the bitmap is 0x0 all the sensor is read.
>>>    When the bitmap is 0x5 the readout area 0 and 2 are enabled.
>>>
>>> When the bitmap is set to a value !=0, the driver checks if the
>>> combination of readout areas is supported by the sensor/readout logic
>>> and returns -EINVAL if not.
>
>
> Would the supported combinations vary at run-time, depending on some
> configuration parameters. Or would it be rather fixed and known at device
> initialization time ?
>

The combinations vary at runtime, depending on the size and what the
user wants to readout.

>>> The g/s_crop API still works as usual.
>>>
>>> Any comment on this? Of course the names should be better chosen, this
>>> is just a declaration of intentions.
>>
>>
>> I think the functionality you're describing is highly peculiar. I have to
>> say that, as Sylwester noted, it bears resemblance to the AF windows so
>> the
>> solution could be same as well.
>>
>> I think earlier on (say perhaps a year and a half) ago it was proposed to
>> use bitmask controls with selections to tell which IDs are valid. What
>> would
>> you think about that?
>
>
> My feelings are that using a bitmask control to select sub-windows would
> be far more flexible than embedding the mask field in struct v4l2_selection.
> If there is more than 32 windows needed the control API could be extended,
> at least for up to 64-bit it seems not a big deal.
> And an "id" member of struct v4l2_selection would be generic and could be
> used for other purposes as well.

I agree here too.

>
>> It's also always possible to use private controls, too.
>
>
> --
> Regards,
> Sylwester


Thanks for your comments


-- 
Ricardo Ribalda
