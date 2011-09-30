Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49050 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1I3Thb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 15:37:31 -0400
Received: by wyg34 with SMTP id 34so1411797wyg.19
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 12:37:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109281350.52099.simon.farnsworth@onelan.com>
References: <201109281350.52099.simon.farnsworth@onelan.com>
Date: Fri, 30 Sep 2011 15:37:30 -0400
Message-ID: <CALzAhNW3DGtMqqhWiC2WwYiw5a4D5bc7B-P5g8mkKmGOfV1QRg@mail.gmail.com>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner)
 - workaround hack included
From: Steven Toth <stoth@kernellabs.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>                map = &std_map->atv_dk;

Simon,

I've been chewing on this for a day or so and it reminded me partly
why I stopped working on combined PAL/NTSC support for the saa7164
hardware family, it's been bugging me for a reason - now I understand
why.

Essentially, I had a long discussion with Mike Krufky about a year ago
related to I/F's for analog TV output. The SAA7164 analog demod IF (as
best as I can tell) are not configurable. I have no good set_if()
interface I can call on the tuner to select a different I/F as the
bridge driver needs. I was fairly unhappy about that..... bah, such is
life.

The TDA18271 driver on linux DOES NOT use the same I/F's that the
windows driver uses. Reason? Mike Decided to follow the data sheet and
NOT use the Hauppauge specifically select IFs.

His advise to me, at the time, which I think will work nicely for you
and probably a better patch, is to have the HVR-1110 define a better
I/F map for the atv_dk case. This way at least you would not pollute
the 18271 driver in it's core and effect other DK users (potentially),
instead, for the HVR1110 18271 attach, define the I/F maps for each
country/modulation and simple change the DK version by your desired
offset.

That may be a cleaner fix and accepted for merge.

(Note to self: Now that I recall the conversation with Mike I may
actually go ahead and fix my saa7164 Pal issue.)

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
