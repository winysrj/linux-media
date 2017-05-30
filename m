Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5028 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751063AbdE3QZu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 12:25:50 -0400
Message-ID: <1496161514.5682.12.camel@linux.intel.com>
Subject: Re: Firmware for staging atomisp driver
From: Alan Cox <alan@linux.intel.com>
To: Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 30 May 2017 17:25:14 +0100
In-Reply-To: <e4933669-faf4-a721-cce0-117ba3d0f1eb@redhat.com>
References: <e4933669-faf4-a721-cce0-117ba3d0f1eb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-05-28 at 14:30 +0200, Hans de Goede wrote:
> I started with an Asus T100TA after fixing 2 oopses in the sensor
> driver there I found out that the BIOS does not allow to put the
> ISP in PCI mode and that there is no code to drive it in ACPI
> enumerated mode.

In ACPI mode it's enumerated as part of the GPU but beyond that I don't
know how it works and haven't been able to find out. I am guessing at
this point that the extra node in the acpidump under the GPU gives the
base address, but no idea where the IRQ comes from. Power management on
the BYT devices via PCI is broken anyway so that bit shouldn't matter.



> So I moved to a generic Insyde T701 tablet which does allow
> this. After fixing some more sensor driver issues there I was
> ready to actually load the atomisp driver, but I could not
> find the exact firmware required, I did find a version which
> is close: "irci_stable_candrpv_0415_20150423_1753"
> and tried that but that causes the atomisp driver to explode
> in a backtrace which contains atomisp_load_firmware() so that
> one seems no good.

The firmware has to exactly match. If you look in the atomisp code
you'll see that there are offsets which basically appear to be memory
addresses in the firmware as built that time.

> Can someone help me to get the right firmware ?

Yep.

> The TODO says: "can also be extracted from the upgrade kit"
> about the firmware files, but it is not clear to me what /
> where the "upgrade kit" is.

The Android upgrade kit for your device. So your platforms equivalent
of

https://www.asus.com/Tablets/ASUS_MeMO_Pad_7_ME176C/HelpDesk_Download/


> More in general it would be a good idea if someone inside Intel
> would try to get permission to add the firmware to linux-firmware.

I spent 6 months trying, but even though you can go to your product
vendors website and download it I've not been able to 8(.

> 
> Anyways I will send out the patches I've currently, once I've
> the right firmware I will continue working on this.

Really appreciate the work you are doing on this.

Alan
