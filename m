Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:47780 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbZKYSO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 13:14:58 -0500
Subject: Re: Compile error saa7134 - compro videomate S350
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <623705.13034.qm@web110608.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>
	 <1259025174.5511.24.camel@pc07.localdom.local>
	 <990417.69725.qm@web110607.mail.gq1.yahoo.com>
	 <1259107698.2535.10.camel@localhost>
	 <623705.13034.qm@web110608.mail.gq1.yahoo.com>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 19:14:27 +0100
Message-Id: <1259172867.3335.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dominic,

Am Mittwoch, den 25.11.2009, 08:31 -0800 schrieb Dominic Fernandes:
> Hi Hermann,
> 
> Thanks for your reply.  I'm a little lost in what to do next.
> 
> How do I force the card to be recongised as card 169 (the compro videomate S350) instead of card 139?

unload the driver with "modprobe -vr saa7134-alsa saa7134-dvb".

You might have to close mixers using saa7134-alsa previously.
With "modinfo saa7134" you get available options.

With "modprobe -v saa7134 card=169" you can force that card then.

If we disable the T750 auto detection in saa7134-cards.c, both have to
force the correct card number.

Cheers,
Hermann



