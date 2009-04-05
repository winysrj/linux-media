Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:53594 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZDESs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 14:48:57 -0400
Date: Sun, 5 Apr 2009 14:02:00 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: =?ISO-8859-15?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: Possibility of changing the current pixelformat on the
 fly
In-Reply-To: <20090405195219.08e63cea@free.fr>
Message-ID: <alpine.LNX.2.00.0904051341120.30987@banach.math.auburn.edu>
References: <49D7C17B.80708@gmail.com> <20090405195219.08e63cea@free.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-1181250303-1238958120=:30987"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-1181250303-1238958120=:30987
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT



On Sun, 5 Apr 2009, Jean-Francois Moine wrote:

> On Sat, 04 Apr 2009 22:22:19 +0200
> Erik Andrén <erik.andren@gmail.com> wrote:
> 	[snip]
>> When flipping the image horizontally, vertically or both, the sensor
>> pixel ordering changes. In the m5602 driver I was able to compensate
>> for this in the bridge code. In the stv06xx I don't have this
>> option. One way of solving this problem is by changing the
>> pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
>> format. When a vertical flip is required, change the format to
>> V4L2_SBGGR8.
>>
>> My current understanding of libv4l is that it probes the pixelformat
>>   upon device open. In order for this to work we would need either
>> poll the current pixelformat regularly or implement some kind of
>> notification mechanism upon a flipping request.
>>
>> What do you think is this the right way to go or is there another
>> alternative.
>
> Hi Erik,
>
> I saw such a problem in some other webcams. When doing a flip, the
> sensor scans the pixels in the reverse order. So,
> 	R G R G
> 	G B G B
> becomes
> 	B G B G
> 	G R G R
>
> The solution is to start the scan one line lower or higher for VFLIP
> and one pixel on the left or on the right for HFLIP.
>
> May you do this with all the sensors of the stv06xx?

That is a very clever solution -- if the hardware will do such a thing. I 
can not speak for the stv06xx cameras, of course. But I am pretty sure it 
is impossible for the sq905 cameras. Therefore it is not a universal 
solution. If it can be done, great. But it seems to me that the general 
way to do this would be just to adjust the Bayer tiling to be in accord 
with the flipping after it is done (one of the possibilities already 
mentioned above).

The problem which I would address is that the need for image flipping 
ought to be handled in a standard way, if possible. The sq905 cameras 
(with which I have been directly concerned) do give rise to similar 
problems. The big difference is that there is no way with an sq905 to tell 
the camera to do any flipping in hardware, nor to shift the pixel reading 
one space over or down. Hence my obvious interest in seeing this problem 
analysed completely, and in seeing the best solution adopted. One possible 
way to do that would be to have the choice for the pixel format to reflect 
what it ought to be, after any flipping has taken place. From this point 
of view, it would not matter if the flipping is done in V4L or in 
hardware, before the data has left the camera. It would only be necessary 
to agree that any required flipping takes place first, and then the Bayer 
interpolation afterwards.

Theodore Kilgore
---863829203-1181250303-1238958120=:30987--
