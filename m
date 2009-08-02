Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:55843 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZHBIYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 04:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <1249174159.3255.13.camel@pc07.localdom.local>
References: <1249082438.18313.30.camel@odyssey.sc.user.nz.vpn>
	 <d9def9db0907311845r259b129em3bd89b7915718cd5@mail.gmail.com>
	 <1249174159.3255.13.camel@pc07.localdom.local>
Date: Sun, 2 Aug 2009 10:24:21 +0200
Message-ID: <d9def9db0908020124i26e2a6f2r972a98ae7b8bbe85@mail.gmail.com>
Subject: Re: USB devices supporting raw or sliced VBI for closed captioning?
From: Markus Rechberger <mrechberger@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Steve Castellotti <sc@eyemagnet.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 2, 2009 at 2:49 AM, hermann pitton<hermann-pitton@arcor.de> wrote:
>
> Am Samstag, den 01.08.2009, 03:45 +0200 schrieb Markus Rechberger:
>> Hi,
>>
>> On Sat, Aug 1, 2009 at 1:20 AM, Steve Castellotti<sc@eyemagnet.com> wrote:
>> >
>> >        I was wondering if anyone could please point me at a list or similar
>> > resource for USB capture devices which support raw (or sliced) VBI
>> > access for producing a closed caption transcript through software such
>> > as zbvi-ntsc-cc or ccextractor? Specifically I'm wanting a device
>> > capable of S-Video, Composite, or even Component input, not just ATSC,
>> > as most USB devices seem focused around these days.
>> >
>> >        I've managed to get this working with various ivtv and saa713x based
>> > PCI devices, but aren't aware of any USB implementations of chipsets
>> > which use those drivers.
>> >
>> >
>> >        Searching online, I found this archived message:
>> >
>> > http://lists.zerezo.com/video4linux/msg16402.html
>> >
>> > which states:
>> >
>> >> some em2840 and newer devices are able to capture raw vbi in
>> >> linux (sliced vbi isn't possible yet)
>> >> em2820, em2800, em2750 do not support vbi at all.
>> >
>> >
>> >        Checking the em28xx driver homepage for recent models, I found this
>> > entry:
>> >
>> > http://mcentral.de/wiki/index.php5/Em2880
>> >
>> >> officially the em2880 is em2840 + DVB_T
>> >
>> >
>> >        which implies that not only is the "em2880" series a "newer" device,
>> > but it should in fact already contain the "em2840" chip specifically
>> > mentioned.
>> >
>> >
>> >        Later on that same page, in the list of devices:
>> >
>> > ATI/AMD TV Wonder 600
>> >
>> >
>> >        and on the manufacturer's page:
>> >
>> > http://ati.amd.com/products/tvwonder600/usb/index.html
>> >
>> >
>> >        Under the list of "Input Connectors":
>> >
>> >> S-video input with adapter
>> >
>> >
>> >
>> >        Picking up one of these devices, I attempted to tune into the S-Video
>> > feed and check the /dev/vbi0 device, but received the same error message
>> > as I do with all other em28xx devices encountered thus far:
>> >
>> >> Cannot capture vbi data with v4l interface:
>> >> /dev/vbi0 (AMD ATI TV Wonder HD 600) is not a raw vbi device.
>> >
>> >
>> >
>> >        Can anyone please point me in the right direction?
>> >
>> >        I would much prefer to be certain the next purchase is supported.
>> >
>> >
>> >
>> > Thanks!
>> >
>>
>> we do support Raw VBI for our devices, Sundtek MediaTV Pro for closed
>> captioning.
>> Alternatively we also have full support for ATSC-analogTV USB devices
>> for the US market ([em288x]-[AVFB4910]-[Trident drx-J]-[tda18271]) the
>> european product which we are selling is also capable of decoding NTSC
>> closed caption.
>>
>> http://sundtek.de/shop/Digital-TV-Sticks-oxid/Sundtek-MediaTV-Pro.html
>> (this is just the information about the
>> European/DVB-T/DVB-C/analogTV(raw VBI) device, we do not have the
>> US/ATSC/analogTV(rawVBI) product listed there, although we do offer it
>> to business customers) We support it from Linux 2.6.15 on.
>>
>> Best Regards,
>> Markus Rechberger
>
> Hi,
>
> anything new about how to deal with commercial advertising on lists,
> depending totally on our source?
>
> Please have a look.

The question was about a device, and I doubt that you can get a device
for free anywhere. If so there shouldn't be any other company names in drivers,
or named on the mailinglist (to be fair) which do not support Linux.

Best Regards,
Markus
