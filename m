Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback-out2.mxes.net ([216.86.168.191]:24085 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756949Ab2IXR2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 13:28:15 -0400
Received: from mxout-07.mxes.net (mxout-07.mxes.net [216.86.168.182])
	by fallback-in1.mxes.net (Postfix) with ESMTP id 9A0DA2FDC28
	for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 13:19:05 -0400 (EDT)
Message-ID: <506095A7.7020302@cybermato.com>
Date: Mon, 24 Sep 2012 10:17:27 -0700
From: Chris MacGregor <chris@cybermato.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com> <50603C39.9060105@redhat.com> <CA+V-a8uLhTTTOMNtz-iL=HZ0M+D6LgU4nbttcbb9Ej1cNDQMEQ@mail.gmail.com>
In-Reply-To: <CA+V-a8uLhTTTOMNtz-iL=HZ0M+D6LgU4nbttcbb9Ej1cNDQMEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 09/24/2012 07:42 AM, Prabhakar Lad wrote:
> Hi Hans,
>
> On Mon, Sep 24, 2012 at 4:25 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>>
>> On 09/23/2012 01:26 PM, Prabhakar Lad wrote:
>>> Hi All,
>>>
>>> The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
>>> B/Mg gain values.
>>> Since these control can be re-usable I am planning to add the
>>> following gain controls as part
>>> of the framework:
>>>
>>> 1: V4L2_CID_GAIN_RED
>>> 2: V4L2_CID_GAIN_GREEN_RED
>>> 3: V4L2_CID_GAIN_GREEN_BLUE
>>
>> Not all sensors have separate V4L2_CID_GAIN_GREEN_RED /
>> V4L2_CID_GAIN_GREEN_BLUE,
>> so we will need a separate control for sensors which have one combined gain
>> called simply V4L2_CID_GAIN_GREEN
>>
> Agreed
>
>> Also do we really need separate V4L2_CID_GAIN_GREEN_RED /
>> V4L2_CID_GAIN_GREEN_BLUE
>> controls? I know hardware has them, but in my experience that is only done
>> as it
>> is simpler to make the hardware this way (fully symmetric sensor grid), have
>> you ever
>> tried actually using different gain settings for the 2 different green rows
>> ?
>>
> Never tried it.
>
>> I've and that always results in an ugly checker board pattern. So I think we
>> can
>> and should only have a V4L2_CID_GAIN_GREEN, and for sensors with 2 green
>> gains
>> have that control both, forcing both to always have the same setting, which
>> is
>> really what you want anyways ...
>>
> Agreed.

Please don't do this.  I am working with the MT9P031, which has separate 
gains, and as we are using the color version of the sensor (which we can 
get much more cheaply) with infrared illumination, we correct for the 
slightly different response levels of the different color channels by 
adjusting the individual gain controls.  (I have patches to add the 
controls, but I haven't had time yet to get them into good enough shape 
to submit - sorry!)

It seems to me that for applications that want to set them to the same 
value (presumably the vast majority), it is not so hard to set both the 
green_red and green_blue.  If you implement a single control, what 
happens for the (admittedly rare) application that needs to control them 
separately?

>
> Regards,
> --Prabhakar Lad
>
>>> 4: V4L2_CID_GAIN_BLUE
>>> 5: V4L2_CID_GAIN_OFFSET
>>
>> GAIN_OFFSET that sounds a bit weird... GAIN_OFFSET sounds like it is
>> a number which gets added to the 3/4 gain settings before the gain gets
>> applied,
>> but I assume that you just mean a number which gets added to the value from
>> the pixel, either before or after the gain is applied and I must admit I
>> cannot
>> come up with a better name.
>>
>> I believe (not sure) that some sensors have these per color ... The question
>> is if it makes sense to actually control this per color though, I don't
>> think it
>> does as it is meant to compensate for any fixed measuring errors, which are
>> the
>> same for all 3/4 colors. Note that all the sensor cells are exactly the
>> same,
>> later on a color grid gets added on top of the sensors to turn them into
>> r/g/b
>> cells, but physically they are the same cells, so with the same process and
>> temperature caused measuring errors...
>>
>> Regards,
>>
>> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

