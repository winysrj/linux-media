Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1KLCCLo005429
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 16:12:12 -0500
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1KLBdZ5016697
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 16:11:39 -0500
Message-ID: <47BC9788.7070604@kaiser-linux.li>
Date: Wed, 20 Feb 2008 22:11:36 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <47BC7E91.6070303@kaiser-linux.li>	
	<175f5a0f0802201208u4bca35afqc0291136fe2482b@mail.gmail.com>	
	<47BC8BFC.2000602@kaiser-linux.li>	
	<175f5a0f0802201232y6a1bfc53u4fe92fede3abcb34@mail.gmail.com>	
	<47BC90CA.1000707@kaiser-linux.li>
	<175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>
In-Reply-To: <175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

H. Willstrand wrote:
> On Wed, Feb 20, 2008 at 9:42 PM, Thomas Kaiser
> <linux-dvb@kaiser-linux.li> wrote:
>> H. Willstrand wrote:
>>  > On Wed, Feb 20, 2008 at 9:22 PM, Thomas Kaiser
>>  > <linux-dvb@kaiser-linux.li> wrote:
>>  >> H. Willstrand wrote:
>>  >>  > On Wed, Feb 20, 2008 at 8:25 PM, Thomas Kaiser
>>  >>  > <linux-dvb@kaiser-linux.li> wrote:
>>  >>  >> Why is V4L2_PIX_FMT_RAW not included as a pixel format in V4l2?
>>  >>  >>
>>  >>  >>  I would like to just forward the stream from my webcam "as it is" to user space .
>>  >>  >>
>>  >>  >>  V4L2_PIX_FMT_RAW looks as it is the right thing I need.
>>  >>  >>
>>  >>  >
>>  >>  > V4L2 drivers should not perform any video transformations, the driver
>>  >>  > provides user space with hardware supported formats.
>>  >>
>>  >>  Ok, so, I need a entry for Pixart chips.
>>  >>  PAC207: a line based coding algo.
>>  >>  PAC7311: the interpretation of JPEG from Pixart
>>  >>  PAC7302: the _new_  interpretation of JPEG from Pixart
>>  >>
>>  >>  V4L2_PIX_FMT_RAW would make my live easier.
>>  >>
>>  >>  The option to forward the stream "as it is" would be really nice. When the
>>  >>  manufacture of some video streaming devices (like webcams) do their own thing,
>>  >>  you can forward the raw stream and the user application can take care of the
>>  >>  decoding of the stream.
>>  >>
>>  >>  For me it looks not like such a bad idea!!!???
>>  >>
>>  >
>>  > Yes, it might be a good idea to add something like V4L2_PIX_FMT_PAC207, etc.
>>  > This is anyhow the case with the PWC family.
>>
>>  I think the better is to just forward the stream to userspace.
>>  Then we have to make a lib which can be called from all these video application
>>  around to decode the stream.
>>
>>  Somebody talked already about this on the list.
>>
>>  When the cam is able to send a stream in a good known format it is no problem to
>>  handle this with the right V4L2_PIX_FMT_..., but if not, we need a "official"
>>  way to get this "devil" stream to user space!
>>
> 
> Well, it can go ugly if one piece of hardware supports several "raw"
> formats, they need to be distinct. And in the end of the day the V4L2
> drivers might consist of several identical "raw" formats which then
> aren't consolidated.
> 
> Harri

I don't really understand what you try to say here.
I want to have the stream forwarded "as it is" to user space. Then the v4l2 
driver even have not to know what kind of stream this is!
We just forward the stream (again) "as it is" to user space.
Now, the user space application (viewer app, skype or what ever) has to decide 
if they can handle the stream.

Thomas

PS: Why do you answer OFF-LIST? I think it is a nice topic to discussed with 
everyone on the list.


-- 
http://www.kaiser-linux.li

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
