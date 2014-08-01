Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2670 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaHAKOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 06:14:33 -0400
Message-ID: <53DB6877.1070001@xs4all.nl>
Date: Fri, 01 Aug 2014 12:14:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv1 02/12] vivid.txt: add documentation for the vivid driver.
References: <1406730195-64365-1-git-send-email-hverkuil@xs4all.nl>	 <1406730195-64365-3-git-send-email-hverkuil@xs4all.nl> <1406834177.1912.25.camel@palomino.walls.org>
In-Reply-To: <1406834177.1912.25.camel@palomino.walls.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2014 09:16 PM, Andy Walls wrote:
> On Wed, 2014-07-30 at 16:23 +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The vivid Virtual Video Test Driver helps testing V4L2 applications
>> and can emulate V4L2 hardware. Add the documentation for this driver
>> first.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  Documentation/video4linux/vivid.txt | 1108 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 1108 insertions(+)
>>  create mode 100644 Documentation/video4linux/vivid.txt
>>
>> diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
>> new file mode 100644
>> index 0000000..2dc7354
>> --- /dev/null
>> +++ b/Documentation/video4linux/vivid.txt
>> @@ -0,0 +1,1108 @@
>> +vivid: Virtual Video Test Driver
>> +================================
> 
>> +
>> +Section 8: Software Defined Radio Receiver
>> +------------------------------------------
>> +
>> +The SDR receiver has three frequency bands for the ADC tuner:
>> +
>> +	- 300 kHz
>> +	- 900 kHz - 2800 kHz
>> +	- 3200 kHz
>> +
>> +The RF tuner supports 50 MHz - 2000 MHz.
>> +
>> +The generated data contains sinus and cosinus signals.
>> +
> 
> In (American) English the names are "sine" and "cosine" for sin(x) and
> cos(x).

I knew that. Really :-)

One of the rare (I think) cases where my native Dutch interfered with English.

> 
> Maybe say:
> 
> "The generated data contains the In-phase and Quadrature components of a
> 1 kHz tone that has an amplitude of sqrt(2)."
> 
> FWIW, the signals are the In-phase and Quadrature components of the
> signal A*cos(2*pi*f + phi), where f = 1 kHz, A = sqrt(2), and phi =
> -pi/4
> 
>> +
>> +Section 15: Some Future Improvements
>> +------------------------------------
>> +
>> +Just as a reminder and in no particular order:
>> +
>> +- Add a virtual alsa driver to test audio
>> +- Add virtual sub-devices and media controller support
>> +- Some support for testing compressed video
>> +- Add support to loop raw VBI output to raw VBI input
>> +- Fix sequence/field numbering when looping of video with alternate fields
>> +- Add support for V4L2_CID_BG_COLOR for video outputs
>> +- Add ARGB888 overlay support: better testing of the alpha channel
>> +- Add custom DV timings support
>> +- Add support for V4L2_DV_FL_REDUCED_FPS
>> +- Improve pixel aspect support in the tpg code by passing a real v4l2_fract
>> +- Use per-queue locks and/or per-device locks to improve throughput
>> +- Add support to loop from a specific output to a specific input across
>> +  vivid instances
>> +- Add support for VIDIOC_EXPBUF once support for that has been added to vb2
>> +- The SDR radio should use the same 'frequencies' for stations as the normal
>> +  radio receiver, and give back noise if the frequency doesn't match up with
>> +  a station frequency
>> +- Improve the sinus generation of the SDR radio.
> 
> Maybe a lookup table, containing the first quarter wave of cos() from 0
> to pi/2 in pi/200 steps, and then linear interpolation for cos() of
> angles in between those steps.  You could go with a larger lookup table
> with finer grained steps to reduce the approximation errors.  A lookup
> table with linear interpolation, I would think, requires fewer
> mutliplies and divides than the current Taylor expansion computation.

Yeah, I had plans for that. There actually is a sine-table already in vivid-tpg.c
since I'm using that to implement Hue support.

Regards,

	Hans

> 
> 
>> +- Make a thread for the RDS generation, that would help in particular for the
>> +  "Controls" RDS Rx I/O Mode as the read-only RDS controls could be updated
>> +  in real-time.
> 
> Regards,
> Andy
> 

