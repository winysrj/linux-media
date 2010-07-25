Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:5063 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab0GYMnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jul 2010 08:43:32 -0400
Subject: Re: cx23885: Unknown symbol __ir_input_register
From: Andy Walls <awalls@md.metrocast.net>
To: vvvl@onet.pl
Cc: linux-media@vger.kernel.org
In-Reply-To: <Q8994360-053833478ce51cd1e8a0a45c0f796b50@pmq4.m5r2.onet.test.onet.pl>
References: <Q8994360-053833478ce51cd1e8a0a45c0f796b50@pmq4.m5r2.onet.test.onet.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Jul 2010 08:44:06 -0400
Message-ID: <1280061846.2867.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-07-24 at 18:45 +0200, vvvl@onet.pl wrote:
> with linux-2.6.34-gentoo-r1 and V4L/DVB repository of July 24 I get these errors:
> cx23885: Unknown symbol __ir_input_register
> cx23885: Unknown symbol get_rc_map

Those are IR related.

I forgot to add "IR_CORE" to the Kconfig file for the cx23885 driver,
but the the "VIDEO_IR" selection in that Kconfig depends on "IR_CORE",
so I think that should be OK.

I also forgot to make sure the cx23885 driver loads the IR modules
automatically.

Please make sure that ir-core.ko and ir-common.ko were built and
installed.

Regards,
Andy


> My card is Compro Videomate E600F and i try to get it work with changes attached in diff.txt file.
> On linux-2.6.33-gentoo-r2 it works without any problems.
> 
> Thanks for any help
> Marek
> 


