Return-path: <mchehab@pedra>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:44438 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab1EZMR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 08:17:28 -0400
Message-ID: <4DDE44BA.6030808@st.com>
Date: Thu, 26 May 2011 17:46:58 +0530
From: vipul kumar samar <vipulkumar.samar@st.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Martin Bugge (marbugge)" <marbugge@cisco.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: About RFC of HDMI-CEC
References: <4DDCED60.3080907@st.com> <4DDCF95C.1020705@cisco.com> <4DDDE08A.2090406@st.com> <201105260835.45559.hverkuil@xs4all.nl>
In-Reply-To: <201105260835.45559.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/26/2011 12:05 PM, Hans Verkuil wrote:
> On Thursday, May 26, 2011 07:09:30 vipul kumar samar wrote:
>> Hello,
>>
>> On 05/25/2011 06:13 PM, Martin Bugge (marbugge) wrote:
>>> Hello
>>>
>>> To be honest I became a bit disengaded after all the discussion.
>>>
>>> What caused me a lot of problems was the request for AV link support
>>> (which is used in SCART connectors).
>>> Something I never plan to implement.
>>>
>>> But after the "v4l2 Warsaw Brainstroming meeting" it was sort of approved.
>>>
>>> It only need to be reworked to be a subdev level api.
>>> (for that I need some help from Hans Verkuil)
>>>
>>> But it is great that someone else also need an API for this.
>>> I include the latest version here so you can see if you agree, and
>>> together we will get it in.
>>>
>>
>> Yes, sure.
>>
>>> We currently have two drivers which uses this API for CEC.
>>>
>>> * Analog Devices adv7604
>>>
>>> * TMS320DM8x
>>>
>>
>> i want to see source code of these two drivers.From where i can get
>> source code of these drivers??
>
> The adv7604 driver is here:
>
> http://git.linuxtv.org/hverkuil/cisco.git?a=shortlog;h=refs/heads/cobalt
>
> But this tree hasn't been updated in quite some time and doesn't contain the
> CEC support. I need to work on this anyway today so I'll see if I can get
> this tree in sync with our internal tree.
>
> The other driver we can't release as open source. It will eventually become
> available, though.
>
> Regards,
>
>        Hans

Hello Hans,

Once i go through this driver then we will discuss it in more detail.
Thanks for your support.

Regards
Vipul Kumar Samar

>
>>
>> Thanks and Regards
>> Vipul Kumar Samar
>>
>>> At least the adv7604 is planned to be upstreamed.
>>>
>>> Best regards
>>> Martin Bugge
>>>
>>>
>>> On 05/25/2011 01:52 PM, vipul kumar samar wrote:
>>>> Hello,
>>>>
>>>> I am working on HDMI-CEC and planning to implement it in v4l2
>>>> framework.I came to know that a RFC is going on for the same driver.
>>>>
>>>> I want to know is their any friezed version of that RFC or discussion
>>>> is still going on?? Is it included in kernel??
>>>>
>>>> Thanks and Regards
>>>> Vipul Kumar Samar
>>>
>>>
>>
>>
>>
> .
>
