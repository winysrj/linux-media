Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33184 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab0GDMUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jul 2010 08:20:35 -0400
Received: by iwn7 with SMTP id 7so4662218iwn.19
        for <linux-media@vger.kernel.org>; Sun, 04 Jul 2010 05:20:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201007021547.24917.tkrah@fachschaft.imn.htwk-leipzig.de>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
	<201006302116.25893.tkrah@fachschaft.imn.htwk-leipzig.de>
	<AANLkTikFtWbXKxnAcfGd2LP4fDjRFwGdNarzDUh3rxt6@mail.gmail.com>
	<201007021547.24917.tkrah@fachschaft.imn.htwk-leipzig.de>
Date: Sun, 4 Jul 2010 09:20:34 -0300
Message-ID: <AANLkTilCwvUCEWLnurCvwvwRR1xdYU7D7359WBux2_7Q@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: tkrah@fachschaft.imn.htwk-leipzig.de
Cc: Thorsten Hirsch <t.hirsch@web.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Fri, Jul 2, 2010 at 10:47 AM, Torsten Krah
<tkrah@fachschaft.imn.htwk-leipzig.de> wrote:
> Am Freitag, 2. Juli 2010, um 02:59:57 schrieb Douglas Schilling Landgraf:
>> humm, not really :-/ Are you sure em28xx/device get loaded when your
>> device is plugged?
>>
>> A good test:
>>
>> - unplug your device
>> - dmesg -c  (clear the dmesg)
>> - plug your device
>> - check your dmesg, see if there is any error or message and please
>> send to us the output.
>> - lsmod could help also.
>> - if it's ok, load the i2c modules
>
> The em28xx device gets not loaded because the usb id has changed and e1ba:2871
> is not associated to the em28xx-cards.
> the usb id is wrong like i mentioned before - that may be the cause.
> I provide you with dmesg later on.
>
> Maybe i need the patch Thorsten did too, to patch the em28xx-cards.c to get
> the "new" wrong usb id regognized as a em28xx device so that i can reflash the
> eeprom of the device. I might give this a try later this day.

Please try it, should be the root cause.

> @Thorsten: Did you reflash the device eeprom with your patched em28xx driver
> or without the patch?
>
>>
>> What's the message of rewirte_eeprom.pl? The same as Throsten?
>
> No, all ok.My distribution is lacking any i2c_smbus module - can't load this
> one. Maybe Ubuntu does not build or 2.6.32 does not habe this one (looking
> through the source i did not find it yet - maybe i missed that).

Well,in my tests never needed to  load i2c_smbus.

Let me know if you need any additional help.

Cheers
Douglas
