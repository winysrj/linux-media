Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:43856 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754284AbZKSJAe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 04:00:34 -0500
Message-ID: <4B050925.4000006@panicking.kicks-ass.org>
Date: Thu, 19 Nov 2009 10:00:21 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
References: <20091117114147.09889427.ospite@studenti.unina.it> <4B04FCF6.2060505@redhat.com>
In-Reply-To: <4B04FCF6.2060505@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 11/17/2009 11:41 AM, Antonio Ospite wrote:
>> Hi,
>>
>> gspca does not implement vidioc_enum_frameintervals yet, so even if a
>> camera can support multiple frame rates (or frame intervals) there is
>> still no way to enumerate them from userspace.
>>
>> The following is just a quick and dirty implementation to show the
>> problem and to have something to base the discussion on. In the patch
>> there is also a working example of use with the ov534 subdriver.
>>
>> Someone with a better knowledge of gspca and v4l internals can suggest
>> better solutions.
>>
> 
> 
> Does the ov534 driver actually support selecting a framerate from the
> list this patch adds, and does it then honor the selection ?

The ov534 is a bridge for different sensor like ov538 so it support different
frame rate, depends on the sensor too.

Michael
