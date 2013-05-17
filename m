Return-path: <linux-media-owner@vger.kernel.org>
Received: from s250.sam-solutions.net ([217.21.49.219]:57116 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3EQMXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 08:23:16 -0400
Message-ID: <5196212F.40507@sam-solutions.com>
Date: Fri, 17 May 2013 15:23:11 +0300
From: Andrei Andreyanau <a.andreyanau@sam-solutions.com>
Reply-To: a.andreyanau@sam-solutions.com
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9p031 shows purple coloured capture
References: <5194D9AB.3030608@sam-solutions.com> <Pine.LNX.4.64.1305162142210.27706@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1305162142210.27706@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi,

On 05/16/2013 10:46 PM, Guennadi Liakhovetski wrote:
> On Thu, 16 May 2013, Andrei Andreyanau wrote:
>
>> Hi, Laurent,
>> I have an issue with the mt9p031 camera. The kernel version I use
>> uses soc camera framework as well as camera does. And I have
>> the following thing which appears randomly while capturing the
>> image using gstreamer. When I start the capture for the first time, it
>> shows the correct image (live stream). When I stop and start it again
>> it may show the image in purple (it can appear on the third or fourth
>> time). Or it can show the correct image every time I start the capture.
>> Do you have any idea why it appears so?
> Wrong clock or *sync polarity selection? Which leads to random 
> start-of-frame misplacement?
>
Do you mean pixel clock polarity? If so, I checked it - with it being
inverted -
the image capture goes well (purple color also appears from time to time),
but in the case it is not inverted I see a noise on the screen.

Anyway, I found one solution that lead me to this:
I have a correct image on the LCD display, connected via HDMI, I have a
correct
video stream that was captured into the file, but I get the purple-coloured
live stream on the display, connected via LVDS port on the board (for now -
every time I capture the stream from the camera sensor).
So I used the register 0x0B (Restart), bit 0 (abandon the current frame and
restart from the first row) set to 1 each time the function s_stream is
called.
What do you think?

By the way, this register is not used in the latest kernel.

Regards,
Andrei
