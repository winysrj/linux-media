Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34066 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758814Ab1I3VZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 17:25:22 -0400
References: <201109281350.52099.simon.farnsworth@onelan.com> <CALzAhNW3DGtMqqhWiC2WwYiw5a4D5bc7B-P5g8mkKmGOfV1QRg@mail.gmail.com>
In-Reply-To: <CALzAhNW3DGtMqqhWiC2WwYiw5a4D5bc7B-P5g8mkKmGOfV1QRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner) - workaround hack included
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 30 Sep 2011 17:25:06 -0400
To: Steven Toth <stoth@kernellabs.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>
CC: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Message-ID: <ce2d195e-f23b-4ac4-b149-15b09b53a942@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth <stoth@kernellabs.com> wrote:

>>                map = &std_map->atv_dk;
>
>Simon,
>
>I've been chewing on this for a day or so and it reminded me partly
>why I stopped working on combined PAL/NTSC support for the saa7164
>hardware family, it's been bugging me for a reason - now I understand
>why.
>
>Essentially, I had a long discussion with Mike Krufky about a year ago
>related to I/F's for analog TV output. The SAA7164 analog demod IF (as
>best as I can tell) are not configurable. I have no good set_if()
>interface I can call on the tuner to select a different I/F as the
>bridge driver needs. I was fairly unhappy about that..... bah, such is
>life.
>
>The TDA18271 driver on linux DOES NOT use the same I/F's that the
>windows driver uses. Reason? Mike Decided to follow the data sheet and
>NOT use the Hauppauge specifically select IFs.
>
>His advise to me, at the time, which I think will work nicely for you
>and probably a better patch, is to have the HVR-1110 define a better
>I/F map for the atv_dk case. This way at least you would not pollute
>the 18271 driver in it's core and effect other DK users (potentially),
>instead, for the HVR1110 18271 attach, define the I/F maps for each
>country/modulation and simple change the DK version by your desired
>offset.
>
>That may be a cleaner fix and accepted for merge.
>
>(Note to self: Now that I recall the conversation with Mike I may
>actually go ahead and fix my saa7164 Pal issue.)
>
>-- 
>Steven Toth - Kernel Labs
>http://www.kernellabs.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Simon,

If you have one of the latest HVR1600's with that analog tuner, does PAL-D work with it without and offset?

Regards,
Andy
