Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:53823 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbZBAVJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 16:09:32 -0500
Message-ID: <49860F8A.1020105@kaiser-linux.li>
Date: Sun, 01 Feb 2009 22:09:30 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: christopherwanderson@columbus.rr.com
CC: linux-media@vger.kernel.org
Subject: Re: PAC7302 disassembly
References: <20090131211750.RNQ9B.74301.root@hrndva-web09-z01> <49860A9F.4030802@kaiser-linux.li>
In-Reply-To: <49860A9F.4030802@kaiser-linux.li>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas Kaiser wrote:
> christopherwanderson@columbus.rr.com wrote:
>> Can I get as much disassembly of the PAC7302 drivers with your 
>> comments next to it? I am trying to improve my webcam and currently 
>> disassembling the driver, in Vista64 with IDA Pro. (I still have the 
>> 32 bit driver files as I upgraded from xp32) I am helping on the 
>> gAIM/Pidgin voice/video chat and this driver isn't where I  would like 
>> it to be. I need better color balance, even after changing alot of 
>> options I still turn out orange quite a bit. I have Assembly 
>> expierence, I own the Intel Instruction Manuals, so figuring out the 
>> actual given driver with a little bit of help based on the current 
>> progress should not be difficult Christopher W. Anderson --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hello Christopher
> 
> Thanks for posting to linux-media@vger.kernel.org.
> 
> As I wrote you back on the private mail you send me, I don't really 
> understand what you try to tell or ask me!
> 
> What do you mean with "disassembly"? Converting the binary Windoz drive 
> to assemble code? Or looking with a hex editor into the Windowz driver 
> and figure out what the opcode is doing?
> 
> The PAC7302 Linux driver was develop by re-engineering the Windoz drive 
> with the help of usb snoop. Usb snoop 
> (http://benoit.papillault.free.fr/usbsnoop/) is a program which can log 
> the usb traffic on a Windoz box. By looking at this logs, I could figure 
> out how to control the cam (PAC7302 bridge). To find out the compression 
> Pixart is using in this chip was a long journey, too.
> 
> I suggest you get the newest driver from linuxtv.org or from
> Jean-Francois Moine site (http://moinejf.free.fr/).
> 
> Don't forget to get the newest libv4l lib from Hans de Geode. After you 
> installed this and tested the webcam, please report back how the driver 
> is working.
> 
> Anyway, when you are able to disassemble the Windowz drive, please post 
> your results here. There are some people around here how can comment 
> your outcome.
> 
> Thomas
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Sorry for replying to my own post.

I forgot to tell that there is no documentation available from Pixart. I 
tried to meet them (Pixart) the last time I was in Taiwan but they 
refused to meet me :-( (Looks like they are not interested to have there 
products running with Linux)

Thomas


