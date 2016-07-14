Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:48599 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcGNTAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 15:00:19 -0400
Subject: Re: uvcvideo
To: Charles Stegall <stegall@bayou.uni-linz.ac.at>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20160714141624.GA5718@bayou.uni-linz.ac.at>
 <39843503-ce01-3377-e990-39ca9a4fe850@mbox200.swipnet.se>
 <20160714163010.GA6891@bayou.uni-linz.ac.at>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <364e5b3d-50be-c534-86f4-724c680f41a5@mbox200.swipnet.se>
Date: Thu, 14 Jul 2016 21:00:14 +0200
MIME-Version: 1.0
In-Reply-To: <20160714163010.GA6891@bayou.uni-linz.ac.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-07-14 18:30, Charles Stegall wrote:
 > On Thu, Jul 14, 2016 at 05:10:04PM +0200, Torbjorn Jansson wrote:
 >> On 2016-07-14 16:16, Charles Stegall wrote:
 >>>
 >>> this happens ...
 >>>
 >>> modprobe uvcvideo
 >>> modprobe: ERROR: could not insert 'uvcvideo': Exec format error
 >>>
 >> did you get any interesting output in dmesg ?
 >> like problem loading modules or symbol errors?
 >>
 >> this sounds a bit like a problem i had where dmesg showed some symbol
 >> conflicts when i built drivers via media_build.
 >> but i'm no expert on this.
 >
>
> Thank you for the prompt response.
>
> pieces of log files, perhaps relevant
>
> Jul 14 13:15:26 fiji kernel: usb 2-6: new high-speed USB device number 6 using ehci-pci
> Jul 14 13:15:26 fiji kernel: usb 2-6: New USB device found, idVendor=041e, idProduct=4095
> Jul 14 13:15:26 fiji kernel: usb 2-6: New USB device strings: Mfr=3, Product=1, SerialNumber=2
> Jul 14 13:15:26 fiji kernel: usb 2-6: Product: Live! Cam Sync HD VF0770
> Jul 14 13:15:26 fiji kernel: usb 2-6: Manufacturer: Creative Technology Ltd.
> Jul 14 13:15:26 fiji kernel: usb 2-6: SerialNumber: 2014032113535
> Jul 14 13:15:26 fiji kernel: frame_vector: exports duplicate symbol frame_vector_create (owned by kernel)
> Jul 14 13:15:55 fiji kernel: frame_vector: exports duplicate symbol frame_vector_create (owned by kernel)
> Jul 14 15:44:16 fiji kernel: uvcvideo: Unknown symbol vb2_vmalloc_memops (err 0)
> Jul 14 16:04:04 fiji kernel: frame_vector: exports duplicate symbol frame_vector_create (owned by kernel)
> Jul 14 18:16:10 fiji kernel: frame_vector: exports duplicate symbol frame_vector_create (owned by kernel)
>

exactly the problem i had, Hans Verkuil pointed me in the right 
direction on solving this.

what has happened is that you most likely used media_build and it 
installed a module called frame_vector.ko but this module is already 
built into your kernel so when a module that depends on it tries to load 
things go wrong and module dont load properly.

what i did to work around this was to find the module under 
/lib/modules/`uname -r` that got installed by media_build and removed it.
then i reran 'depmod -a' to update module dependencies and problem was 
solved.

for reference see mail on linux-media list from 2016-06-26 from Hans 
with subject "Re: media_build & cx23885"

