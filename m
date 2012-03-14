Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34091 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab2CNVdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 17:33:35 -0400
Received: by wibhq7 with SMTP id hq7so3316961wib.1
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 14:33:33 -0700 (PDT)
Date: Wed, 14 Mar 2012 22:32:43 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: nuvoton-cir on Intel DH67CL
Message-ID: <20120314223243.62671b44@grobi>
In-Reply-To: <20120314204101.GG3729@redhat.com>
References: <20120314071037.43f650e4@grobi>
	<20120314204101.GG3729@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Mar 2012 16:41:01 -0400
Jarod Wilson <jarod@redhat.com> wrote:

> On Wed, Mar 14, 2012 at 07:10:37AM +0100, Steffen Barszus wrote:
> > Hi !
> > 
> > I'm using above board which has a nuvoton-cir onboard (as most Intel
> > Media boards) - It shows itself as NTN0530. 
> > 
> > The remote function works without a problem (loaded RC6 MCE
> > keytable). 
> > 
> > What doesn't work is wake from S3 and wake from S5. There are some
> > rumors that installing Windows 7 and corresponding drivers has a
> > positive effect (for some it seems to be enough to do it one time,
> > others need to redo this from time to time (power loss?). This
> > leads me to believe, that some hardware initialization is missing. 
> > 
> > I'm about to try latest linux-media tree next days, but i believe
> > there hasn't been any change on this driver. 
> > 
> > My questions: 
> > - any idea of what i should look at ?
> > - any change on the driver i could try ? 
> > - *IF* i go to install Win7 and drivers - anything i could to to
> > help tracking down what this does in order to make the driver work
> > out of the box on linux ?
> > 
> > As a lot of Sandy Bridge Boards to have this chip lately - it would
> > be nice if this could just work or is my impression, that this is a
> > general problem in this hardware wrong ?   
> 
> My only nuvoton hardware works perfectly w/resume via IR after commit
> 3198ed161c9be9bbd15bb2e9c22561248cac6e6a, but its possible what
> you've got is a newer hardware variant with some slightly different
> registers to tweak. What does the driver identify your chip as in
> dmesg?

I'm on Linux 3.2.0-18-generic #29-Ubuntu SMP (Ubuntu Precise)


> As of commit 362d3a3a9592598cef1d3e211ad998eb844dc5f3, the driver will
> bind to anything with the PNP ID of NTN0530, but will spew a warning
> in dmesg if its not an explicitly recognized chip.
> 

>From dmesg it seems to be fine. 
[    0.553258] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.553261] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.553504] pnp 00:03: [io  0x0240-0x024f]
[    0.553513] pnp 00:03: [irq 3]
[    0.553515] pnp 00:03: [io  0x0250-0x025f]
[    0.553534] pnp 00:03: Plug and Play ACPI device, IDs NTN0530 (active)
[    0.553544] pnp 00:04: [dma 4]
[    0.553545] pnp 00:04: [io  0x0000-0x000f]
[    0.553547] pnp 00:04: [io  0x0081-0x0083]
[    0.553549] pnp 00:04: [io  0x0087]
[    0.553550] pnp 00:04: [io  0x0089-0x008b]
[    0.553552] pnp 00:04: [io  0x008f]
[    0.553553] pnp 00:04: [io  0x00c0-0x00df]

Anything to be activated to wakeup on S3/S5 ?  I.e. the key to wake it
up ? I'm using RC6 remote - operation as already said is without any
issues, just not wakeup. 


More from dmesg:
[    2.722598] input: Nuvoton w836x7hg Infrared Remote Transceiver as /devices/pnp0/00:03/rc/rc0/input2
[    2.722659] rc0: Nuvoton w836x7hg Infrared Remote Transceiver as /devices/pnp0/00:03/rc/rc0
[    2.726726] nuvoton_cir: driver has been successfully loaded
[    2.772201] IR NEC protocol handler initialized
[    2.786605] IR RC5(x) protocol handler initialized
[    2.806280] IR RC6 protocol handler initialized
[    2.840479] IR JVC protocol handler initialized
[    2.854668] IR Sony protocol handler initialized
[    2.891067] lp: driver loaded but no devices found
[    2.895757] ngene: Loading firmware file ngene_18.fw.
[    2.917163] ngene 0000:04:00.0: irq 50 for MSI/MSI-X
[    2.918618] error in i2c_read_reg
[    2.918620] No CXD2099 detected at 40
[    2.925856] input: MCE IR Keyboard/Mouse (nuvoton-cir) as /devices/virtual/input/input3
[    2.925990] IR MCE Keyboard/mouse protocol handler initialized
[    2.936180] lirc_dev: IR Remote Control driver registered, major 250 
[    2.944124] rc rc0: lirc_dev: driver ir-lirc-codec (nuvoton-cir) registered at minor = 0
[    2.944127] IR LIRC bridge handler initialized
[    2.958002] usbcore: registered new interface driver usbhid
[    2.958005] usbhid: USB HID core driver
[    3.005172] w83627ehf: Found NCT6775F chip at 0x290

Looking at the kernel source for 3.2 i should be fine i think. (the commits you mentioned)
