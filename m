Return-path: <linux-media-owner@vger.kernel.org>
Received: from [92.246.25.51] ([92.246.25.51]:60522 "EHLO mail.multitrading.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2JHLMc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 07:12:32 -0400
Date: Mon, 8 Oct 2012 13:12:29 +0200
From: Jens Bauer <jens-lists@gpio.dk>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-media@vger.kernel.org
Message-ID: <20121008131229269874.8db8d46c@gpio.dk>
In-Reply-To: <5072A5BF.50101@schinagl.nl>
References: <20121007175602425458.288c6720@gpio.dk>
 <5072A5BF.50101@schinagl.nl>
Subject: Re: Zolid USB DVB-T Tuner Pictures
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver.

Thank you for your reply. I do think I need a little more guidance, though. ;)

I've been trying to figure out how to make just a simple change to a dot for the last hour, but always end up on the page saying that I do not have permission to edit 'this template'...
Do I need to be granted some editing rights to existing device entries ?
(I must admit that I find it a bit confusing when 'Edit' does not do what I expect, but there's probably a reason for that).

What I said below, about not having much knowledge of USB; it might have changed slightly. During the night, I've been making an application, which communicates with a USB-device I made (AVR), and it can turn on some LEDs and sometimes it can successfully receive a reply... But still, I am not an expert (not on Wiki either).


Love
Jens

On Mon, 08 Oct 2012 12:06:55 +0200, Oliver Schinagl wrote:
> On 07-10-12 17:56, Jens Bauer wrote:
>> Hi...
>> 
>> I saw on this page...
>> <http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices>
>> ...That I can contribute to the project by writing to this list.
>> 
>> Now, I don't have much knowledge about USB; I don't even have Linux 
>> (but I probably will within a few months).
>> I saw that some of the mentioned devices on the above page, are 
>> missing a picture.
>> So what I can do, is that I have a Zolid USB DVB-T Tuner "bought 
>> from Aldi - like they all are".
>> I've taken some pictures, cut them in Photoshop, scaled, saved as 
>> png and finally optimized them using pngout.
>> Sizes are: Approx. 2100x500 for the originals, 1024x500..600 for the 
>> large ones, 512x190..300 for medium-size, 128x51..80 for the smaller 
>> ones.
>> (Whoa, 5 hours work for 5 pictures!)
>> 
>> Note: This is only one device, it seems a little difficult to figure 
>> out which version it is, but as I have the original box and a 
>> USB-Probe dump, it might be possible to identify it fully.
>> 
>> What I can say, is that it uses the IT9135 chip.
>> VID/PID 0x048D/00x9135.
>> Descriptor Version Number is 0x0200.
>> Device MaxPacketSize is 64 (see below)
>> Device Version Number is 0x0200
>> It has two configurations, each configuration has 4 interfaces.
>> The first configuration's interfaces have a max packet size of 512
>> The second configuration's interfaces have a max packet size of 64.
>> Apart from that, the configurations match eachother.
>> 
>> -So my guess is that this is a v2 device.
>> 
>> When looking at the above mentioned page, and I search the table for 
>> 'Zolid', I find an entry saying "ITE Inc. Zolid Mini DVB-T Stick 
>> Version 2".
>> My box says "Mini USB DVB-T Tuner" and the markings on the device 
>> just says "SMART GROUP" "Made in Taiwan", "www.unisupport.net", 
>> "PS0712" and "05/2011".
>> (In fact, I bought exactly this device, because I believe this is 
>> the one that's listed here!)
>> 
>> ...Now...Who wants those pictures ? :)
> I think you can quite safely upload those to the wiki. I'll admit, I 
> didn't know how to upload an image, but I referenced the image from 
> the document and thus getting a missing image link in the document. 
> Clicking the link allowed me to upload said missing picture.
> 
> oliver
>> 
>> 
>> Love
>> Jens
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
