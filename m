Return-path: <mchehab@pedra>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:52578 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab1ECMCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 08:02:22 -0400
Message-ID: <4DBFEEBA.4010005@st.com>
Date: Tue, 3 May 2011 17:32:02 +0530
From: vipul kumar samar <vipulkumar.samar@st.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	<laurent.pinchart@ideasonboard.com>, <m.szyprowski@samsung.com>
Subject: Re: Query: Implementation of overlay on linux
References: <4DBE8FDB.5010506@st.com> <201105021520.22842.hansverk@cisco.com>
In-Reply-To: <201105021520.22842.hansverk@cisco.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,
On 05/02/2011 06:50 PM, Hans Verkuil wrote:
> On Monday, May 02, 2011 13:04:59 vipul kumar samar wrote:
>> Hello,
>>
>> I am working on LCD module and I want to implement two overlay windows
>> on frame buffer. I have some queries related to this:
>
> You mean capture overlay windows? E.g. you want to capture from a video input
> and have the video directly rendered in the framebuffer?
>

Our LCD driver is developed on frame buffer interface.Now i want to 
implement 2 overlay window support on the same driver.I saw the solution 
of frame buffer emulator provided on mailing list. But i am little bit 
confused.

My understanding is Frame buffer emulator provides a wrapper over V4L2 
framework based driver and provide a single buffer solution.But my 
condition is reverse i want to use V4L2 over frame buffer.

Is it fruit full to rearrange frame buffer based driver in v4l2 
framework and then implement overlay support over it??
Is there any simple way to use V4L2 frame work over frame buffer??

Thanks and Regards
Vipul Samar


> The "Video Overlay Interface" section in the V4L2 specification describes how
> to do that, but it also depends on whether the V4L2 driver in question
> supports that feature.
>
> It might be that you mean something else, though.
>
> Regards,
>
> 	Hans
>
>> 1. Can any body suggest me how to proceed towards it??
>> 2. Is their any standard way to use frame buffer ioctl calls??
>> 3. If i have to define my own ioctls then how application manage it??
>>
>>
>> Thanks and Regards
>> Vipul Samar
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> .
>

