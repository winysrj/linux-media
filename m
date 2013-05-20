Return-path: <linux-media-owner@vger.kernel.org>
Received: from li248-118.members.linode.com ([173.255.238.118]:56989 "EHLO
	kahlo.theo.to" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755850Ab3ETSi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 14:38:59 -0400
Message-ID: <519A6DBB.60608@theo.to>
Date: Mon, 20 May 2013 14:38:51 -0400
From: Ted To <rainexpected@theo.to>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: InstantFM
References: <51993390.6080202@theo.to> <5199C8FA.9060704@redhat.com> <519A4464.7060006@theo.to>
In-Reply-To: <519A4464.7060006@theo.to>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2013 11:42 AM, Ted To wrote:
> Hi,
> 
> On 05/20/2013 02:55 AM, Hans de Goede wrote:
>> Hi,
>>
>> On 05/19/2013 10:18 PM, Ted To wrote:
>>> Hi,
>>>
>>> I purchased this device and while the device driver loads and I can set
>>> up gnomeradio to access it, it picks up no radio stations, despite being
>>> the model with an external antenna.  The log output says "software
>>> version 0, hardware version 7".  I'm running Debian Wheezy and the
>>> output from dmesg is:
>>>
>>> [66842.724036] usb 2-3: new full-speed USB device number 3 using ohci_hcd
>>> [66842.936144] usb 2-3: New USB device found, idVendor=06e1,
>>> idProduct=a155
>>> [66842.936150] usb 2-3: New USB device strings: Mfr=1, Product=2,
>>> SerialNumber=0
>>> [66842.936154] usb 2-3: Product: ADS InstantFM Music
>>> [66842.936156] usb 2-3: Manufacturer: ADS TECH
>>> [66843.275730] Linux media interface: v0.10
>>> [66843.296811] Linux video capture interface: v2.00
>>> [66843.321815] USB radio driver for Si470x FM Radio Receivers, Version
>>> 1.0.10
>>> [66843.323136] radio-si470x 2-3:1.2: DeviceID=0xffff ChipID=0xffff
>>> [66843.326127] radio-si470x 2-3:1.2: software version 0, hardware
>>> version 7
>>> [66843.326131] radio-si470x 2-3:1.2: This driver is known to work with
>>> software version 7,
>>> [66843.326135] radio-si470x 2-3:1.2: but the device has software
>>> version 0.
>>> [66843.326138] radio-si470x 2-3:1.2: If you have some trouble using this
>>> driver,
>>> [66843.326141] radio-si470x 2-3:1.2: please report to V4L ML at
>>> linux-media@vger.kernel.org
>>> [66843.338247] usbcore: registered new interface driver radio-si470x
>>> [66843.407477] usbcore: registered new interface driver snd-usb-audio
>>>
>>> Any help on what I need to do to get this working would be much
>>> appreciated.
>>
>> Can you try with the (console-based) radio app from the latest xawtv
>> release,
>> xawtv-3.103 ?
> 
>> gnomeradio is not being actively maintained, so it could be your just
>> hitting
>> a gnomeradio issue.
>>
>> Regards,
>>
>> Hans
> 
> 
> I had tried "radio" from the debian repository (version 3.102) but sadly
> it did not work.  I also tried 3.103 from the sid repository and I get
> the following error:
> 
> 	Invalid freq '138650000'. Current freq out of range?
> 
> I can get it to start if I use the "-s" option but still, nothing plays.
>  Moreover, if I give it a specific frequency, it does not start at that
> frequency.
> 
> Could the problem be that my device does not have version 7 of the
> firmware?  Google has not been helpful regarding how this can be upgraded.
> 
> Thanks,
> Ted

Actually, playing around with it some more (the version in the stable
repository), it appears to be picking something up.  "radio -s" produces
the following:

$ radio -s
baseline at 1.00
Station  0:  88.10 MHz - 4.00
Station  1:  88.90 MHz - 3.00
Station  2:  89.70 MHz - 2.00
Station  3:  91.50 MHz - 2.00
Station  4:  92.35 MHz - 3.00
Station  5:  93.10 MHz - 3.00
Station  6:  95.10 MHz - 3.00
Station  7:  95.90 MHz - 2.00
Station  8:  97.80 MHz - 4.00
Station  9:  99.10 MHz - 2.00
Station 10: 100.45 MHz - 2.00
Station 11: 101.90 MHz - 2.00
Station 12: 102.70 MHz - 2.00
Station 13: 104.25 MHz - 4.00
Station 14: 105.75 MHz - 3.00
Station 15: 106.50 MHz - 5.00
tuned 88.10 MHz

I assume that the last number is a measure of signal strength?

The problem is that no sound is produced.  FYI, gnomeradio gives a
'Could not open "/dev/mixer"!' error.  There seem to be some bugs
reported regarding this problem.

https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/613809

