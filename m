Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750773AbdE1Mab (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:30:31 -0400
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
From: Hans de Goede <hdegoede@redhat.com>
Subject: Firmware for staging atomisp driver
Message-ID: <e4933669-faf4-a721-cce0-117ba3d0f1eb@redhat.com>
Date: Sun, 28 May 2017 14:30:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I've been trying to get the atomisp driver from staging to work
on a couple of devices I have.

I started with an Asus T100TA after fixing 2 oopses in the sensor
driver there I found out that the BIOS does not allow to put the
ISP in PCI mode and that there is no code to drive it in ACPI
enumerated mode.

So I moved to a generic Insyde T701 tablet which does allow
this. After fixing some more sensor driver issues there I was
ready to actually load the atomisp driver, but I could not
find the exact firmware required, I did find a version which
is close: "irci_stable_candrpv_0415_20150423_1753"
and tried that but that causes the atomisp driver to explode
in a backtrace which contains atomisp_load_firmware() so that
one seems no good.

Can someone help me to get the right firmware ?

The TODO says: "can also be extracted from the upgrade kit"
about the firmware files, but it is not clear to me what /
where the "upgrade kit" is.

More in general it would be a good idea if someone inside Intel
would try to get permission to add the firmware to linux-firmware.

Anyways I will send out the patches I've currently, once I've
the right firmware I will continue working on this.

Regards,

Hans
