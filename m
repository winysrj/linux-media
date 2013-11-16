Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3KPR2l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Nov 2013 12:28:41 -0500
Message-ID: <5287AB3C.90109@redhat.com>
Date: Sat, 16 Nov 2013 18:28:28 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi>	<5280D83C.5060809@xs4all.nl>	<5280DE3D.5040408@iki.fi>	<528671DF.7040707@iki.fi> <CAGoCfiz8EBqkEUuzYLXhgXGW-0S6+6s3MAFWdSpfFmuOnP+Dfg@mail.gmail.com> <52867341.7050500@iki.fi> <52877D05.4020604@iki.fi>
In-Reply-To: <52877D05.4020604@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/16/2013 03:11 PM, Antti Palosaari wrote:
> On 15.11.2013 21:17, Antti Palosaari wrote:
>> On 15.11.2013 21:13, Devin Heitmueller wrote:
>>> On Fri, Nov 15, 2013 at 2:11 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>> When I do it inside Kernel, in URB completion handler at the same
>>>> time when
>>>> copying data to videobuf2, using pre-calculated LUTs and using mmap
>>>> it eats
>>>> 0.5% CPU to transfer stream to app.
>>>>
>>>> When I do same but using libv4lconvert as that patch, it takes ~11% CPU.
>>>
>>> How are you measuring?  Interrupt handlers typically don't count
>>> toward the CPU performance counters.  It's possible that the cost is
>>> the same but you're just not seeing it in "top".
>>
>> Yes, using top and it is URB interrupt handler where I do conversion. So
>> any idea how to measure? I think I can still switch LUT to float and see
>> if it makes difference.
>
> I did some more tests. I added LUT to libv4lconvert and CPU usage of process dropped to ~3.5%. It is very simple app that just feeds data from device using mmap and conversion is done by libv4lconvert. Output is feed to standard out which I dumped to /dev/null on tests.
>
> So it is quite clear that runtime float conversion is CPU hungry when conversion rate goes that high (up to 30M conversions per sec).
>
> It is still not very much when compared to CPU needed for average signal processing after that, but it will increase directly CPU usage of that application. So is there idea to add threads for libv4lconvert in order to get conversion out from application context ?

I do not want to start using threads for libv4lconvert, if an app wants to do
the conversion in another thread, it can simply do all the v4l stuff in a
separate capture thread, like gstreamer does for example.

Regards,

Hans
