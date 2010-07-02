Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65192 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0GBA76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jul 2010 20:59:58 -0400
Received: by iwn7 with SMTP id 7so2639303iwn.19
        for <linux-media@vger.kernel.org>; Thu, 01 Jul 2010 17:59:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006302116.25893.tkrah@fachschaft.imn.htwk-leipzig.de>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
	<201006292142.48380.tkrah@fachschaft.imn.htwk-leipzig.de>
	<AANLkTin1Bj__L4p1jEvwLO-2Wjw6-R8ICLsfb2w32jP3@mail.gmail.com>
	<201006302116.25893.tkrah@fachschaft.imn.htwk-leipzig.de>
Date: Thu, 1 Jul 2010 21:59:57 -0300
Message-ID: <AANLkTikFtWbXKxnAcfGd2LP4fDjRFwGdNarzDUh3rxt6@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: tkrah@fachschaft.imn.htwk-leipzig.de
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Thorsten Hirsch <t.hirsch@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Jun 30, 2010 at 4:16 PM, Torsten Krah
<tkrah@fachschaft.imn.htwk-leipzig.de> wrote:
> Am Dienstag, 29. Juni 2010 schrieben Sie:
>> Could you please verify if you have  the module i2c-dev loaded?
>
> Yes it is.
>
>>
>> Example:
>>
>> #lsmod | grep i2c_dev
>> i2c_dev                 6976  0
>> i2c_core               21104  11
>> i2c_dev,lgdt330x,tuner_xc2028,tuner,tvp5150,saa7115,em28xx,v4l2_common,vide
>> odev,tveeprom,i2c_i801
>
> #lsmod | grep i2c
> i2c_dev                 4970  0
> i2c_algo_bit            5028  1 radeon
>
>
>>
>> If yes, please give us the output of:
>>
>> #i2cdetect -l
>> i2c-0   smbus           SMBus I801 adapter at ece0              SMBus
>> adapter i2c-1   smbus           em28xx
>> #0                               SMBus adapter ^ here my device/driver
>
> Thats the output:
>
> # i2cdetect -l
> i2c-0   i2c                                                     I2C adapter
>
>
>>
>> Basically, in your case the tool is not able to recognize your device
>> by i2cdetect.This may happen because i2c_dev module was not able to
>> load?
>
> Its loaded.
>
>> If the module is not loaded, please load it manually and give a new try.
>
> Did that but still no success.
>
>>
>> I did right now a test with i2c-tools 3.0.0 and 3.0.2.
>> http://dl.lm-sensors.org/i2c-tools/releases/
>
> I am using version 3.0.2.
>
>>
>> Let us know the results.
>
>
> Did what you told but still no success using the tool - any other hints or
> things i can do?

humm, not really :-/ Are you sure em28xx/device get loaded when your
device is plugged?

A good test:

- unplug your device
- dmesg -c  (clear the dmesg)
- plug your device
- check your dmesg, see if there is any error or message and please
send to us the output.
- lsmod could help also.
- if it's ok, load the i2c modules

What's the message of rewirte_eeprom.pl? The same as Throsten?

@Thorsten, in my case never needed to load modprobed i2c-smbus also.
That's why rewrite_eeprom failed to you, the script is not looking
to load this module. Thanks for the feedback.

Cheers
Douglas
