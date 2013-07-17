Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:51199 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3GQIkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 04:40:47 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: MT9D131 context switching [was RE: width and height of JPEG
 compressed images]
Date: Wed, 17 Jul 2013 08:40:43 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F0536168D31@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F05361689EE@server10.irisys.local>
 <20130716235805.GA11369@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130716235805.GA11369@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 17 July 2013 00:58 Sakari Ailus wrote:
> On Mon, Jul 15, 2013 at 09:30:33AM +0000, Thomas Vajzovic wrote:
>> On 10 July 2013 20:44 Sylwester Nawrocki wrote:
>>> On 07/07/2013 10:18 AM, Thomas Vajzovic wrote:
>>>> On 06 July 2013 20:58 Sylwester Nawrocki wrote:
>>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>>
>>>>>> I am writing a driver for the sensor MT9D131.
>>>
>>> As a side note, looking at the MT9D131 sensor datasheet I can see it
>>> has preview (Mode A) and capture (Mode B) modes. Are you also
>>> planning adding proper support for switching between those modes ?
>>> I'm interested in supporting this in standard way in V4L2, as lot's
>>> of sensors I have been working with also support such modes.
>>
>> This camera has more like three modes:
>>
>>
>> preview (context A) up to 800x600, up to 30fps, YUV/RGB
>>
>> capture video (context B) up to 1600x1200, up to 15fps, YUV/RGB/JPEG
>>
>> capture stills (context B) up to 1600x1200, sequence of 1 or more
>> frames with no fixed timing, YUV/RGB/JPEG
>>
>>
>> I have implemented switching between the first two of these, but the
>> choice is forced by the framerate, resolution and format that the user
>> requests, so I have not exposed any interface to change the context,
>> the driver just chooses the one that can do what the user wants.
>>
>> As for the third mode, I do not currently plan to implement it, but if
>> I was going to then I think the only API that would be required is
>> V4L2_MODE_HIGHQUALITY in v4l2_captureparm.capturemode.
>
> Is there a practical difference in video and still capture in this case?

I haven't read the docs fully because I don't use that mode, but AFAIK:

If you select capture stills then it takes a few frames and then changes
mode back to preview on its own.  As it is changing modes then the auto-
exposure and gain does "clever" things.  I think it might discard or mask
all but one of the frames to help you just get the single best one. This
mode also supports triggering a synchronized flash light in hardware and
I don't know what else.

Regards,
Tom
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
