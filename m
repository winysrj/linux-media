Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38533 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaLUTSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 14:18:49 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so5193627wgg.19
        for <linux-media@vger.kernel.org>; Sun, 21 Dec 2014 11:18:47 -0800 (PST)
Message-ID: <54971D13.7090508@googlemail.com>
Date: Sun, 21 Dec 2014 20:18:43 +0100
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/8] [media] em28xx: fix em28xx-input removal
References: <20141220124448.GG11285@n2100.arm.linux.org.uk> <E1Y2JPH-0006UN-SW@rmk-PC.arm.linux.org.uk> <549583AA.9040204@googlemail.com> <20141220145119.GH11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141220145119.GH11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.12.2014 um 15:51 schrieb Russell King - ARM Linux:
> On Sat, Dec 20, 2014 at 03:11:54PM +0100, Frank Schäfer wrote:
>> Hi Russel,
> I guess you won't mind if I mis-spell your name too...

Wow... it seems to be very easy to offend you...
Sorry, that was definitely not my intention. I did not do this on purpose.
It was just a simple mistake and I will try to avoid it in the future.

>
>> I'd prefer to keep the button initialization related stuff together in
>> em28xx_init_buttons() and do the cancel_delayed_work_sync() only if we
>> have buttons (dev->num_button_polling_addresses).
>> That's how we already do it with the IR work struct (see
>> em28xx_ir_suspend()).
> Provided all places that touch buttons_query_work are properly updated
> that's fine, but to me that is fragile and asking for trouble.  It's far
> better to ensure that everything is properly initialised so you don't
> have to remember to conditionalise every single reference to a work
> struct.
>
> In any case, delayed work struct initialisation is cheap - it doesn't
> involve any additional memory, it only initialises the various members
> of the struct (and the lockdep information for the static key) so there
> really is no argument against always initialising delayed works or normal
> works, timers, etc to avoid these kinds of bugs.

Fair enough !

Regards,
Frank Schäfer

