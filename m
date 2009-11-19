Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZKSJUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 04:20:37 -0500
Message-ID: <4B050F81.6050105@redhat.com>
Date: Thu, 19 Nov 2009 10:27:29 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
CC: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
References: <20091117114147.09889427.ospite@studenti.unina.it> <4B04FCF6.2060505@redhat.com> <4B050925.4000006@panicking.kicks-ass.org>
In-Reply-To: <4B050925.4000006@panicking.kicks-ass.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/19/2009 10:00 AM, Michael Trimarchi wrote:
> Hans de Goede wrote:
>> Hi,
>>
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
>
> The ov534 is a bridge for different sensor like ov538 so it support
> different
> frame rate, depends on the sensor too.
>

That does not really answer my question. Does the current ov534 gspca
code allow one to set the framerate, and it will it then stay fixed
at that rate independend of the exposure setting of the sensor.

I know some uvc cams which do this, they basically send the same
frame multiple times to keep the framerate constant when the
exposure time raises above the time between frames, but most don't.

without such a feature advertising framerates makes no sense, as we
are advertising something we cannot deliver.

Regards,

Hans
