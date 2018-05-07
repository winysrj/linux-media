Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:33070 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752302AbeEGPy7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 11:54:59 -0400
Date: Mon, 7 May 2018 17:54:55 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 7/7] media: rc: mceusb: allow the timeout to be
 configurable
Message-ID: <20180507155455.tvp3unvvk4a5kn6d@camel2.lan>
References: <cover.1523221902.git.sean@mess.org>
 <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
 <20180417191457.fhgsdega2kjqw3t2@camel2.lan>
 <20180418112428.zk3lmdxoqv46weph@gofer.mess.org>
 <20180418174229.jurjnyqbtkyctjvb@camel2.lan>
 <20180419221723.s6kx7nip6ue2d43o@camel2.lan>
 <20180421131852.2zrn7qp3ir4kyqvf@camel2.lan>
 <20180421174121.xcztgoaw2pspj3zv@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180421174121.xcztgoaw2pspj3zv@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean!

[ I trimmed the Cc list, as this is mceusb specific ]

On Sat, Apr 21, 2018 at 07:41:21PM +0200, Matthias Reichl wrote:
> On Sat, Apr 21, 2018 at 03:18:52PM +0200, Matthias Reichl wrote:
> > Another bug report came in, button press results in multiple
> > key down/up events
> > https://forum.kodi.tv/showthread.php?tid=298461&pid=2727837#pid2727837
> > (and following posts).

The original reporter gave up before I could get enough info
to understand what's going on, but now another user with an identical
receiver and the same problems showed up and I could get debug logs.

FYI: I've uploaded the full dmesg here if you need more info
or I snipped off too much:
http://www.horus.com/~hias/tmp/mceusb-settimeout-issue.txt

Here's the info about the IR receiver:
[    2.208684] usb 1-1.3: New USB device found, idVendor=1784, idProduct=0011
[    2.208699] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.208708] usb 1-1.3: Product: eHome Infrared Transceiver
[    2.208716] usb 1-1.3: Manufacturer: Topseed Technology Corp.
[    2.208724] usb 1-1.3: SerialNumber: EID0137AG-8-0000104054

With timeout configuration in the mceusb driver disabled everything
works fine. But with timeout configuration enabled spurious "keyup"
events show up during a button press and sometimes also a spurious
"ghost" keypress several seconds after the original button press.

Here's the ir-keytable -t output to illustrate the behaviour:

80.385585: event type EV_MSC(0x04): scancode = 0x800f0422
80.385585: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
80.385585: event type EV_SYN(0x00).
80.492469: event type EV_MSC(0x04): scancode = 0x800f0422
80.492469: event type EV_SYN(0x00).
80.633371: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
80.633371: event type EV_SYN(0x00).
80.642478: event type EV_MSC(0x04): scancode = 0x800f0422
80.642478: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
80.642478: event type EV_SYN(0x00).
80.783375: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
80.783375: event type EV_SYN(0x00).
84.318011: event type EV_MSC(0x04): scancode = 0x800f0422
84.318011: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
84.318011: event type EV_SYN(0x00).
84.460049: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
84.460049: event type EV_SYN(0x00).

>From the kernel log the first 2 scancodes are perfectly fine,
we get the timeout space in chunks, followed by the "End of raw IR data"
message and the scancode is properly decoded. Then about 45ms later
the pulses of the following IR message come in.

Snippet from end of second scancode:

[   80.505896] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
[   80.505902] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   80.505907] mceusb 1-1.3:1.0: Storing space with duration 6350000
[   80.505911] mceusb 1-1.3:1.0: processed IR data
[   80.506894] mceusb 1-1.3:1.0: rx data: 81 05 (length=2)
[   80.506899] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   80.506904] mceusb 1-1.3:1.0: Storing space with duration 250000
[   80.506908] rc rc0: enter idle mode
[   80.506913] rc rc0: sample: (25650us space)
[   80.506918] mceusb 1-1.3:1.0: rx data: 80 (length=1)
[   80.506922] mceusb 1-1.3:1.0: End of raw IR data
[   80.506925] mceusb 1-1.3:1.0: processed IR data
[   80.506943] rc rc0: RC6 decode started at state 6 (25650us space)
[   80.506949] rc rc0: RC6 decode started at state 8 (25650us space)
[   80.506955] rc rc0: RC6(6A) proto 0x0013, scancode 0x800f0422 (toggle: 1)
[   80.506961] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): scancode 0x800f0422 keycode 0x160
[   80.552906] mceusb 1-1.3:1.0: rx data: 81 b5 (length=2)
[   80.552914] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   80.552919] mceusb 1-1.3:1.0: Storing pulse with duration 2650000
[   80.552924] rc rc0: leave idle mode

But then, the end of the third scancode gets interesting. The
last chunk of the timeout space is missing and instead we get
a combined message with the remaining space and a zero-length
pulse just before the fourth IR message starts. Of course, this is
too late and the keyup timer had already expired:

[   80.612896] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
[   80.612903] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   80.612908] mceusb 1-1.3:1.0: Storing space with duration 6350000
[   80.612912] mceusb 1-1.3:1.0: processed IR data
[   80.647880] rc rc0: keyup key 0x0160
[   80.656901] mceusb 1-1.3:1.0: rx data: 82 05 80 (length=3)
[   80.656908] mceusb 1-1.3:1.0: Raw IR data, 2 pulse/space samples
[   80.656913] mceusb 1-1.3:1.0: Storing space with duration 250000
[   80.656918] rc rc0: enter idle mode
[   80.656923] rc rc0: sample: (25650us space)
[   80.656928] mceusb 1-1.3:1.0: Storing pulse with duration 0
[   80.656931] rc rc0: leave idle mode
[   80.656935] mceusb 1-1.3:1.0: processed IR data
[   80.656967] rc rc0: RC6 decode started at state 6 (25650us space)
[   80.656973] rc rc0: RC6 decode started at state 8 (25650us space)
[   80.656979] rc rc0: RC6(6A) proto 0x0013, scancode 0x800f0422 (toggle: 1)
[   80.656986] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): scancode 0x800f0422 keycode 0x160
[   80.656998] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): key down event, key 0x0160, protocol 0x0013, scancode 0x800f0422
[   80.659900] mceusb 1-1.3:1.0: rx data: 81 b6 (length=2)
[   80.659908] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   80.659913] mceusb 1-1.3:1.0: Storing pulse with duration 2700000
[   80.659916] mceusb 1-1.3:1.0: processed IR data

A similar thing happened on the fourth IR message, a spurious pulse
picked up by the IR receiver about 4 seconds after the message seems
to have made it send out it's data and flush the decoder:

[   80.719899] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
[   80.719905] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   80.719910] mceusb 1-1.3:1.0: Storing space with duration 6350000
[   80.719914] mceusb 1-1.3:1.0: processed IR data
[   80.797908] rc rc0: keyup key 0x0160
[   84.332919] mceusb 1-1.3:1.0: rx data: 83 05 80 81 (length=4)
[   84.332934] mceusb 1-1.3:1.0: Raw IR data, 3 pulse/space samples
[   84.332944] mceusb 1-1.3:1.0: Storing space with duration 250000
[   84.332954] rc rc0: enter idle mode
[   84.332964] rc rc0: sample: (25650us space)
[   84.332973] mceusb 1-1.3:1.0: Storing pulse with duration 0
[   84.332981] rc rc0: leave idle mode
[   84.332989] mceusb 1-1.3:1.0: Storing pulse with duration 50000
[   84.332997] mceusb 1-1.3:1.0: processed IR data
[   84.333046] rc rc0: RC6 decode started at state 6 (25650us space)
[   84.333057] rc rc0: RC6 decode started at state 8 (25650us space)
[   84.333068] rc rc0: RC6(6A) proto 0x0013, scancode 0x800f0422 (toggle: 1)
[   84.333080] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): scanco
de 0x800f0422 keycode 0x160
[   84.333098] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): key do
wn event, key 0x0160, protocol 0x0013, scancode 0x800f0422
[   84.339912] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
[   84.339925] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   84.339934] mceusb 1-1.3:1.0: Storing space with duration 6350000
[   84.339944] rc rc0: sample: (00050us pulse)
[   84.339952] mceusb 1-1.3:1.0: processed IR data
[   84.339994] rc rc0: RC6 decode failed at state 0 (50us pulse)
[   84.345908] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
[   84.345918] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
[   84.345927] mceusb 1-1.3:1.0: Storing space with duration 6350000
[   84.345935] mceusb 1-1.3:1.0: processed IR data

We have both rc-6 and NEC protocol enabled and the timeout is
therefore auto-configured to 25650us. I'm wondering if this could
have something to do with the odd behaviour as we'll get a very
short 250us space message from the IR receiver (in addition to
the 4 6350us spaces). Maybe this triggers some bug in the IR
receiver?

As we saw those issues on RPi, where USB has always been a bit
problematic, I wouldn't rule that out as a possible cause as well.

I've asked the reporter to test with various other timeout values,
this should hopefully provide some more info.

so long,

Hias
