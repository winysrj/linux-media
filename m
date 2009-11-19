Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZKSLEV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 06:04:21 -0500
Message-ID: <4B0527D9.8000800@redhat.com>
Date: Thu, 19 Nov 2009 12:11:21 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
References: <20091117114147.09889427.ospite@studenti.unina.it>	<4B04FCF6.2060505@redhat.com> <20091119113719.566ba78e.ospite@studenti.unina.it>
In-Reply-To: <20091119113719.566ba78e.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/19/2009 11:37 AM, Antonio Ospite wrote:
> On Thu, 19 Nov 2009 09:08:22 +0100
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> Hi,
>>
>
> Hi, thanks for commenting on this.
>
>> On 11/17/2009 11:41 AM, Antonio Ospite wrote:
>>> Hi,
>>>
>>> gspca does not implement vidioc_enum_frameintervals yet, so even if a
>>> camera can support multiple frame rates (or frame intervals) there is
>>> still no way to enumerate them from userspace.
>>>
>>> The following is just a quick and dirty implementation to show the
>>> problem and to have something to base the discussion on. In the patch
>>> there is also a working example of use with the ov534 subdriver.
>>>
>>> Someone with a better knowledge of gspca and v4l internals can suggest
>>> better solutions.
>>>
>>
>>
>> Does the ov534 driver actually support selecting a framerate from the
>> list this patch adds, and does it then honor the selection ?
>>
>
> Yes it does, it can set framerates as per the list I added (in fact I
> got the list looking at what the driver supports), and I can also see
> it honors the framerate setting, from guvcview fps counter in the
> capture window title. So only framerate enumeration is missing.
>
>>

Hmm, I see now upon expecting the code that the driver does actually
support setting the framerate, but what I see does not seem
to match your patch, the driver seems to support 50, 40, 30 and 15 fps,
where as your patch has:

static int qvga_rates[] = {125, 100, 75, 60, 50, 40, 30};
static int vga_rates[] = {60, 50, 40, 30, 15};


In my experience framerates with webcams are varying all the time, as
>> the lighting conditions change and the cam needs to change its exposure
>> setting to match, resulting in changed framerates.
>>
>> So to me this does not seem very useful for webcams.
>>
>
> As long as the chips involved (bridge, ISP, sensor) are powerful or
> smart enough then the camera won't have problems.
> I guess that for ov534/ov538 the usb bandwidth is the limiting factor
> for the framerates, as we are using a raw format.
>

Hmm, exposure could come in to play too, did you try high fps settings
in low light conditions?

Anyways as the driver clearly supports setting certain frame rates,
adding enumeration for them makes sense.


> Btw, did you take a look at the patch anyway? Can you suggest a better
> place where to put the structures needed for this functionality?
>

Yes I did, it looks ok, except I would change the following:
-in vidioc_enum_frameintervals() make i an __u32, and drop index
  (just compare i to fival->index)
-make the qvga_rates and vga_rates arrays const

Regards,

Hans
