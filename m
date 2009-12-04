Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:29646 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZLDFRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 00:17:44 -0500
Received: by fg-out-1718.google.com with SMTP id e21so995122fga.1
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 21:17:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912032021t3232e391qc3a4c840529f7ed6@mail.gmail.com>
References: <44c6f3de0912032000g3aa2a7cbla26b5132d229a6ac@mail.gmail.com>
	 <829197380912032021t3232e391qc3a4c840529f7ed6@mail.gmail.com>
Date: Fri, 4 Dec 2009 00:17:50 -0500
Message-ID: <829197380912032117h1d01f80akf3b1ed7d81e3c6bf@mail.gmail.com>
Subject: Re: Hauppage hvr-950q au0828 transfer problem affecting audio and
	perhaps video
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: John S Gruber <johnsgruber@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 3, 2009 at 11:21 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Dec 3, 2009 at 11:00 PM, John S Gruber <johnsgruber@gmail.com> wrote:
>> I have problems with my audio that I've tracked down to the transfer
>> of audio from the au0828
>> in my hvr-950Q. I spotted the following comment about green screen
>> detection and I wonder
>> if it might be related.
>>
>> drivers/media/video/au0828/au0828-video.c:
>>
>>        /* Workaround for a bug in the au0828 hardware design that sometimes
>>           results in the colorspace being inverted */
>>
>> The problem is that sound/usb/usbaudio.c assumes that each urb data
>> field contains an integer
>> number of audio frames (aka audio slots), in this case a integer
>> number of left channel-right
>> channel pairs. About 12 times a second for my device a urb doesn't.
>> This causes a flutter noise
>> with non-quiet audio that contains a difference between the channels.
>>
>> I found this by using audacity to look at wave forms and a usb trace
>> to see the problematic urb's.
>> I've confirmed by relaxing the constraint in sound/usb/usbaudio.c with
>> a patch and can confirm that
>> it clears up the audio.
>>
>>
>> Is the code comment at the top related to my problem?
>>
>> More importantly, is there the possibility of setting up the transfer
>> differently so that
>> audio slots aren't split between urbs?
>>
>>
>> From what I have read in the spec I believe the split of the audio
>> slots between urb's is non-
>> conformant. Therefore I think it would be a mistake to change the
>> default behaviour of
>> usbaudio.c since, as it is now,usbaudio.c won't swap channels in the
>> case of dropped urbs.
>> It would be optimal if the hvr-950q could be set up to conform by not
>> splitting audio slots.
>>
>> I think the problem also occurs for video when blue will turn to pink
>> for a flash until the top
>> of frame resyncs things up--because of the corresponding swap of UY
>> with VY. This seems
>> to be related to how busy my system is and what usb slot I'm using on
>> my laptop. Again
>> I could see in a usb trace the urb's with data_lengths such that UY
>> would be split from the
>> corresponding VY. The video transfer is a straight byte copy so
>> ordinarily this isn't a
>> problem but would be if an abnormally sized urb were dropped and the
>> device and host
>> were to get out of sync regarding V and U.
>>
>> I also have caught an occasional odd number of bytes transferred in
>> traces, which requires
>> the drop of incomplete samples in usbaudio.c. I wonder if this is
>> related to the green screen
>> problem on video from the top comment.
>>
>> The easiest way to reproduce the audio problem is to use the composite
>> video input but only
>> hook up either the left or the right audio. With earphonesyou can hear
>> the audio rapidly
>> go from ear to ear.
>>
>> Thanks for those on the list for their hard work on getting devices
>> such as this to work. I'd
>> appreciate any answers, comments, corrections, or information.
>
> Hi John,
>
> I have actually actively debugging the au0828 audio this evening.  The
> comment you referred to (which I wrote) has to do with the delivery of
> the UYVY data from the demodulator to the au0828 bridge, which can
> cause the start of the stream to be off-by-one (the pink/green you see
> is the colorspace inverted when the decoder loses sync).
>
> It is unrelated to audio.
>
> I'm working an issue now where the audio keeps dropping out.  If you
> want to show me the code change you did to usbaudio.c, it might give
> me a better understand the issue.

I am definitely seeing what you are saying with regards to the channel
flipping back and forth.  Do you know what size URBs are being
delivered?  If you've got a hacked up version of usbaudio.c, how about
adding a printk() line which dumps out the URB size and send me a
dump?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
