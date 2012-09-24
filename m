Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345Ab2IXSpS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 14:45:18 -0400
Message-ID: <5060AA68.6050208@redhat.com>
Date: Mon, 24 Sep 2012 20:46:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chris MacGregor <chris@cybermato.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com> <50603C39.9060105@redhat.com> <CA+V-a8uLhTTTOMNtz-iL=HZ0M+D6LgU4nbttcbb9Ej1cNDQMEQ@mail.gmail.com> <506095A7.7020302@cybermato.com>
In-Reply-To: <506095A7.7020302@cybermato.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/24/2012 07:17 PM, Chris MacGregor wrote:
>
> On 09/24/2012 07:42 AM, Prabhakar Lad wrote:
>> Hi Hans,
>>
>> On Mon, Sep 24, 2012 at 4:25 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>>> Hi,
>>>
>>>
>>> On 09/23/2012 01:26 PM, Prabhakar Lad wrote:
>>>> Hi All,
>>>>
>>>> The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
>>>> B/Mg gain values.
>>>> Since these control can be re-usable I am planning to add the
>>>> following gain controls as part
>>>> of the framework:
>>>>
>>>> 1: V4L2_CID_GAIN_RED
>>>> 2: V4L2_CID_GAIN_GREEN_RED
>>>> 3: V4L2_CID_GAIN_GREEN_BLUE
>>>
>>> Not all sensors have separate V4L2_CID_GAIN_GREEN_RED /
>>> V4L2_CID_GAIN_GREEN_BLUE,
>>> so we will need a separate control for sensors which have one combined gain
>>> called simply V4L2_CID_GAIN_GREEN
>>>
>> Agreed
>>
>>> Also do we really need separate V4L2_CID_GAIN_GREEN_RED /
>>> V4L2_CID_GAIN_GREEN_BLUE
>>> controls? I know hardware has them, but in my experience that is only done
>>> as it
>>> is simpler to make the hardware this way (fully symmetric sensor grid), have
>>> you ever
>>> tried actually using different gain settings for the 2 different green rows
>>> ?
>>>
>> Never tried it.
>>
>>> I've and that always results in an ugly checker board pattern. So I think we
>>> can
>>> and should only have a V4L2_CID_GAIN_GREEN, and for sensors with 2 green
>>> gains
>>> have that control both, forcing both to always have the same setting, which
>>> is
>>> really what you want anyways ...
>>>
>> Agreed.
>
> Please don't do this.  I am working with the MT9P031, which has separate gains, and as we are using the color version of the sensor (which we can get much more cheaply) with infrared illumination, we correct for the slightly different response levels of the different color channels by adjusting the individual gain controls.

Ok, sofar I'm following you, but are you saying that the correction you need to apply for the green pixels on the same row as red pixels, is different then the one for the green pixels on the same row as blue pixels ?
I can understand that the green "lenses" let through a different amount of infrared light then sat the red lenses, but is there any (significant) differences between the green lenses on 2 different rows?

   (I have patches to add the controls, but I haven't had time yet to get them into good enough shape to submit - sorry!)
>
> It seems to me that for applications that want to set them to the same value (presumably the vast majority), it is not so hard to set both the green_red and green_blue.  If you implement a single control, what happens for the (admittedly rare) application that needs to control them separately?

Well if these are showing up in something like a user oriented control-panel (which they may) then having one slider for both certainly is more userfriendly.

Regards,

Hans
