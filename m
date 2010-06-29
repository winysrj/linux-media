Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47959 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab0F2U3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 16:29:21 -0400
Received: by iwn7 with SMTP id 7so41920iwn.19
        for <linux-media@vger.kernel.org>; Tue, 29 Jun 2010 13:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006292142.48380.tkrah@fachschaft.imn.htwk-leipzig.de>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
	<201006291542.27655.tkrah@fachschaft.imn.htwk-leipzig.de>
	<AANLkTin5iXho6LJP8mOPC-AIIJTi8myxZsy_V6msxSpa@mail.gmail.com>
	<201006292142.48380.tkrah@fachschaft.imn.htwk-leipzig.de>
Date: Tue, 29 Jun 2010 17:29:20 -0300
Message-ID: <AANLkTin1Bj__L4p1jEvwLO-2Wjw6-R8ICLsfb2w32jP3@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: tkrah@fachschaft.imn.htwk-leipzig.de
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Thorsten Hirsch <t.hirsch@web.de>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tue, Jun 29, 2010 at 4:42 PM, Torsten Krah
<tkrah@fachschaft.imn.htwk-leipzig.de> wrote:
> Am Dienstag, 29. Juni 2010 schrieb Douglas Schilling Landgraf:
>> The rewrite_eeprom.pl is available under git.utils tree:
>> http://git.linuxtv.org/v4l-utils.git
>>
>> All instructions are available into the source code. Let me know if
>> you have any problem with such tool.
>
> Hi, yes i have problems with the tool :-).
>
> Connected my "broken" device:
>
> lsusb:
> Bus 001 Device 002: ID eb1a:2871 eMPIA Technology, Inc.
>
> dmesg:
> [  455.348172] usb 1-1: new high speed USB device using ehci_hcd and address 2
> [  455.481791] usb 1-1: configuration #1 chosen from 1 choice
> [  455.609668] usbcore: registered new interface driver snd-usb-audio
>
>
> Running the script which does generate the recover script does work.
> But running this one fails with:
>
> Could not detect i2c bus from any device, run again ./rewrite_eeprom.pl. Did
> you forget to connect the device?
> Modules supported: em28xx saa7134
>
> Device is connected.
>
> Anything what i can do?

Could you please verify if you have  the module i2c-dev loaded?

Example:

#lsmod | grep i2c_dev
i2c_dev                 6976  0
i2c_core               21104  11
i2c_dev,lgdt330x,tuner_xc2028,tuner,tvp5150,saa7115,em28xx,v4l2_common,videodev,tveeprom,i2c_i801

If yes, please give us the output of:

#i2cdetect -l
i2c-0	smbus     	SMBus I801 adapter at ece0      	SMBus adapter
i2c-1	smbus     	em28xx #0                       	SMBus adapter
                                           ^ here my device/driver

Basically, in your case the tool is not able to recognize your device
by i2cdetect.This may happen because i2c_dev module was not able to
load?
If the module is not loaded, please load it manually and give a new try.

I did right now a test with i2c-tools 3.0.0 and 3.0.2.
http://dl.lm-sensors.org/i2c-tools/releases/

Let us know the results.

Cheers
Douglas
