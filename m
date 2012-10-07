Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55377 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2JGC4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 22:56:19 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so6864114iea.19
        for <linux-media@vger.kernel.org>; Sat, 06 Oct 2012 19:56:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121006085624.128f7f2c@redhat.com>
References: <5032225A.9080305@googlemail.com>
	<50323559.7040107@redhat.com>
	<50328E22.4090805@redhat.com>
	<50337293.8050808@googlemail.com>
	<50337FF4.2030200@redhat.com>
	<5033B177.8060609@googlemail.com>
	<5033C573.2000304@redhat.com>
	<50349017.4020204@googlemail.com>
	<503521B4.6050207@redhat.com>
	<503A7097.4050709@googlemail.com>
	<505F16AD.8010909@googlemail.com>
	<20121006085624.128f7f2c@redhat.com>
Date: Sat, 6 Oct 2012 22:56:18 -0400
Message-ID: <CAGoCfiycAyFDpTvX+kJ9xChJdbQg+A-PLWencL6GN8PJYW546g@mail.gmail.com>
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace to
 the kernel ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org, hdegoede@redhat.com,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 6, 2012 at 7:56 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> AFAIKT, newer em28xx chips are using this concept. The em28xx-i2c code require
> changes to support two I2C buses, and to handle 16 bit eeproms. We never cared
> of doing that because we never needed, so far, to read anything from those
> devices' eeproms.

I actually wrote the code to read the 16-bit eeprom from the em2874,
but removed it before submitting it upstream because I was afraid
well-intentioned em28xx users trying to add support for their boards
would trash their eeprom.  This is because performing a read against a
16-bit eeprom is equivalent to a write on an 8-bit eeprom.  Hence if
the user didn't know what he/she was doing, and used the 16-bit eeprom
code against an older eeprom, the eeprom would get trashed (this
actually happened to me once when I was doing the em2874 device
support originally).

If we really want that code back in the tree, I can dig it up -- but I
won't be responsible for users killing their devices.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
