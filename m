Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:43088 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750703Ab0A1OC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 09:02:58 -0500
Message-ID: <4B61990E.5010604@epfl.ch>
Date: Thu, 28 Jan 2010 15:02:54 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>
Subject: Re: [Q] udev and soc-camera
References: <4B60CB5A.7000109@epfl.ch> <ac3eb2511001280118s4e00dca3l905a8ed7d532bde2@mail.gmail.com>
In-Reply-To: <ac3eb2511001280118s4e00dca3l905a8ed7d532bde2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kay Sievers wrote:
> On Thu, Jan 28, 2010 at 00:25, Valentin Longchamp
> <valentin.longchamp@epfl.ch> wrote:
>> I have a system that is built with OpenEmbedded where I use a mt9t031 camera
>> with the soc-camera framework. The mt9t031 works ok with the current kernel
>> and system.
>>
>> However, udev does not create the /dev/video0 device node. I have to create
>> it manually with mknod and then it works well. If I unbind the device on the
>> soc-camera bus (and then eventually rebind it), udev then creates the node
>> correctly. This looks like a "timing" issue at "coldstart".
>>
>> OpenEmbedded currently builds udev 141 and I am using kernel 2.6.33-rc5 (but
>> this was already like that with earlier kernels).
>>
>> Is this problem something known or has at least someone already experienced
>> that problem ?
> 
> You need to run "udevadm trigger" as the bootstrap/coldplug step,
> after you stared udev. All the devices which are already there at that
> time, will not get created by udev, only new ones which udev will see
> events for. The trigger will tell the kernel to send all events again.
> 
> Or just use the kernel's devtmpfs, and all this should work, even
> without udev, if you do not have any other needs than plain device
> nodes.
> 

Thanks a lot Kay, you pointed me exactly where I needed to watch. 
OpenEmbedded adds udevadm trigger a big list of --susbsystem-nomatch 
options as soon as you are not doing your first boot anymore and 
video4linux is among them.

I either have to remove this option in the script or understand why my 
other /dev nodes are kept (ttys are doing fine with the same treatment 
for instance) and not video4linux ones (it looks like they are using 
DEVCACHE or something like this). But I would prefer the first 
alternative since cameras may be unplugged on some robots.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEB3494, Station 9, CH-1015 Lausanne
