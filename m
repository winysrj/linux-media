Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:60449 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3KLGId (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Nov 2013 01:08:33 -0500
MIME-Version: 1.0
In-Reply-To: <5280DCA9.7070108@xs4all.nl>
References: <1384161580-18674-1-git-send-email-arun.kk@samsung.com>
	<5280A3ED.1040802@xs4all.nl>
	<CALt3h7-dhKQ=r68nvNWNc8unvxPd0iOiVRK4Wvz1Y5+DyTO=Ww@mail.gmail.com>
	<5280DCA9.7070108@xs4all.nl>
Date: Tue, 12 Nov 2013 11:38:32 +0530
Message-ID: <CALt3h78CueiODT7Sp7d8LeOu=pMQtLLcVWKiAce0SUZQqSn5MQ@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: Add QP setting support for vp8 encoder
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 11, 2013 at 7:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 11/11/2013 11:44 AM, Arun Kumar K wrote:
>> Hi Hans,
>>
>> On Mon, Nov 11, 2013 at 3:01 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> Hi Arun,
>>>
>>> On 11/11/2013 10:19 AM, Arun Kumar K wrote:
>>>> Adds v4l2 controls to set MIN, MAX QP values and
>>>> I, P frame QP for vp8 encoder.
>>>
>>> I assume these parameters and their ranges are all defined by the VP8 standard?
>>> Or are they HW specific?
>>>
>>
>> These ranges are not defined by VP8 standard. I can see that the
>> standard does not
>> give any range. The ranges mentioned are defined by Samsung MFC hardware.
>> Do you think that for these controls, I shouldnt mention the range as
>> the standard
>> does not have it?
>
> Either leave it out or just say that the range is hardware dependent.
>

Ok will do that.

Thanks & Regards
Arun
