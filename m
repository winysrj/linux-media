Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34535 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab0F2OUD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 10:20:03 -0400
Received: by iwn7 with SMTP id 7so1245116iwn.19
        for <linux-media@vger.kernel.org>; Tue, 29 Jun 2010 07:20:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006291542.27655.tkrah@fachschaft.imn.htwk-leipzig.de>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
	<AANLkTinfZ8M_NlcQFwqRQFfLmMVKKIA3aC3o8v5u7YEF@mail.gmail.com>
	<4C213608.2080709@redhat.com>
	<201006291542.27655.tkrah@fachschaft.imn.htwk-leipzig.de>
Date: Tue, 29 Jun 2010 11:20:02 -0300
Message-ID: <AANLkTin5iXho6LJP8mOPC-AIIJTi8myxZsy_V6msxSpa@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: tkrah@fachschaft.imn.htwk-leipzig.de
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Thorsten Hirsch <t.hirsch@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Torsten,

On Tue, Jun 29, 2010 at 10:42 AM, Torsten Krah
<tkrah@fachschaft.imn.htwk-leipzig.de> wrote:
> Am Mittwoch, 23. Juni 2010, um 00:15:36 schrieb Mauro Carvalho Chehab:
>> You probably damaged the contents of the device's eeprom. If you have the
>> logs with the previous eeprom contents somewhere, it is possible to recover
>> it. There's an util at v4l-utils that allows re-writing the information at
>> the eeprom.
>
> Hi,
>
> can you tell me which util and how it can be done.
> I am too affected and damaged the eeprom (don't know how) - but my usb id did
> change too from e1ba:2870 to eb1a:2871.
>
> Still need to find a old dmesg log for my stick but it should be this:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg14758.html
>
> Is this "output" enough to rewrite the correct eeprom date back to my "borked"
> stick or is something else needed?


Yes, I think it's enough, of course if it's not the right one, you
always can re-write until you
get the right eeprom. Good luck!

The rewrite_eeprom.pl is available under git.utils tree:
http://git.linuxtv.org/v4l-utils.git

All instructions are available into the source code. Let me know if
you have any problem with such tool.

BTW, maybe is a good idea to create at wikipage a page for EEPROMs.

Cheers
Douglas
