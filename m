Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab1GQD7c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2011 23:59:32 -0400
Message-ID: <4E225E12.8040502@redhat.com>
Date: Sun, 17 Jul 2011 00:59:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Antti Palosaari <crope@iki.fi>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com> <4E1FBA6F.10509@redhat.com> <201107150717.08944@orion.escape-edv.de> <19999.63914.990114.26990@morden.metzler> <4E203FD0.4030503@redhat.com> <4E207252.5050506@linuxtv.org> <4E20D042.3000302@iki.fi> <4E21832A.20600@redhat.com> <4E219D49.1070709@iki.fi> <4E21A63A.8040008@redhat.com> <4E21B0DE.2020902@linuxtv.org> <4E21B1E6.4090302@iki.fi> <4E21B3EC.9060709@linuxtv.org> <4E223344.1080109@redhat.com> <4E2250C5.2010400@linuxtv.org>
In-Reply-To: <4E2250C5.2010400@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-07-2011 00:02, Andreas Oberritter escreveu:

>> Approach 2 limits the usage of two simultaneous fe, when they're not
>> mutually exclusive. Not sure if this is actually a problem.
> 
> This would be a problem, of course. If they're not mutually exclusive,
> then I'd expect the possibility to use them simultaneously.

>From userspace perspective, the possibility of using them simultaneously
may not actually be useful, provided that they both share the same
demux interface.

However, I agree that adding an artificial limit there doesn't seem right.

Cheers,
Mauro.
