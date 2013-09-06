Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56956 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3IFIaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Sep 2013 04:30:39 -0400
Received: by mail-ob0-f176.google.com with SMTP id uz19so3133953obc.21
        for <linux-media@vger.kernel.org>; Fri, 06 Sep 2013 01:30:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5228FB2E.5050503@gmail.com>
References: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
 <5228FB2E.5050503@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 6 Sep 2013 10:30:18 +0200
Message-ID: <CAPybu_2_kyqcmV0zh42X0LG+QvTDmFMJ_ywUsoe5WGh2k71S3Q@mail.gmail.com>
Subject: Re: RFC> multi-crop (was: Multiple Rectangle cropping)
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylvester

Thanks for your response

Unfortunately, the v4l2_crop dont have any reserved field :(

struct v4l2_crop {
__u32 type; /* enum v4l2_buf_type */
struct v4l2_rect        c;
};

And changing that ABI I dont think is an option.

What about a new call: G/S_READOUT .that uses a modified
v4l2_selection as you propose?

That call selects the readable areas from the sensor.

The new structure could be something like:

#define SELECTION_BITMAP 0xffffffff
#define SELECTION_RESET 0xfffffffe
#define SELECTION_MAX_AREAS 32
struct v4l2_selection {
__u32 type;
__u32 target;
__u32                   flags;
union {
   struct v4l2_rect        r;
   __u32 bitmap;
};
__u32 n;
__u32                   reserved[8];
};

n chooses the readout area to choose, up to 32.

When n is == 0xffffffff the user wants to change the bitmap that
selects which areas are enabled.
  When the bitmap is 0x0 all the sensor is read.
  When the bitmap is 0x5 the readout area 0 and 2 are enabled.

When the bitmap is set to a value !=0, the driver checks if the
combination of readout areas is supported by the sensor/readout logic
and returns -EINVAL if not.

The g/s_crop API still works as usual.

Any comment on this? Of course the names should be better chosen, this
is just a declaration of intentions.

Cheers!



On Thu, Sep 5, 2013 at 11:44 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 09/05/2013 11:10 PM, Ricardo Ribalda Delgado wrote:
>>
>> Hello
>
>
> Hi,
>
>
>>   I am working porting a industrial camera driver to v4l. So far I have
>> been able to describe most of the old functionality with v4l
>> equivalents. The only thing that I am missing is multi cropping.
>>
>> The sensor (both a cmosis and a ccd chips) supports skipping lines
>> from up to 8 regions. This increases the readout speed up to 50%,
>> which is critical for the application.
>>
>> Unfortunately I have no way to describe multiple cropping areas in
>> v4l. I am thinking about creating a new API/extending and old one for
>> this.
>>
>> Any suggestion before I start? Have you faced also this problem? How
>> did you solve it?
>
>
> A similar issue has been raised during discussions on the camera auto
> focus rectangle selection API. While defining need selection targets [1]
> it was also proposed to convert one of the struct v4l2_selection reserved
> fields into an index field, which would indicate one rectangle of some
> set of rectangles supported by a driver. Then there could be a v4l2
> bitmask control to determine which rectangles are currently valid/in use.
>
> Would something like this be relevant to your problem ?
>
>
>> I am planning to go to the Edinburgh mini summit, maybe we could add
>> this to the agenda (if you consider that it is worth the time, of
>> course)
>
>
> It definitely sounds like a good topic to discuss at the mini summit,
> unless it gets resolved until then. ;-)
>
> [1] http://www.spinics.net/lists/linux-media/msg64499.html
>
> --
> Regards,
> Sylwester



-- 
Ricardo Ribalda
