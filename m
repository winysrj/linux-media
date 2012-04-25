Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48690 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2DYMg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Apr 2012 08:36:56 -0400
Received: by qcro28 with SMTP id o28so18323qcr.19
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 05:36:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <jn7ohg$k5q$1@dough.gmane.org>
References: <jn6n2e$gu1$1@dough.gmane.org>
	<1335309978.8218.22.camel@palomino.walls.org>
	<jn7ohg$k5q$1@dough.gmane.org>
Date: Wed, 25 Apr 2012 13:36:55 +0100
Message-ID: <CAH4Ag-CxYUXmgW9t5-KWJhP_+fPTYYgiUH1eYf1EgrRSu8X5sQ@mail.gmail.com>
Subject: Re: udev rules for persistent symlinks for adapter?/frontend0 devices
From: Simon Jones <sijones2010@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> KERNEL[1335308536.258048] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.frontend0 (dvb)
>> UDEV_LOG=3
>> ACTION=add
>> DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.frontend0
>
> Perhaps this is the ultimate in persistence, but unfortunately is also
> highly dependent on physical location in the machine (i.e. which PCI
> slot even).
>
>> SUBSYSTEM=dvb
>> DEVNAME=dvb/adapter0/frontend0
>
> AFAIU, the "adapter0" is not representative of physical device
> persistence but is rather dependent on probing order.  IOW,
> "dvb/adapter0/frontend0" will always be the first DVB device found but
> won't be a guarantee of which physical device it is.  This is what I
> currently have with /dev/dvb/adapter{0.1} which is unfortunately
> unsuitable since it's so predictable.
>
> I might end up having to bite the bullet and using DEVNAME.  :-(
>
> Thanks for the info though, much appreciated,
> b.
>

All you need to do is to use adapter_nr option passed to the kernel module, i.e.

options dvb_usb_dib0700 adapter_nr=0,1

The above line tell the module to assign 0 and 1 to the card that uses
that module, so in your case you create a options.conf under
/etc/modprobe.d/

then do 2 lines of

option kernel_module adapter_nr=0
option kernel_module adapter_nr=1

On reboot the kernel modules will pick up it's adapter number and
apply it for you, no need for any udev rules.
