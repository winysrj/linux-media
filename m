Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdFBU2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 16:28:11 -0400
Subject: Re: Firmware for staging atomisp driver
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <e4933669-faf4-a721-cce0-117ba3d0f1eb@redhat.com>
Message-ID: <0bcc3d9d-b16f-49e1-2069-8798894bdf8b@redhat.com>
Date: Fri, 2 Jun 2017 22:28:08 +0200
MIME-Version: 1.0
In-Reply-To: <e4933669-faf4-a721-cce0-117ba3d0f1eb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/28/2017 02:30 PM, Hans de Goede wrote:
> Hi All,
> 
> I've been trying to get the atomisp driver from staging to work
> on a couple of devices I have.
> 
> I started with an Asus T100TA after fixing 2 oopses in the sensor
> driver there I found out that the BIOS does not allow to put the
> ISP in PCI mode and that there is no code to drive it in ACPI
> enumerated mode.
> 
> So I moved to a generic Insyde T701 tablet which does allow
> this. After fixing some more sensor driver issues there I was
> ready to actually load the atomisp driver, but I could not
> find the exact firmware required, I did find a version which
> is close: "irci_stable_candrpv_0415_20150423_1753"
> and tried that but that causes the atomisp driver to explode
> in a backtrace which contains atomisp_load_firmware() so that
> one seems no good.

Ok, so it turns out that the explosion was not a probem with
a wrong firmware version, but rather another atomisp code
bug. According to this patch:

https://github.com/01org/ProductionKernelQuilts/blob/master/uefi/cht-m1stable/patches/cam-0418-atomisp2-css2401-and-2401_legacy-irci_stable_candrpv.patch

The irci_stable_candrpv_0415_20150423_1753 version I
have and the irci_stable_candrpv_0415_20150521_0458
version expected are fully compatible.

So I'e focussed on fixing the crash and that was easy, see
the patch I just send.

Then I hit another bunch of crashes which all turn out to
be due to races with udev opening /dev/video# nodes for probing
before the driver is ready to handle this because the driver
registers the v4l2 devices too soon. I've hacked around this
for now:

https://github.com/jwrdegoede/linux-sunxi/commit/88c9c248e6e0f86d547ea8441e16b0e8b4c951c8

And with this hack the driver loads without issues, giving
me 10 /dev/video# devices. So I tried this app:

https://github.com/jfwells/linux-asus-t100ta/tree/master/webcam/atomisp_testapp

On a number of the v4l devices which leads to yet more oopses.

So I'm starting to wonder, does anyone have this driver working
(in its current form in 4.12-rc3 drivers/staging) at all ?

I'm asking  because that is hard to believe given e.g. the recursion bug
I've just fixed.

Can someone provide step-by-step instructions for how to get this
driver working?

I'm not expecting all userspace apps to just work, but at least a userspace example
given a picture from the camera would be very helpful in further developing
this driver.

Regards,

Hans
