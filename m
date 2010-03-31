Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0CaTUO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 15:20:14 -0400
Message-ID: <4BB3A062.7000404@redhat.com>
Date: Wed, 31 Mar 2010 16:20:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Andrzej Hajda <andrzej.hajda@wp.pl>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: cx88 remote control event device
References: <20100331130042.276d7ef7@hyperion.delvare>	<4BB38A7D.7080702@redhat.com> <20100331200938.7bd49eee@hyperion.delvare>
In-Reply-To: <20100331200938.7bd49eee@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:

> Looks very good, nice to see someone is already working on the problem.

Ok, just added there the patches for cx88 IR also.

It should be noticed that, by default, the input event is enabled just after
register, at least on Fedora 12. Probably udev/hal is doing it. I haven't
check how to disable this behavior yet. This can be useful for those that
don't want to spend power/battery or loose performance due to IR polling, or that
just don't use IR. Probably, some rule using the new /sys/class/rc is enough.

If you find some time to change this behavior, I'd appreciate if you could
update our wiki and send me a link.

Btw, don't trust yet on the rcrcv0 node there - I'll likely rename it to 
rc/rx0, for the first IR receiver device, and use rc/tx0, when we add there
some code for IR transmitter devices.

-- 

Cheers,
Mauro
