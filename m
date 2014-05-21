Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUNWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 09:22:17 -0400
Date: Wed, 21 May 2014 10:22:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trevor G <trevor.forums@gmail.com>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	cb.xiong@samsung.com
Subject: Re: Hauppauge 950Q TS capture intermittent lock up
Message-ID: <20140521102211.151e849b@recife.lan>
In-Reply-To: <CAJHRZ=L-ZJxL6RFMVEAUpxMGo3ZC5GmniKw_ANXnq=GsTrVZRA@mail.gmail.com>
References: <CAJHRZ=KtLYbK=80FOZEquufSBXogxxduKc_eD9sbDsGD3Y3N2w@mail.gmail.com>
	<20140511115802.330f15b7@recife.lan>
	<CAJHRZ=L-ZJxL6RFMVEAUpxMGo3ZC5GmniKw_ANXnq=GsTrVZRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trevor,

Em Tue, 13 May 2014 11:53:24 -0400
Trevor G <trevor.forums@gmail.com> escreveu:

> Example app is attached. My build is just "gcc -O2 dvbcapture.c -o dvbcapture".

Thanks, it was very useful, as I could reproduce your issues.

What is happening is that, after ~10-15 times it opens the demux,
the DMA engine starts to fail: some URBs were never filled.

That looks to be a hardware bug to me. It is hard to properly fix
it, without some datasheet. On my tests, I even tried to remove/reinsert
the module, and this didn't solve. As you mentioned, only either a
device removal or a module reset fixes it.

Eventually, there are some registers that could do something similar,
but, if such register exists, it is not touched by the driver, as a
module remove/insert doesn't solve.

I found, however, two ways to minimize the issue:
	1) stop streaming before set_frontend;
	2) not letting xc5000 sleep.

I have already a patch done for (1), but I'm thinking on doing a patch
for xc5000 to do an alternative approach: only let the hardware to sleep
after some time. That would likely reduce the risk of hitting the bug,
while keeping the device in sleep state, while not in usage.

I would love to have some documentation about this device, in order to
see if are there something else that could be done, but, unfortunately,
I don't have it.

I'll do more tests today, and I should be posting some patches at the
ML soon.

> 
> Here's example output and usage of this app - both working and with
> data lockup. Params mean: DVB adapter 0, frequency 357Mhz, 4 seconds,
> output to "stuff.ts", QAM256. The app returns exit code 3 if no data
> is available on the DVR device (as in 2nd run below), which is my
> trigger to reset the USB (via usbreset:
> https://gist.github.com/x2q/5124616). Resetting the USB device then
> enables the capture to work.
> 
> [trevor@xxx bin]$ ./dvbcapture -c 0 -f 357000000 -t 4 -o stuff.ts -q 256
> Frontend type: ATSC
> DVB card: Auvitek AU8522 QAM/8VSB Frontend
> Frequency: 357000000
> Getting frontend status
> Locked frequency: 357000000
> Locked modulation: 5
> Bit error rate: 96
> Signal strength: 65535
> SNR: 398
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
> Setting TS filter to capture all PIDs
> Capturing for 4 seconds
> Caught timeout
> DONE - wrote 19415136 bytes!
> 
> [trevor@xxx bin]$ ./dvbcapture -c 0 -f 357000000 -t 4 -o stuff.ts -q 256
> Frontend type: ATSC
> DVB card: Auvitek AU8522 QAM/8VSB Frontend
> Frequency: 357000000
> Getting frontend status
> Locked frequency: 357000000
> Locked modulation: 5
> Bit error rate: 94
> Signal strength: 65535
> SNR: 398
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
> Setting TS filter to capture all PIDs
> Capturing for 4 seconds
> No data available on DVR device!
> 
> 
> 
> 
> 
> On Sun, May 11, 2014 at 10:58 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > Hi Trevor,
> >
> > Em Fri, 9 May 2014 11:19:49 -0400
> > Trevor Anonymous <trevor.forums@gmail.com> escreveu:
> >
> >> Hello all,
> >>
> >> I have written a simple application to capture RF QAM transport
> >> streams with the Hauppauge 950Q, and save to a file. This is
> >> essentially the same as dvbstream, but with unnecessary stuff removed
> >> (and I have verified this bug using dvbstream as well):
> >> - tune using frontend device
> >> - demux device: DMX_SET_PES_FILTER on pid 8192 with DMX_OUT_TS_TAP output.
> >> - Read from dvr device, save to file.
> >> - Interrupt app using alarm() and stop pes filter, close devices.
> >>
> >>
> >> This works as expected. The problem is after running this a bunch of
> >> times (sometimes 15-20+), the device seems to eventually get into a
> >> bad state, and nothing is available to read on the dvr device. The
> >> lockup never seems to happen while reading data (i.e., either data
> >> comes and the app works completely, or the app reads 0 bytes). When
> >> this happens, all the tuning/demod locks look good, and everything
> >> appears to be working -- there just isn't data ready to read from the
> >> dvr device.
> >>
> >> When it gets into a bad state, I have to physically remove/reinsert
> >> the 950Q device or otherwise reset the device (e.g., usb reset -
> >> USBDEVFS_RESET ioctl).
> >
> > Yes, I noticed a similar issue with last devel Kernel. I suspect
> > that the culprit could be due to a sheduled work that fixes a
> > hardware bug. Such scheduled work task should be cancelled when
> > the device is closed or the channel is changed. This is likely
> > a partial fix for it (untested):
> >         https://patchwork.linuxtv.org/patch/23860/
> >
> > It makes sure that the thread is canceled when a new set frontend
> > ioctl is sent. Yet, this patch won't solve your specific problem.
> >
> > I suspect that the right approach would be to also call
> > cancel_work_sync(&dev->restart_streaming) on all other places
> > where stop_urb_transfer() is called.
> >
> > Btw, could you share your small test application? That would
> > help us to test the bug locally and work on a patch.
> >
> >>
> >> Has anyone seen this issue before?
> >>
> >> I am running Fedora 19 with 3.13.9 kernel. Hardware is:
> >> - au0828, au8522, xc5000 (with dvb-fe-xc5000c-4.1.30.7.fw)
> >>
> >>
> >> Thanks,
> >> -Trevor
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
