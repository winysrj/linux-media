Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47302 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0EWRd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 13:33:29 -0400
Received: by wyb29 with SMTP id 29so1005876wyb.19
        for <linux-media@vger.kernel.org>; Sun, 23 May 2010 10:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005231320.13560.hverkuil@xs4all.nl>
References: <AANLkTineD8GCtG1OD4WQahW7zS23IxQDx7XmnAsrVSqs@mail.gmail.com>
	 <1274542506.2255.55.camel@localhost>
	 <201005221821.32711.mail01@iarmst.co.uk>
	 <201005231320.13560.hverkuil@xs4all.nl>
Date: Sun, 23 May 2010 18:32:48 +0100
Message-ID: <AANLkTinx94ynpOe5fu6fUomqoyu9eTkJSMfSTT83CbmV@mail.gmail.com>
Subject: Re: VIDIOC_G_STD, VIDIOC_S_STD, VIDIO_C_ENUMSTD for outputs
From: Andre Draszik <v4l2@andred.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, May 23, 2010 at 12:20 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Saturday 22 May 2010 19:21:32 Ian Armstrong wrote:
>> On Saturday 22 May 2010, Andy Walls wrote:
>> > On Sat, 2010-05-22 at 15:06 +0100, Andre Draszik wrote:
>> > Some thoughts:
>> >
>> > 1. to me it appears that the ivtv driver looks like it ties the output
>> > standard to the input standard currently (probably due to some firmware
>> > limitation).  This need not be the case in general.

That's what I think, why should the API enforce input and output
standard to be the same? An application or user might decide to do so,
if they want to, but it seems like a strange limitation.

>> The ivtv limitation is the driver and not the firmware.
>
> Correct.

So, why limit the API because of one driver's limitations?

>> > 2. currently the ivtv driver uses sepearte device nodes for input device
>> > and an output device.  If bridge drivers maintain that paradigm, then
>> > separate ioctl()s for S_STD, G_STD, and ENUMSTD are likely not needed.

Here http://www.stlinux.com/download/updates.php?r=2.3;u=stlinux23-host-stmfb-source-3.1_stm23_0031-1.src.rpm
we don't use separate nodes for input and output.

>> This is how my patched version works, talk to an input device for the input &
>> an output device for the output. However, from my reading of the specs I do
>> get the impression this is not the 'correct' way to do this and it should
>> really be a separate ioctl. I don't know what other cards, if any, support
>> mixed input & output standards or how they handle it.

That's what I'm saying :-) And it works perfectly (the API is great!
:-) except for this minor issue.

> The reason it was never done for bridge drivers is twofold:
>
> 1) No one ever needed it. Why would you want to select one format for input
> and another for output?

Why not? Capturing in one mode and outputting in a different is not
uncommon, at least in embedded (STB) environments. Think e.g. of an
AV-Receiver and such things.

> Other than debugging this never happens for the sort
> of drivers we have now.

Yes, you have a point here that above mentioned driver is not part of
the linux tree, but still it seems like an issue that could easily be
solved. And others might profit, too - surely more hardware exists
that can handle input != output.

> So selecting e.g. PAL and have it change both input
> and output is actually what most people expect.

What if your source can not output PAL and your sink only accepts PAL?
Most people would expect that to work anyway.

> 2) Do we really need to make new ioctls? Here it becomes hairy. According to

At the moment there is no requirement in the spec to say that input
and output devices must have a separate node, and all remaining
(existing) ioctls are perfectly suited for having a single device
node.
Not having separate output controls would implicitly create such a
requirement, though.


Cheers,
Andre'
