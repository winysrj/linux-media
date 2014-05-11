Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaEKO6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 10:58:19 -0400
Date: Sun, 11 May 2014 11:58:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trevor Anonymous <trevor.forums@gmail.com>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	cb.xiong@samsung.com
Subject: Re: Hauppauge 950Q TS capture intermittent lock up
Message-ID: <20140511115802.330f15b7@recife.lan>
In-Reply-To: <CAJHRZ=KtLYbK=80FOZEquufSBXogxxduKc_eD9sbDsGD3Y3N2w@mail.gmail.com>
References: <CAJHRZ=KtLYbK=80FOZEquufSBXogxxduKc_eD9sbDsGD3Y3N2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trevor,

Em Fri, 9 May 2014 11:19:49 -0400
Trevor Anonymous <trevor.forums@gmail.com> escreveu:

> Hello all,
> 
> I have written a simple application to capture RF QAM transport
> streams with the Hauppauge 950Q, and save to a file. This is
> essentially the same as dvbstream, but with unnecessary stuff removed
> (and I have verified this bug using dvbstream as well):
> - tune using frontend device
> - demux device: DMX_SET_PES_FILTER on pid 8192 with DMX_OUT_TS_TAP output.
> - Read from dvr device, save to file.
> - Interrupt app using alarm() and stop pes filter, close devices.
> 
> 
> This works as expected. The problem is after running this a bunch of
> times (sometimes 15-20+), the device seems to eventually get into a
> bad state, and nothing is available to read on the dvr device. The
> lockup never seems to happen while reading data (i.e., either data
> comes and the app works completely, or the app reads 0 bytes). When
> this happens, all the tuning/demod locks look good, and everything
> appears to be working -- there just isn't data ready to read from the
> dvr device.
> 
> When it gets into a bad state, I have to physically remove/reinsert
> the 950Q device or otherwise reset the device (e.g., usb reset -
> USBDEVFS_RESET ioctl).

Yes, I noticed a similar issue with last devel Kernel. I suspect
that the culprit could be due to a sheduled work that fixes a
hardware bug. Such scheduled work task should be cancelled when
the device is closed or the channel is changed. This is likely
a partial fix for it (untested):
	https://patchwork.linuxtv.org/patch/23860/

It makes sure that the thread is canceled when a new set frontend
ioctl is sent. Yet, this patch won't solve your specific problem.

I suspect that the right approach would be to also call
cancel_work_sync(&dev->restart_streaming) on all other places
where stop_urb_transfer() is called.

Btw, could you share your small test application? That would
help us to test the bug locally and work on a patch.

> 
> Has anyone seen this issue before?
> 
> I am running Fedora 19 with 3.13.9 kernel. Hardware is:
> - au0828, au8522, xc5000 (with dvb-fe-xc5000c-4.1.30.7.fw)
> 
> 
> Thanks,
> -Trevor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
