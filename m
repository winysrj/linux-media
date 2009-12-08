Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41211 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538AbZLHEUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 23:20:01 -0500
Received: by fxm5 with SMTP id 5so5807229fxm.28
        for <linux-media@vger.kernel.org>; Mon, 07 Dec 2009 20:20:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912041526r764a0deeyb64910a22e92d75d@mail.gmail.com>
References: <44c6f3de0912041415r54d8ab6fq486f2a82edb91a68@mail.gmail.com>
	 <829197380912041526r764a0deeyb64910a22e92d75d@mail.gmail.com>
Date: Mon, 7 Dec 2009 23:20:06 -0500
Message-ID: <829197380912072020s79199b84g20dbc341e4d231e1@mail.gmail.com>
Subject: Re: [PATCH] sound/usb: Relax urb data alignment restriciton for
	HVR-950Q only
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: John S Gruber <johnsgruber@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 4, 2009 at 6:26 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Fri, Dec 4, 2009 at 5:15 PM, John S Gruber <johnsgruber@gmail.com> wrote:
>> Addressing audio quality problem.
>>
>> In sound/usb/usbaudio.c, for the Hauppage HVR-950Q only, change
>> retire_capture_urb to copy the entire byte stream while still counting
>> entire audio frames. urbs unaligned on channel sample boundaries are
>> still truncated to the next lowest stride (audio slot) size to try to
>> retain channel alignment in cases of data loss over usb.
>>
>> With the HVR950Q the left and right channel samples can be split between
>> two different urbs. Throwing away extra channel samples causes a sound
>> quality problem for stereo streams as the left and right channels are
>> swapped repeatedly.
> <snip>
>
> Hello John,
>
> Thanks for taking the time to dig into this.  I will try to review
> your patch this weekend (in conjunction with the spec).
>
> It's worth noting that there are actually nine different USB IDs that
> would need this change (see au0828-cards.c), so it might be nice to
> see if we can figure out a way for the au0828 driver to tell the
> usbaudio driver about the quirk without relying on embedding USB ids
> in the usbaudio driver.

Hi John,

After reviewing the patch as well as the spec, your change looks
pretty reasonable (aside from the fact that you need the other USB
IDs).  It seems pretty clear that the au0828 violates the spec, but
the spec does indicate how to handle that case, which is what your
code addresses.

All that said, the driver in question is managed by the ALSA project.
I would suggest posting a message with your patch on the alsa-devel
mailing list, so that it can be merged (and in fairness, those guys
are much better suited to review your patch).

On a separate note, I've been doing some testing with the device in a
low-latency application, and I think I've spotted a separate bug in
the usbaudio driver that causes the audio capture to stall.  I'll be
sending some email myself to alsa-devel as soon as I can test a patch.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
