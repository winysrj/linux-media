Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1KNLZvA029857
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 18:21:35 -0500
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1KNL1hU016145
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 18:21:02 -0500
Message-ID: <47BCB5DB.8000800@kaiser-linux.li>
Date: Thu, 21 Feb 2008 00:20:59 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: "H. Willstrand" <h.willstrand@gmail.com>
References: <47BC7E91.6070303@kaiser-linux.li>	
	<175f5a0f0802201208u4bca35afqc0291136fe2482b@mail.gmail.com>	
	<47BC8BFC.2000602@kaiser-linux.li>	
	<175f5a0f0802201232y6a1bfc53u4fe92fede3abcb34@mail.gmail.com>	
	<47BC90CA.1000707@kaiser-linux.li>	
	<175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>	
	<47BC9788.7070604@kaiser-linux.li>
	<20080220215850.GA2391@daniel.bse>	
	<47BCA5BA.20009@kaiser-linux.li>
	<175f5a0f0802201441n5ea7bb58rdfa70663799edcad@mail.gmail.com>
In-Reply-To: <175f5a0f0802201441n5ea7bb58rdfa70663799edcad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: V4L2_PIX_FMT_RAW
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

H. Willstrand wrote:
> On Wed, Feb 20, 2008 at 11:12 PM, Thomas Kaiser
> <linux-dvb@kaiser-linux.li> wrote:
>> Daniel Glöckner wrote:
>>  > On Wed, Feb 20, 2008 at 10:11:36PM +0100, Thomas Kaiser wrote:
>>  >> H. Willstrand wrote:
>>  >>> Well, it can go ugly if one piece of hardware supports several "raw"
>>  >>> formats, they need to be distinct. And in the end of the day the V4L2
>>  >>> drivers might consist of several identical "raw" formats which then
>>  >>> aren't consolidated.
>>  >> I don't really understand what you try to say here.
>>  >
>>  > Think about an analog TV card.
>>  > In the future there might be one where RAW could mean either sampled
>>  > CVBS or sampled Y/C. The card may be able to provide the Y/C in planar
>>  > and packed format. It may be capable of 16 bit at 13.5Mhz and 8 bit at
>>  > 27Mhz, ...
>>  >
>>  > If we start defining raw formats, there needs to be a way to choose
>>  > between all those variants without defining lots of additional pixel
>>  > formats.
>>  >
>>  > Maybe an ioctl VIDIOC_S_RAW where one passes a number to select the
>>  > variant. An application would then have to check the driver and version
>>  > field returned by VIDIOC_QUERYCAP to determine the number to pass. This
>>  > way drivers may freely assign numbers to their raw formats.
>>
>>  Yeh, That's something I mean.
>>
> 
> Okay, suppose we have pixel formats and raw formats. Comparing with
> digital cameras raw usually means non processed image in a proprietary
> format. What do we mean here?

I talk about webcams. But It looks like you don't get the point.
A ISOC stream can be received, then we forward this to user space! That's it.

This has nothing to do with pixel format, just deliver  the stream from the cam 
to user space, That's all what I won't.
I think raw means raw, "not manipulated"! Oder in Deutsch Roh equals raw, which 
means "not touched".

You get the point?

I just would like to have a way to get the stream "as it is" to user spcae.

Thomas


-- 
http://www.kaiser-linux.li

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
