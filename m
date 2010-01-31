Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:51677 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0AaJ2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 04:28:51 -0500
Message-ID: <4B654D4D.20700@freemail.hu>
Date: Sun, 31 Jan 2010 10:28:45 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: PAC7302 short datasheet from PixArt
References: <4B63E053.80609@freemail.hu> <alpine.LNX.2.00.1001301426590.21011@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1001301426590.21011@banach.math.auburn.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Theodore Kilgore wrote:
> 
> On Sat, 30 Jan 2010, Németh Márton wrote:
> 
>> Hi,
>>
>> if anyone interested there is a brief overview datasheet about
>> PixArt PAC7301/PAC7302 at
>> http://www.pixart.com.tw/upload/PAC7301_7302%20%20Spec%20V1_20091228174030.pdf
>
> [...]
>
> Now, as to the substance of the mail above, thanks a lot. I had a bunch of 
> the PixArt datasheets already, but I had missed that one. I would have a 
> question, though:
> 
> This datasheet gives a lot of information about pinouts on the sensor chip 
> and such good stuff which might be useful if one were constructing a 
> circuit board on which to put the chip. What it does not give, very 
> unfortunately, is any information about the command set which needs to be 
> sent across the USB connection, which in turn actuates the circuits which 
> in turn sends something to the sensor across one of those pins. For 
> example, to set green gain one has to do something on connector X. But how 
> does one send a command from the computer which does something on 
> connector X? Some other datasheets from some other companies (Omnivision, 
> for example) do seem occasionally to provide such information.
> 
> Thus, a question for you or for anyone else who reads it:
> 
> Has anyone figured out any shortcuts for matching up the missing pieces of 
> information? Probably the answer is "no" but I think this is the kind of 
> question which is worth asking again on some periodic basis.

I have created some notes about my experiments, but they are only based on
trial-and-error. I started to created a PixArt PAC7301/PAC7302 Wiki page
this morning but the communication protocol details I could found out is
not yet finished. The page can be found at
http://linuxtv.org/wiki/index.php/PixArt_PAC7301/PAC7302 .

I hope I'll have the time to add a section about the communication protocol
details I could find out from the current gspca_pac7302 driver source code
and my experiments.

Regards,

	Márton Németh

