Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:44806 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755843Ab2BWWMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 17:12:14 -0500
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: gennarone@gmail.com
Subject: Re: [PATCH 0/3] Support for AF9035/AF9033
Date: Thu, 23 Feb 2012 23:12:11 +0100
Cc: linux-media@vger.kernel.org
References: <201202222320.56583.hfvogt@gmx.net> <4F466BEF.9050204@gmail.com>
In-Reply-To: <4F466BEF.9050204@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202232312.11761.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, 23. Februar 2012 schrieb Gianluca Gennari:
> Il 22/02/2012 23:20, Hans-Frieder Vogt ha scritto:
> > I have written a driver for the AF9035 & AF9033 (called af903x), based on
> > the various drivers and information floating around for these chips.
> > Currently, my driver only supports the devices that I am able to test.
> > These are
> > - Terratec T5 Ver.2 (also known as T6)
> > - Avermedia Volar HD Nano (A867)
> > 
> > The driver supports:
> > - diversity and dual tuner (when the first frontend is used, it is in
> > diversity mode, when two frontends are used in dual tuner mode)
> > - multiple devices
> > - pid filtering
> > - remote control in NEC and RC-6 mode (currently not switchable, but
> > depending on device)
> > - support for kernel 3.1, 3.2 and 3.3 series
> > 
> > I have not tried to split the driver in a DVB-T receiver (af9035) and a
> > frontend (af9033), because I do not see the sense in doing that for a
> > demodulator, that seems to be always used in combination with the very
> > same receiver.
> > 
> > The patch is split in three parts:
> > Patch 1: support for tuner fitipower FC0012
> > Patch 2: basic driver
> > Patch 3: firmware
> > 
> > Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
> 
> Hi Hans,
> thank you for the new af903x driver.
> A few comments:
> 
> 1) I think you should set up a git repository with your driver and then
> send a PULL request to the list; as it is, the first patch is affected
> by line-wrapping problems so it must be manually edited to be
> applicable, and the second patch is compressed so it will be ignored by
> patchwork.
> 
> 2) There are a couple of small errors in the patches (see my attached
> patches): in the dvb-usb Makefile,  DVB_USB_AF903X must be replaced by
> CONFIG_DVB_USB_AF903X otherwise the driver will not compile; also, in
> the dvb_frontend_ops struct, the field info.type should be removed for
> kernels >= 3.3.0.
> 
> 3) The USB VID/PID IDs should be moved into dvb-usb-ids.h (see patch 3);
> I also added a few IDs from the Avermedia A867 driver*. As your driver
> supports both AF9007 and mxl5007t tuners I think this is safe.
> 
> *http://www.avermedia.com/Support/DownloadCount.aspx?FDFId=4591
> 
> 4) the driver also looks for a firmware file called "af35irtbl.bin" that
> comes from the "official" ITEtech driver (if it's not present the driver
> works anyway, but it prints an error message);
> 
> I tested the driver with an Avermedia A867 stick (it's an OEM stick also
> known as the Sky Italia Digital Key with blue led: 07ca:a867) on a
> Ubuntu 10.04 system with kernel 2.6.32-38-generic-pae and the latest
> media_build tree installed.
> 
> The good news:
> the driver loads properly, and, using Kaffeine, I could watch several
> channels with a small portable antenna; I could also perform a full
> frequency scan, finding several UHF and VHF stations. Signal strength
> and SNR reports works really well, and they seems to give a "realistic"
> figure of the signal quality (with both the portable and the rooftop
> antenna).
> When the stick is unplugged from the USB port, the driver unloads properly.
> 
> The bad news:
> the driver seems to "lock" the application when it tries to tune a weak
> channel: in this cases, Kaffeine becomes unresponsive and sometimes it
> gives a stream error; for the same reason, the full scan fails to find
> all stations and takes a long time to complete.
> Also, when I tried to extract the stick from the USB port during one of
> this "freezing" periods, the system crashed :-(
> I reproduced this bug 3 times, and the last time I was able to see a
> kernel dump for a moment: the function that crashed the kernel was
> "af903x_streaming_ctrl".
> Neither of those issues are present with the Avermedia A867 original
> driver or Antti Palosaari's af9035 driver modified to support the A867
> stick.
> 
> I hope this feedback will be useful to improve the driver.
> 
> Best regards,
> Gianluca Gennari

Gianluca,

thanks very much for your comments and patches. I will try the patches over 
the weekend.

With respect to your comment about the locking: I suspect this is because I 
have used quite a lot of mutex locks. In particular the dual tuner stick 
behaves very sensitive to any code changes and I have fought for months (no 
joke) to get it working reasonably well (besides the bad reception problems).
A lot of the complexity in the driver is for the dual tuner and to support the 
diversity feature.

As to the af35irtbl.bin firmware: this is something I just copied from previous 
drivers. I will probably just throw it out, because, as you also saw, it is 
not needed (only needed for the HID mode of the remote control).

Thanks very much for your input!

Regards,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
