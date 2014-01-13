Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48178 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaAMV7a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:59:30 -0500
Message-ID: <52D461B5.7090902@gentoo.org>
Date: Mon, 13 Jan 2014 22:59:17 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Christoph Lutz <chrlutz@gmail.com>, linux-media@vger.kernel.org
CC: "Stamm Ralph (stammral)" <stammral@students.zhaw.ch>
Subject: Re: Hauppauge WinTV-HVR-930C-HD with usbId 2040:b131
References: <CAAck0wiw-coEFofZFBDP9RWuXC36f8-7t+FSkEK+E7qoUmT3kw@mail.gmail.com> <CAAck0wj9vGkmJ=2qWbFqGbsXVrjSB9b6Vovv3SJvcN7zv0SJOg@mail.gmail.com>
In-Reply-To: <CAAck0wj9vGkmJ=2qWbFqGbsXVrjSB9b6Vovv3SJvcN7zv0SJOg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.01.2014 00:08, Christoph Lutz wrote:
> typo in message body: 939C should be HVR-930C-HD
> 
> 2014/1/12 Christoph Lutz <chrlutz@gmail.com>:
>> in current wiki entries it is documented that HVR-939C-HD identifies with
>> usbId 2040:b130. Some days ago I bought a model that identifies with id
>> 2040:b131. Does anyone know more about that difference? Is b131 compatible
>> to b130? Can the new patches from Matthias Schwarzott be applied here, too?

Hi!

According to a mail I got some days ago from Ralph Stamm, this is a new
hardware revision of the HVR-930C-HD.

According to this part of the inf-file:
 ; Exeter DVB-T/C (Si2158/Si2165)
 %hcw10bda.DeviceDesc-B131%=POLARIS_XDS_Install.B131,
   USB\VID_2040&PID_B131&MI_01

the tuner was changed.

This revision is using tuner si2158 and demod si2165.
The si2165 is supported by my driver (as far as possible currently).

For Si2158, see this description
http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2158-short.pdf
I have not found a driver for this tuner.

The challange here is to write a driver for the tuner.

>>
>> I'm interested in getting my new device supported. Is there anything I can
>> do to help developing the corresponding drivers (I'm software developer but
>> have less experience with linux-kernel/drivers hacking)?

You could try to do the same as I do with the si2165 driver and start by
documenting the card in the wiki (a seperate page or just a new section
in the existing entry).
And then starting with sniffing USB traffic.

Regards
Matthias

