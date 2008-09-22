Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1KhsC5-0003IU-Ir
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 22:39:42 +0200
Message-ID: <48D80285.4060707@ncircle.nullnet.fi>
Date: Mon, 22 Sep 2008 23:39:33 +0300
From: Tomi Orava <tomimo@ncircle.nullnet.fi>
MIME-Version: 1.0
To: Martin Dauskardt <md001@gmx.de>
References: <mailman.1.1222077601.9177.linux-dvb@linuxtv.org>
	<200809222118.38528.md001@gmx.de>
In-Reply-To: <200809222118.38528.md001@gmx.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi,

Martin Dauskardt wrote:
>> This driver has been working in
>> my own use quite well, especially after upgrading the bios to the latest
>> available version from TerraTec.
>>
>> Regards,
>> Tomi Orava
> what "bios" do you mean? the firmware?

Yes, I meant the usb device firmware.

> 
>> Could you check what is the firmware version in your device ?
>> Check for the "bcdDevice" keyword with lsusb -v -s <busid>:<devnum> I had
>> way too many problems with 1.06 firmware version, but the
>> newer 1.08 seems to be a little bit better in stability.
> I was not aware that this device uses a firmware. Do I have to flash it into 
> the box? Is this possible with Linux? Where do I find the firmware?

You can get the latest firmware from Terratec ftp-site:
ftp://ftp.terratec.net/Receiver/CinergyT2/Update/History/CinergyT2_Firmware_Update_1.08.exe

The very same directory also contains the original proprietary (NOT
BDA) windows drivers which are needed before you can use the
included flash loader. Unfortutenaly, I don't know any way to do the
update in Linux.

Regards,
Tomi Orava


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
