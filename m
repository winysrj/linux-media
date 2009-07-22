Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:50169 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZGVCcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 22:32:41 -0400
Received: by gxk9 with SMTP id 9so6094883gxk.13
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2009 19:32:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A667735.40002@eyemagnet.com>
References: <4A6666CC.7020008@eyemagnet.com>
	 <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	 <4A667735.40002@eyemagnet.com>
Date: Tue, 21 Jul 2009 22:32:39 -0400
Message-ID: <829197380907211932v6048d099h2ebb50da05959d89@mail.gmail.com>
Subject: Re: offering bounty for GPL'd dual em28xx support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Castellotti <sc@eyemagnet.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 21, 2009 at 10:19 PM, Steve Castellotti<sc@eyemagnet.com> wrote:
> On 07/21/2009 06:42 PM, Devin Heitmueller wrote:
>>
>> On Tue, Jul 21, 2009 at 9:09 PM, Steve Castellotti<sc@eyemagnet.com>
>>  wrote:
>>>
>>>    We can confirm that a development system running Fedora 11 with the
>>> latest stable kernel (2.6.29.5-191.fc11.i686.PAE), with identical em28xx
>>> devices connected still exhibits the error message "v4l2: ioctl queue
>>> buffer
>>> failed: No space left on device" when attempting to display video input
>>> on
>>> two identical em28xx devices simultaneously.
>>>
>>>    On the other hand, display is successful through either device when
>>> trying to display individually (with both still connected).
>>>
>>
>> Hello Steve,
>>
>> The issue occurs with various different drivers.  Basically the issue
>> is the device attempts to reserve a certain amount of bandwidth on the
>> USB bus for the isoc stream, and in the case of analog video at
>> 640x480 this adds up to about 200Mbps.  As a result, connecting
>> multiple devices can result in exceeding the available bandwidth on
>> the USB bus.
>>
>> Depending on your how many devices you are trying to connect, what
>> your target capture resolution is, and whether you can put each device
>> on its own USB bus will dictate what solution you can go with.
>>
>> I've done a considerable amount of work with the mainline em28xx
>> driver, so if you would like to discuss your desired configuration
>> further and what we might be able to do to accommodate those
>> requirements (including possibly optimizing the driver to better
>> support more devices), feel free to email me off-list.
>>
>> Regards,
>>
>> Devin
>>
>
> Devin-
>
>    Thanks for the quick response. Happy to take the conversation off-list,
> but first, to clarify what may be useful to future web searchers:
>
>    So if I'm working with a USB 2.0 bus, which should have a theoretical
> maximum of 480 Mbps, if the only two ports connected are both em28xx capture
> devices running at (say) 640x480, shouldn't that be sufficient for
> displaying both streams simultaneously?
>
>    Talking in the general sense of course, perhaps some details vary from
> system to system - any idea what sort of variables might affect that
> however?
>
>    I would assume most systems only have a single USB bus (regardless of
> whether plugs are present on the front/back/side). If a given system has a
> second USB bus or chipset, them perhaps plugging the second device into that
> would solve the problem, but that surely that would be a rare situation?
>
>    Most of the systems we use do not have expansion slots, so adding a PCI
> USB board is not possible (in which case we would probably just add a PCI TV
> Capture board anyway!).
>
>
>    That said, if you do have some thoughts or suggestions as to how we might
> be able to investigate specific hardware, or there is some other way you
> think you might be able to help address this particular problem (ideally in
> a way that benefits the larger community too!) please let me know.
>
>
> Thanks again
>
> Steve
>
> --
>
> Steve Castellotti
> sc@eyemagnet.com
> Technical Director
> Eyemagnet Limited
> http://www.eyemagnet.com

I agree that *in theory* you should be able to do two devices.  A back
of the envelope calculation of 640x480 at 30fps in YUVY capture should
be about 148Mbps.  That said, I don't think the scenario you are
describing has really been tested/debugged previously.  If I had to
guess, my suspicion would be a bug in the driver code that calculates
which USB alternate mode to operate in, which results in the driver
reserving more bandwidth than necessary.

I would have dig into the code and do some testing in order to have a
better idea where the problem is.  Do you have a specific em28xx
product in mind that you intend to use?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
