Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1310 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3GNJXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 05:23:54 -0400
Message-ID: <51E26E22.8050005@xs4all.nl>
Date: Sun, 14 Jul 2013 11:23:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Streibelt <florian@inet.tu-berlin.de>
CC: linux-media@vger.kernel.org
Subject: Re: CX23103  Video Grabber seems to be supported by cx231xx  driver
References: <20130712182632.667842dc@fls-nb.lan.streibelt.net>
In-Reply-To: <20130712182632.667842dc@fls-nb.lan.streibelt.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On 07/12/2013 06:26 PM, Florian Streibelt wrote:
> Hi,
> 
> the chip CX23103 that is used in various devices sold e.g. in germany works with the cx231xx stock driver.
> 
> The author of that driver is not reachable via the email adress stated in the source file: srinivasa.deevi@conexant.com
> [ host cnxtsmtp1.conexant.com [198.62.9.252]: 550 5.1.1 <srinivasa.deevi@conexant.com>:  Recipient address rejected: User unknown in relay recipient table]

Yeah, I suspect he left Conexant. For all practical purposes that leaves me as
the maintainer for my sins.

> 
> In drivers/media/video/cx231xx/cx231xx-cards.c the struct usb_device_id cx231xx_id_table[] needs these lines added:
> 
>    {USB_DEVICE(0x1D19, 0x6109),
>    .driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},

That looks OK.

> While the change is minimal due to the fact that no real technical documentation is available on the chip the support was guessed - but worked for video.
> 
> The videostream can pe played using mplayer tv:///0  - proof: http://streibelt.de/blog/2013/06/23/kernel-patch-for-cx23103-video-grabber-linux-support/
> 
> However when trying to capture audio using audacity while playing the video stream in mplayer my system locked (no message in syslog, complete freeze). 

I've no idea what is happening here. It has probably to do with the board setup,
although there isn't all that much that you can change there that relates to audio.

Try using 'arecord' instead of audicity. The arecord tool is more low-level, so
it will be interesting to know if it behaves differently.

Besides that the only thing I can think of is just to try and add printk's to
cx231xx-audio.c and see where things go boom.

A useful trick there is to add a mdelay(5) or so after the printk to give the
system time to write to the kernel log.

Be aware that I consider this driver to be flaky, so I would not at all be
surprised if there are bugs lurking in the code.

Regards,

	Hans

> I posted this one month ago to this list without any reaction so I ask if this is the correct way to get that grabber really supported.
> 
> I am willing to do any tests neccessary and try out patches.

