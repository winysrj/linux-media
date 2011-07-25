Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46550 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1GYRNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 13:13:39 -0400
Received: by wwe5 with SMTP id 5so4281538wwe.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 10:13:38 -0700 (PDT)
Subject: Re: [beagleboard] [RFC v1] mt9v113: VGA camera sensor driver and support for BeagleBoard
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=US-ASCII
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <CAL8ugEc33uZBEz-5WxVd5aGArCRq8tv6X1K0uaJHiEVgqEfd6g@mail.gmail.com>
Date: Mon, 25 Jul 2011 19:13:32 +0200
Cc: Joel A Fernandes <agnel.joel@gmail.com>, jdk@ti.com,
	Javier Martin <javier.martin@vista-silicon.com>,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	k-kooi@ti.com, pprakash@ti.com, chase.maupin@ti.com,
	s-kipisz2@ti.com, saaguirre@ti.com
Content-Transfer-Encoding: 7BIT
Message-Id: <6F36B362-244D-4127-8E57-2E4441709159@beagleboard.org>
References: <1310581347-31102-1-git-send-email-agnel.joel@gmail.com> <CAL8ugEc33uZBEz-5WxVd5aGArCRq8tv6X1K0uaJHiEVgqEfd6g@mail.gmail.com>
To: beagleboard@googlegroups.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Op 25 jul. 2011, om 18:56 heeft Mark Grosen het volgende geschreven:

> On Wed, Jul 13, 2011 at 11:22 AM, Joel A Fernandes <agnel.joel@gmail.com> wrote:
>> * Adds support for mt9v113 sensor by borrowing heavily from PSP 2.6.37 kernel patches
>> * Adapted to changes in v4l2 framework and ISP driver
>> 
>> Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
>> ---
>> This patch will apply against the 2.6.39 kernel built from the OE-development tree (Which is essentially
>> the v2.6.39 from the main tree with OE patches for BeagleBoard support and a few other features)
>> 
>> If you have the Leapord imaging camera board with this particular sensor, I would apprecite it if anyone could
>> try this patch out and provide any feedback/test results.
>> 
>> To get the complete tree which works on a BeagleBoard-xM with all the OE patches and this patch,
>> you can clone: https://github.com/joelagnel/linux-omap-2.6/tree/oedev-2.6.39-mt9v113
>> 
>> It will compile and work on a BeagleBoard-xM with the defconfig at:
>> http://cgit.openembedded.org/cgit.cgi/openembedded/tree/recipes/linux/linux-omap-2.6.39/beagleboard/defconfig
>> 
>> Also you will need to apply my media-ctl patch (or clone the tree) to setup the formats:
>> https://github.com/joelagnel/media-ctl/commit/cdf24d1249ac1ff3cd6f70ad80c3b76ac28ba0d5
>> 
>> Binaries for quick testing on a BeagleBoard-xM:
>> U-boot: http://utdallas.edu/~joel.fernandes/u-boot.bin
>> U-boot: http://utdallas.edu/~joel.fernandes/MLO
>> uEnv.txt: http://utdallas.edu/~joel.fernandes/uEnv.txt
>> media-ctl: http://utdallas.edu/~joel.fernandes/media-ctl
>> kernel: http://utdallas.edu/~joel.fernandes/uImage
>> 
>> media-ctl/yavta commands you could use to get it to show a picture can be found at:
>> http://utdallas.edu/~joel.fernandes/stream.sh
>> 
> 
> Joel,
> 
> I gave this a try this weekend. I ran into a few problems/questions.
> 
> I wanted to try with pre-built (tested?) binaries so I grabbed yours
> (used your uImage):
> 1. media-ctl binary does not work because there is no libmediactl.so
> on my Angstrom root FS.
> 2. There was no yavta-nc application.

have you tried 'opkg update ; opkg install mediactl yavta-nc' ?