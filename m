Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46589 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211Ab3GNNXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 09:23:24 -0400
Date: Sun, 14 Jul 2013 15:23:21 +0200
From: Florian Streibelt <florian@inet.tu-berlin.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: CX23103  Video Grabber seems to be supported by cx231xx  driver
Message-ID: <20130714152321.2a9e1eb2@fls-nb.lan.streibelt.net>
In-Reply-To: <51E26E22.8050005@xs4all.nl>
References: <20130712182632.667842dc@fls-nb.lan.streibelt.net>
	<51E26E22.8050005@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 14 Jul 2013 11:23:46 +0200
 Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Florian,
> 
> On 07/12/2013 06:26 PM, Florian Streibelt wrote:
> > Hi,
> > 
> > the chip CX23103 that is used in various devices sold e.g. in germany works with the cx231xx stock driver.
> > 
> > The author of that driver is not reachable via the email adress stated in the source file: srinivasa.deevi@conexant.com
> > [ host cnxtsmtp1.conexant.com [198.62.9.252]: 550 5.1.1 <srinivasa.deevi@conexant.com>:  Recipient address rejected: User unknown in relay recipient table]
> 
> Yeah, I suspect he left Conexant. For all practical purposes that leaves me as
> the maintainer for my sins.

heh - also means a patch should remove the wrong email adress/change the maintainers in the source?


> 
> > 
> > In drivers/media/video/cx231xx/cx231xx-cards.c the struct usb_device_id cx231xx_id_table[] needs these lines added:
> > 
> >    {USB_DEVICE(0x1D19, 0x6109),
> >    .driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},
> 
> That looks OK.

Only if the board layout is different :/ 
There is no information from the vendor, they don't even reply to messages via the contact form, of course.



> 
> > While the change is minimal due to the fact that no real technical documentation is available on the chip the support was guessed - but worked for video.
> > 
> > The videostream can pe played using mplayer tv:///0  - proof: http://streibelt.de/blog/2013/06/23/kernel-patch-for-cx23103-video-grabber-linux-support/
> > 
> > However when trying to capture audio using audacity while playing the video stream in mplayer my system locked (no message in syslog, complete freeze). 
> 
> I've no idea what is happening here. It has probably to do with the board setup,
> although there isn't all that much that you can change there that relates to audio.

hm. maybe disable it - currently my time budget is "negative" - so  I cannot really work on this.

> 
> Try using 'arecord' instead of audicity. The arecord tool is more low-level, so
> it will be interesting to know if it behaves differently.

I'll try - the problem is the complete system freeze - I'll see if I can setup a system with serial console for the kernel log

> 
> Besides that the only thing I can think of is just to try and add printk's to
> cx231xx-audio.c and see where things go boom.

yup. If I had the time.

> 
> A useful trick there is to add a mdelay(5) or so after the printk to give the
> system time to write to the kernel log.

ok

> 
> Be aware that I consider this driver to be flaky, so I would not at all be
> surprised if there are bugs lurking in the code.


Hum. Because of code quality or due to the missing documentation from the vendor?


If you have any documents on the chip I would be happy.


/Florian
