Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:59245 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZK2E7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 23:59:23 -0500
Date: Sat, 28 Nov 2009 20:59:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	awalls@radix.net, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR system?
Message-ID: <20091129045925.GS6936@core.coreip.homeip.net>
References: <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <4B116954.5050706@s5r6.in-berlin.de> <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com> <4B117DEA.3030400@s5r6.in-berlin.de> <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com> <4B11881B.7000204@s5r6.in-berlin.de> <9e4733910911281246r65670e1free76e98ff4a23822@mail.gmail.com> <4B119A36.8020903@s5r6.in-berlin.de> <9e4733910911281410i75bf19b7xa4dfd6ad1dc1b748@mail.gmail.com> <9e4733910911281418s702489e5t418eab5623c2af98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910911281418s702489e5t418eab5623c2af98@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 05:18:34PM -0500, Jon Smirl wrote:
> I'm looking at a Sony multi-function remote right now. It has five
> devices and forty keys. Each of the five devices can transmit 0-9,
> power, volume, etc. It transmits 5*40 = 200 unique scancodes.
> 
> I want the five devices to correspond to five apps. What's the plan
> for splitting those 200 scancodes into the five apps?
> 
> I did it by creating five evdev devices each mapping 40 scancodes.
> That's lets me reuse KP_1 for each of the five apps.
> 

KEY_NUMERIC_1 please (which should not be affected by numlock state).

-- 
Dmitry
