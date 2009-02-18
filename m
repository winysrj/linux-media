Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:52282 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZBRM6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 07:58:04 -0500
Message-ID: <499C05D8.10303@kaiser-linux.li>
Date: Wed, 18 Feb 2009 13:58:00 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
References: <20090217200928.1ae74819@free.fr>	<499B1180.6020600@kaiser-linux.li> <20090218102553.608e026c@free.fr>
In-Reply-To: <20090218102553.608e026c@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Tue, 17 Feb 2009 20:35:28 +0100
> Thomas Kaiser <v4l@kaiser-linux.li> wrote:
>> Jean-Francois Moine wrote:
>>> BTW, I am coding the subdriver of a new webcam, and I could not find
>>> how to decompress the images. It tried many decompression functions,
>>> those from the v4l library and most from libgphoto2 without any
>>> success. Does anyone know how to find the compression algorithm?
>> Hello Jean-Francois
>>
>> Do you have some more information about the cam and the stream?
>> Do you know the frame header?
>> Any idea what the compression should be?
>> Can you provide a raw stream from the cam?
> 
> Hello Thomas,
> 
> The cam is a Tascorp 17a1:0118. I have USB traces. Starting the webcam
> is easy, and so is extracting the images (0x02 + 0xa0/0xa1 at start of
> image packets and 0x5a + 0xa5 for end of image with average luminosity).
> 
> I attach an image I extracted by hand from the trace, removing the 2
> bytes of the packets. If it can help, I may send you the whole USB trace
> (3 Mb) and/or other images.
> 
> Cheers.
> 

Hello Jean-Francois

Thanks, for the frame (or frames?). What resolution did you use while 
recording this stream?
Can you put your USB trace somewhere on the net where I can download it?

When I was guessing the streams of webcams, I used to get the sensor 
into saturation -> complete white picture. So you know how the decoded 
picture should look like ;-)

Actually, it is quite easy to get a webcam sensor into saturation. Just 
remove the lens of the cam an put a light in front of it. Check in 
Windoz if the picture is really complete white and then record a stream 
in Linux. Now, you should get a very homogeneous stream. Look at it and ....

I hope you got the idea?

Thomas

