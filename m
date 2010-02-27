Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967165Ab0B0CIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 21:08:13 -0500
Message-ID: <4B887E86.50302@redhat.com>
Date: Fri, 26 Feb 2010 23:08:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Curtis Hall <curt@bluecherry.net>
CC: linux-media@vger.kernel.org
Subject: Re: [bttv] Auto detection for Provideo PV- series capture cards
References: <4B882E3A.8050604@bluecherry.net> <4B884034.8080508@redhat.com> <4B8845F1.5070608@bluecherry.net>
In-Reply-To: <4B8845F1.5070608@bluecherry.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Curtis Hall wrote:
> Mauro Carvalho Chehab wrote:
>> Let's go by parts:
>>
>> The entry for PV-150 were added at -hg tree by this changeset:
>> changeset:   784:3c31d7e0b4bc
>> user:        Gerd Knorr
>> date:        Sun Feb 22 01:59:34 2004 +0000
>> summary:     Initial revision
>>
>> Probably, this is a discontinued model, but I don't know for sure.
>>   
> We have been Provideo's US distributor since late 2004 and I've not
> heard of a PV-150 part number, and isn't not a current part number.

This is the original commit when the old maintainer created his tree. It
has all drivers there. The kernel addition is for sure older than 2004.
It is hard to dig into changes that happened before 2004/2005, since in
the past, both V4L and Kernel used different ways to manage patches.

Also, a quick research at the internet showed this site in Australia:

http://www.allthings.com.au/Digital%20Video%20Recording%20Remote%20Viewing%20Web%20Cams/Video%20Capture%20Card%20SDK%208%20Ch%204%20IC.htm

At BTTV gallery (http://www.bttv-gallery.de/), it describes PV150 as:

#  PV150
Pci card with 4 bt878's on board and a HINT PCI-PCI bridge for each
bt878 there is a i2c eeprom (CSI 24WC02P)
and a microprocessor (PIC ?) EM78P156ELP 

Maybe this model were for non-US market.

>> This one is easy:
>>   [   13.438412] bttv0: subsystem: 1830:1540 (UNKNOWN)
>>
>> As this PCI ID is not known, it is just a matter of associating the
>> PV-183
>> ID's with card 98.
>>   
> 
> I figured, thanks

Could you please send a patch for me to apply upstream?

>> Just for reference the PV-149 / PV-981 / PV-183 series cards are:
>>
>> PV-149 - 4 port, 4 BT878a chips - no forced card setting required
>> PV-155 - 16 port, 4 BT878a chips - card=77,77,77,77  (Shares the same
>> board and PCI ID / subsystem as the PV-149)
>>  
>> Hmm... PV-155 shares the same PCI ID as PV-149, but require a different
>> entry, then we shouldn't add it to the PV-150 autodetection code.
>>   
> Okay.  You can easily access four ports on the PV-155 / PV-981, but to
> access the sub (/dev/videoX,1-3) channels you need to add the modprobe
> line.

Then, maybe there are some missing subsystem ID's. In the case of PV-150
entry, it has 4 subsystem ID's. It PV-155/PV-981 are equivalent, then it
will likely have different PCI ID's for each /dev/video[0-3]. Could you
please check it with lspci?

>> The better would be to check with the manufacturer if is there a
>> way to detect between those two boards (maybe reading eeprom?).
>>
>>   
> I can find out, but getting technical data from Provideo can be more
> painful then pulling teeth.

I understand, but, without this data, we cannot add auto-detection.

>> Why do you need the card= parameter, if it shares the same subsystem
>> ID as the other PV-981 models?
> 
> I think I explained that about with the sub channels, if I'm missing
> something let me know.
> 
> Thanks!
> 


-- 

Cheers,
Mauro
