Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55705 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab0EYTfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 15:35:50 -0400
Message-ID: <4BFC2691.1040203@s5r6.in-berlin.de>
Date: Tue, 25 May 2010 21:35:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Jed <jedi.theone@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ideal DVB-C PCI/e card? [linux-media]
References: <4BF8D735.9070400@gmail.com> <4BF9717D.9080209@s5r6.in-berlin.de> <4BFA1F26.7070709@gmail.com>
In-Reply-To: <4BFA1F26.7070709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jed wrote:
> On 24/05/10 4:18 AM, Stefan Richter wrote:
>> Jed wrote:
>>> Ideally it'd be dual DVB-C, the only one I've found is more than dual
>>> DVB-C&  is far too expensive.
>>
>> If you need two receivers but can only spare up to one PCI or PCIe slot,
>> why not use two USB or FireWire attached receivers?
>>
>> FireWire ones seem to be out of production now though and weren't
>> exactly on the cheap side.  OTOH one can drive up to 3 DVB FireWire
>> receivers on a single FireWire bus; and for those who need even more
>> there are dual link FireWire PCI and PCIe cards readily available.
> 
> Thanks for offering your thoughts Stefan.
> Any specific recommendations?
>
> Ideally I want two or more dvb-c tuners in a pci/e form-factor.
>
> If there's FW or USB tuners that are mounted onto a PCI/e card, work
> well in Linux, & are relatively cheap, then I'd love to know!

I don't have an overview over USB tuners.

FireWire tuners are (or rather were) available as external boxes as well
as cards that could be mounted either in a PCI(e) slot --- but still had
to be connected to an internal or external FireWire port then --- or in
a floppy disk bay.  One tuner took up one slot or one bay.  Slot for CAM
included.

As I said, the FireWire tuners were _not_ cheap, compared to average USB
tuners or PCI tuners.  Maybe used one can be found to a somewhat better
price.  FireWire DVB tuners that were sold in the past by different
vendors were similar in hardware AFAIK, but only ones from Digital
Everywhere (called FireDTV and FloppyDTV) are supported under Linux
because DE supplied initial driver code and firmware information.

If you go for USB tuners, then I guess that you will also have to use
either external devices /or/ drive-bay mounted devices /or/ two PCI(e)
slots, since you wrote that you need CAMs --- and I doubt that there is
a cheap off-the-shelf solution that crams two CAM slots into a single
PCI slot or shares a CAM between tuners...  But as I said, I don't have
an overview.
-- 
Stefan Richter
-=====-==-=- -=-= ==--=
http://arcgraph.de/sr/
