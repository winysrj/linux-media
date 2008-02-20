Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1KMCkvU014934
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 17:12:46 -0500
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1KMCCqL002667
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 17:12:13 -0500
Message-ID: <47BCA5BA.20009@kaiser-linux.li>
Date: Wed, 20 Feb 2008 23:12:10 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Thomas Kaiser <linux-dvb@kaiser-linux.li>,
	Linux and Kernel Video <video4linux-list@redhat.com>
References: <47BC7E91.6070303@kaiser-linux.li>
	<175f5a0f0802201208u4bca35afqc0291136fe2482b@mail.gmail.com>
	<47BC8BFC.2000602@kaiser-linux.li>
	<175f5a0f0802201232y6a1bfc53u4fe92fede3abcb34@mail.gmail.com>
	<47BC90CA.1000707@kaiser-linux.li>
	<175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>
	<47BC9788.7070604@kaiser-linux.li>
	<20080220215850.GA2391@daniel.bse>
In-Reply-To: <20080220215850.GA2391@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: 
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

Daniel Glöckner wrote:
> On Wed, Feb 20, 2008 at 10:11:36PM +0100, Thomas Kaiser wrote:
>> H. Willstrand wrote:
>>> Well, it can go ugly if one piece of hardware supports several "raw"
>>> formats, they need to be distinct. And in the end of the day the V4L2
>>> drivers might consist of several identical "raw" formats which then
>>> aren't consolidated.
>> I don't really understand what you try to say here.
> 
> Think about an analog TV card.
> In the future there might be one where RAW could mean either sampled
> CVBS or sampled Y/C. The card may be able to provide the Y/C in planar
> and packed format. It may be capable of 16 bit at 13.5Mhz and 8 bit at
> 27Mhz, ...
> 
> If we start defining raw formats, there needs to be a way to choose
> between all those variants without defining lots of additional pixel
> formats.
> 
> Maybe an ioctl VIDIOC_S_RAW where one passes a number to select the
> variant. An application would then have to check the driver and version
> field returned by VIDIOC_QUERYCAP to determine the number to pass. This
> way drivers may freely assign numbers to their raw formats.

Yeh, That's something I mean.

> 
> Application writers would need to look into all drivers' docs/sources to
> find the possible values. They would need to do it anyway to see if they
> can decode the raw format.

That's why we need a user space library to handle all this strange "unknown" 
streams.

When the application can not decode (or does not know) the stream, just get it 
to the decoding lib. When the stream is known, you get a decoded picture back. 
If not you get an error.

Thomas

> 
>   Daniel
> 
> P.S.: If my mail doesn't reach the list, blame its spam filter
> 


-- 
http://www.kaiser-linux.li

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
