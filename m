Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59646 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GWQWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 12:22:42 -0400
Received: by mail-ob0-f175.google.com with SMTP id tb18so1387718obb.20
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 09:22:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA9z4LZ0jAWFfi=OpqD0iNGOFC-N_vBr6U4e_-85Yv4EK60arg@mail.gmail.com>
References: <1374594649-6061-1-git-send-email-updatelee@gmail.com>
	<CAA7C2qi1ZMGwB7C6bacU6W-jHRO_taKtng1ugb9DLzvTT3zHrQ@mail.gmail.com>
	<CAA9z4LZ0jAWFfi=OpqD0iNGOFC-N_vBr6U4e_-85Yv4EK60arg@mail.gmail.com>
Date: Tue, 23 Jul 2013 09:22:42 -0700
Message-ID: <CAA7C2qgkBCW9TjjeeB+rEEMJvCRAiUicqCYxkZ5N+BdDE-232g@mail.gmail.com>
Subject: Re: [PATCH] gp8psk: add systems supported by genpix devices to .delsys
From: VDR User <user.vdr@gmail.com>
To: Chris Lee <updatelee@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Correct, but many older userland applications used SYS_DVBS2 to tune
> before SYS_TURBO was added. I have no problem removing it but others
> might.

I think the best solution here would be not to put false info in the
driver and notify the author(s) of any apps still not updated to use
SYS_TURBO, that they need to do so or let the communities for those
apps fix it. Having the Genpix say it's dvb-s2 capable when it isn't
can be a problem in systems with actual dvb-s2 sources which is why,
iirc, SYS_TURBO was added in the first place. If nobody wants to
bother fixing those apps (to my knowledge its only mythtv that has
this problem) correctly and still wants to rely on the driver
misrepresenting the devices capabilities then it seems appropriate
that should be done in an external patch since SYS_TURBO already
exists to prevent this.
