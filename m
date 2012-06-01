Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989Ab2FAOSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jun 2012 10:18:24 -0400
Message-ID: <4FC8CF38.8010507@redhat.com>
Date: Fri, 01 Jun 2012 16:18:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jason Miller <jason@milr.com>
CC: linux-media@vger.kernel.org
Subject: Re: Support for old Intel webcam
References: <loom.20120529T203303-181@post.gmane.org>
In-Reply-To: <loom.20120529T203303-181@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/29/2012 08:46 PM, Jason Miller wrote:
> I have an old Intel webcam that shows up as:
>
> Bus 002 Device 005: ID 8086:0431 Intel Corp. Intel Pro Video PC Camera
>
> My hazy memory says that this used to work on linux with the spca_50x driver,
> though I think I had to add the vendor/device ID manually to the driver.  Is
> there any way to determine which chip is used in the camera so I can try doing
> so again?

Looking at the inf file from the windows drivers it is indeed quite likely
an spca50x based chip, what you can try doing (as root) is:

modprobe gspca_spca501
cd /sys/bus/usb/drivers/spca501
echo '0x8086 0x0431' > new_id

And see if it works, if not you can also try the spca500 and
spca508 drivers. Please unplug, rmmod the last tried driver, and then replug
the device between different attempts.

Regards,

Hans
