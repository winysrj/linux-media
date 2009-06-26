Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4675 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFZHtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 03:49:49 -0400
Message-ID: <5516.62.70.2.252.1246002589.squirrel@webmail.xs4all.nl>
Date: Fri, 26 Jun 2009 09:49:49 +0200 (CEST)
Subject: Re: [PATCH] mt9t031 - migration to sub device frame work
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Fri, 26 Jun 2009, Hans Verkuil wrote:
>
>> On Thursday 25 June 2009 22:17:04 Karicheri, Muralidharan wrote:
>> >
>> > >-----Original Message-----
>> > >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> > >owner@vger.kernel.org] On Behalf Of Guennadi Liakhovetski
>> > >Sent: Thursday, June 25, 2009 1:46 PM
>> > >To: Karicheri, Muralidharan
>> > >Cc: linux-media@vger.kernel.org; davinci-linux-open-
>> > >source@linux.davincidsp.com
>> > >Subject: Re: [PATCH] mt9t031 - migration to sub device frame work
>> > >
>> > >On Wed, 24 Jun 2009, m-karicheri2@ti.com wrote:
>> > >
>> > >> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>> > >>
>> > >> This patch migrates mt9t031 driver from SOC Camera interface to
>> > >> sub device interface. This is sent to get a feedback about the
>> > >> changes done since I am not sure if some of the functionality
>> > >> that is removed works okay with SOC Camera bridge driver or
>> > >> not. Following functions are to be discussed and added as needed:-
>> > >>
>> > >>      1) query bus parameters
>> > >>      2) set bus parameters
>> > >>      3) set crop
>>
>> 3 is fixed in a pending patch from Guennadi. Should be in soon I hope.
>> I hope to take a final look at 1+2 this weekend.
>
> Hans, you can read unsubmitted patches?:-)

Good, isn't it? :-)

Actually, I assumed Karicheri was referring to the missing s_crop et al
ops in v4l2_subdev. Those you added in a patch in a pull request from you.

> In fact, yes, I am working on a
> big S_CROP / S_FMT revamp right now, which should make soc-camera
> behaviour standard compliant (or at least compliant with my _current_
> understanding of the standard, which is:
>
> S_CROP sets the input (sensor / decoder / ...) window and tries to
> preserve scaling factors if possible. Output window may change. The user
> has to verify the actual changes performed by issuing G_FMT / G_CROP.
>
> S_FMT sets output window and tries to preserve the input window by
> changing scaling factors. The actually configured window is also returned
> in the ioctl argument. To retrieve the input window the user shall issue
> G_CROP.
>
> ). I started by converting mx3-camera and mt9t031, and I shall upload an
> incomplete patch, converting only these drivers to my "testing" area,
> while I shall start converting the rest of the drivers... So, it is
> advisable to wait for that patch to appear and base any future (including
> this one) work on it, because it is a pretty big change and merging would
> be non-trivial.
>
>> > >> +static inline struct mt9t031 *to_mt9t031(struct v4l2_subdev *sd)
>> > >> +{
>> > >> +    return container_of(sd, struct mt9t031, sd);
>> > >> +}
>> > >> +
>> > >>  static int reg_read(struct i2c_client *client, const u8 reg)
>>
>> I recommend using struct v4l2_subdev *sd here instead of the client
>> pointer.
>> Experience shows that it is usually best to push the sd -> client
>> conversion
>> to the lowest level possible.
>
> Why? I actually have done the opposite on a few occasions - switched from
> passing a struct soc_camera_device pointer to passing a struct i2c_client
> pointer directly, which led to some nice code simplifications. Just
> imagine issuing reg_read multiple times in a function, so, you would have
> to convert it every time? The compiler _might_ happen to be smart enough
> to optimise this away by inining them, but I wouldn't rely on that.

v4l2_get_subdevdata is a simple inline (just returns sd->priv), so I think
we can safely rely on it being inlined. Also remember that the actual i2c
transfer is many, many, many times slower then the worst-case scenario of
doing a function call. So whether a compiler optimizes this or not is
completely irrelevant. Code readability is, though.

> Besides, there are also some mid-level functions, which don't need the
> subdev / soc-camera pointer either, but would have to deal with it if we
> were to use it in low-level ones. So, I cannot say I agree straight away
> on this one.

Until now in all the drivers I converted I think there was only one where
I didn't push this conversion down to the lowest level due to a lot of
mid-level functions. In all others it was much simpler to push it down.
And that definitely improved readability and the quality of the code.

Regards,

      Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

