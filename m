Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:38573 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0A3Ue6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 15:34:58 -0500
Date: Sat, 30 Jan 2010 14:56:56 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: PAC7302 short datasheet from PixArt
In-Reply-To: <4B63E053.80609@freemail.hu>
Message-ID: <alpine.LNX.2.00.1001301426590.21011@banach.math.auburn.edu>
References: <4B63E053.80609@freemail.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-1772792279-1264885018=:21011"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-1772792279-1264885018=:21011
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT



On Sat, 30 Jan 2010, Németh Márton wrote:

> Hi,
>
> if anyone interested there is a brief overview datasheet about
> PixArt PAC7301/PAC7302 at
> http://www.pixart.com.tw/upload/PAC7301_7302%20%20Spec%20V1_20091228174030.pdf

Márton,

First, I am glad that mouse-copying reproduces the accent in your name. If 
you can help explain how to reproduce such things by typing while using 
apine over an ssh connection, using a standard US keyboard, I would be 
glad of the explanation. My wife is Hungarian, and I am thus very 
sensitized to the importance of the question, how to do the accents 
required for writing Hungarian properly.

Now, as to the substance of the mail above, thanks a lot. I had a bunch of 
the PixArt datasheets already, but I had missed that one. I would have a 
question, though:

This datasheet gives a lot of information about pinouts on the sensor chip 
and such good stuff which might be useful if one were constructing a 
circuit board on which to put the chip. What it does not give, very 
unfortunately, is any information about the command set which needs to be 
sent across the USB connection, which in turn actuates the circuits which 
in turn sends something to the sensor across one of those pins. For 
example, to set green gain one has to do something on connector X. But how 
does one send a command from the computer which does something on 
connector X? Some other datasheets from some other companies (Omnivision, 
for example) do seem occasionally to provide such information.

Thus, a question for you or for anyone else who reads it:

Has anyone figured out any shortcuts for matching up the missing pieces of 
information? Probably the answer is "no" but I think this is the kind of 
question which is worth asking again on some periodic basis.

Theodore Kilgore
---863829203-1772792279-1264885018=:21011--
