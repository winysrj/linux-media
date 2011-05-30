Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1E3NP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 09:15:57 -0400
Message-ID: <4DE39889.7040105@redhat.com>
Date: Mon, 30 May 2011 10:15:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DE24A84.5030909@redhat.com> <4DE25E6A.5080900@redhat.com> <201105300914.59674.hverkuil@xs4all.nl>
In-Reply-To: <201105300914.59674.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-05-2011 04:14, Hans Verkuil escreveu:
> On Sunday, May 29, 2011 16:55:38 Mauro Carvalho Chehab wrote:
>> Em 29-05-2011 10:30, Hans de Goede escreveu:

>> IMO, we should be reviewing this policy, for example, to name video output
>> devices as "video_out", and webcams as "webcam", and let udev to create
>> aliases for the old namespace.
> 
> What categories of video devices do we have?
> 
> - video (TV, HDMI et al) input
> - video output
> - sensor input (webcam-like)
> - mem2mem devices (input and/or output)
> - MPEG (compressed video) input
> - MPEG (compressed video) output


> - Weird: ivtv still captures audio over a video node, there may be others.

pvrusb2 also does that. Both are abusing of the V4L2 API: they should be using
alsa for audio output. I think that alsa provides support for mpeg-encoded
audio.

> 
> My understanding is that in practice the difference between webcam and video
> input isn't that important (since you could hook up a camera to a video input
> device I'm not even sure that you should make that difference). 

It is relevant for the users. For example, when you have for example a notebook 
with its camera, and a TV harware, users and applications may want to know.
For example, a multimedia conference application will choose the webcam by
default.

> But input,
> output, mem2mem is important. 

Yes.

> And so is compressed vs uncompressed.

Not really. There are several devices that provides compressed streams, like
most gspca hardware. Several of them allow you to select between a compressed
or a not-compressed formats.

What you're meaning by "compressed" is, in fact, input/outputs for the mpeg
encoder itself. So, I'd say that we have 2 different types of nodes there:
"encoder" and "decoder".

> Creating video_out and video_m2m nodes doesn't seem unreasonable to me.
> 
> I don't know how to signal compressed vs uncompressed, though. Currently
> this is done through ENUM_FMT so it doesn't lend itself to using a different
> video node name, even though in practice video device nodes do not switch
> between compressed and uncompressed.

Just ivtv (and maybe cx18?) uses different devices for compressed stuff. All
other drivers use VIDIOC*FMT for it.

> But that's the case today and may not
> be true tomorrow. The whole UVC H.264 mess that Laurent is looking into
> springs to mind.
> 
>>>> Grouping the discovered information together is not hard, but there's one
>>>> issue if we'll be opening devices to retrieve additional info: some devices
>>>> do weird stuff at open, like retrieving firmware, when the device is waking
>>>> from a suspend state. So, the discover procedure that currently happens in
>>>> usecs may take seconds. Ok, this is, in fact, a driver and/or hardware trouble,
>>>> but I think that having a separate method for it is a good idea.
>>>
>>> WRT detection speed I agree we should avoid opening the nodes where possible,
>>> so I guess that also means we may want a second "give me more detailed info"
>>> call which an app can do an a per device (function) basis, or we could
>>> leave this to the apps themselves.
>>
>> I'm in favour of a "more detailed info" call.
> 
> +1
> 
> Regards,
> 
> 	Hans

