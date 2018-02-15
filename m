Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:40169 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164218AbeBORyf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 12:54:35 -0500
MIME-Version: 1.0
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Thu, 15 Feb 2018 20:54:13 +0300
Message-ID: <CAJs94EZhV7-3Ra5zqZNfz07xu2n1xeHQLV3BQpOPqPp+0YydGw@mail.gmail.com>
Subject: [BUG] musb: broken isochronous transfer at TI AM335x platform
To: linux-usb@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux@armlinux.org.uk,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Almost two years ago I faced an issue related to PWC-driven V4L2
webcam attached to BeagleBone Black SBC. [1][2] The issue still
persists in 4.16-rc1. However, some research has been carried out
since then. I would like to summarize my findings below. I also would
like to receive feedback since the issue appears not to have one
single source and probably may affect setups other than mine.

Initial issue signs were the following. When Philips SPC 900 webcam
(handled by pwc kernel module) is attached to BeagleBone Black SBC
(equipped with TI AM335x Cortex-A8 CPU and Inventra MUSB Dual-Role USB
controller), no frames can be received from the camera. In other
words, the major functional purpose of the camera was broken. From
user-space point of view,

    ioctl(fd, VIDIOC_DQBUF, &buf)

indefinitely waits for a frame, yet all other functionalities (i.e.
setting formats) works as usual. This happens always when "ondemand"
cpufreq policy is set and from time to time when "performance" is
used. This also happens disregarding whether DMA USB is used.

Other instances of the camera (same model) have been tested and found
to have same behavior. Then, I've found that the reason for such
behavior is that pwc module never feeds V4L2 subsystem with frames
from the module side, because frame completion criteria never
satisfied in pwc_isoc_handler(). PWC considers the "shorter" or empty
incoming USB ISO packet as end-of-frame sign. Usually, every URB has
10 packets and every packet consists of 956 payload data bytes in case
of PWC. Also, when end-of-frame is received the accumulated amount of
bytes must be equal to expected (known from frame format, i.e width *
height * pixel-depth). It appeared that it was never the case, empty
USB packet was always received in advance to expected frame end and
then every frame was discarded.

I've also bisected the following. The USB ISO transfer works well since commit

    2035772010db ("usb: musb: musb_host: Enable HCD_BH flag to handle
urb return in bottom half")

and stops working after commit

    f551e1352983 ("Revert "usb: musb: musb_host: Enable HCD_BH flag to
handle urb return in bottom half"")

To reliably connect these two facts, I had to assembly OpenVizsla
hardware USB monitor (sniffer). [3] Using this tool the following MUSB
Host + PWC webcam behavior patterns were found [4]:

    [        ]   7.219456 d=  0.000997 [181.0 +  3.667] [  3] IN   : 4.5
    [    T   ]   7.219459 d=  0.000003 [181.0 +  7.083] [800] DATA0: 53 da ...
    [        ]   7.220456 d=  0.000997 [182   +  3.667] [  3] IN   : 4.5
    [    T   ]   7.220459 d=  0.000003 [182   +  7.000] [800] DATA0: 13 36 ...
    [        ]   7.222456 d=  0.001997 [184   +  3.667] [  3] IN   : 4.5
    [        ]   7.222459 d=  0.000003 [184   +  7.000] [  3] DATA0: 00 00
    [        ]   7.223456 d=  0.000997 [185.0 +  3.667] [  3] IN   : 4.5
    [        ]   7.223459 d=  0.000003 [185.0 +  7.000] [  3] DATA0: 00 00

Please note, that the time moment "7.221456" has missed IN request
packet which must be sent out every 1ms in this low-speed USB case.
Then, all incoming packets became empty ones. Such moments coincide
with frame discarding in pwc driver.

Even though IN sending is usually handled by USB host hardware, it is
not fully true for MUSB. Every IN is triggered by musb kernel driver
(see MUSB_RXCSR_H_REQPKT usage in musb_host_packet_rx() and
musb_ep_program()) since auto IN is not used. Rather complicated logic
is incorporated to decide whether IN packet has to be sent. First,
musb_host_packet_rx() handles IN sending when current URB is not
completed (i.e. current URB has another packet which has to be
received next). Second, musb_advance_schedule() (via musb_start_urb())
handles the case when current URB is completed but there is another
URB pending. It seems that there is a hardware logic to fire IN packet
in a way to have exactly 1ms between two consequent INs. So,
MUSB_RXCSR_H_REQPKT is considered as IN requesting flag.

Both functions are triggered by musb_host_rx() interrupt handler. And
there are a lot of other important things between interrupt triggering
and next IN requesting. It appears that sometimes it takes 0.4-0.5 ms
between the interrupt and MUSB_RXCSR_H_REQPKT writing. This delays
also lead to missed IN (It is actually sent, but at (last)+2ms time
instead of (last)+1ms) and confusing the peripheral as shown above.
This is a case of URB-completion branch.

The most time-consuming part is urb->giveback() calling.
Unfortunately, it is performed synchronously before requesting IN.
This explains why commit

    2035772010db ("usb: musb: musb_host: Enable HCD_BH flag to handle
urb return in bottom half")

masks the issue. Moving (postponing) urb->giveback() call out of
interrupt context eliminated extra delays between IN requesting.
(Un)fortunately, this commit was reverted and the issue returned back.
I proposed a patch to swap time-consuming urb->giveback() and
MUSB_RXCSR_H_REQPKT writing but the patch has not been accepted since
it complicates IN-requesting logic even more. [5]

However, there is another level in this issue, the performance of
urb->giveback (pwc_isoc_handler()) itself. It takes 350us for the
handler to be executed that seems to be too much to copy 9560 bytes of
the data from urb->transmit_buffer to internal pwc data structures.
Using trace event points I measured exact timings in two cases. [6]
The median memcpy() performance is 28 MBps. Given CPU frequency at
lowest possible state in 'ondemand' cpufreq policy, it roughly equals
to 10 CPU cycles per byte. Reverting commit

    63c5b4ca7d0d ("usb: musb: do not change dev's dma_mask")

raises the rate to 280 MBps (~ 1 cycle per byte) and fully fixes the
issue when PIO in musb is used.

The reason is the following. pwc uses usb_alloc_coherent() to allocate
memory for urb->transfer_buffer. It seems to be a common practice
among webcam drivers: uvc, gspca and others do the same, though it is
not clear what is the reason to use so strict requirement as full
coherence here. Internally, usb_alloc_coherent() does
dma_alloc_coherent() or kmalloc() (when dev->dma_mask is NULL). In
case of MUSB, usb_alloc_coherent() always behaves as
dma_alloc_coherent() (mind 63c5b4ca7d0d, dma_mask is always set). At
the same time AFAIU AM335x doesn't have truly coherent DMA and it is
emulated in the kernel by pgprot nocache flags in the pages table. So,
we always have uncacheable (slow) memory for urb->transfer_buffer.

In conclusion, I think there is possibility to fix the issue (because
there are known cases when things work), though the way is not clear
to me. memcpy() is "slow" for uncacheable memory (not sure that
something can be done with it). usb_alloc_coherent() is probably
misused in pwc and a number of USB peripherial drivers. musb_host_rx()
interrupt handler performs less important things (urb->giveback) prior
to more important (writing MUSB_RXCSR_H_REQPKT).

References:

[1] https://www.spinics.net/lists/linux-usb/msg143956.html
[2] https://www.spinics.net/lists/linux-usb/msg145747.html
[3] http://openvizsla.org/
[4] https://www.spinics.net/lists/linux-usb/msg156107.html
[5] https://www.spinics.net/lists/linux-usb/msg156486.html
[6] https://github.com/matwey/linux/commit/2b36e1add5aaf552923c8c1340e50bd7c2050fde

-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
