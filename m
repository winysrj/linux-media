Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward3.mail.yandex.net ([77.88.46.8]:38124 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2K3Cfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 21:35:31 -0500
From: CrazyCat <crazycat69@yandex.ru>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <CALF0-+UXuhvYomsn1L9tY4QHsf9VOcwdoHXHFtCjodLc49zT-w@mail.gmail.com>
References: <165401354217258@web24d.yandex.ru> <CALF0-+UXuhvYomsn1L9tY4QHsf9VOcwdoHXHFtCjodLc49zT-w@mail.gmail.com>
Subject: Re: [PATCH] stv0900: Multistream support
MIME-Version: 1.0
Message-Id: <248161354242927@web23d.yandex.ru>
Date: Fri, 30 Nov 2012 04:35:27 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes, really useless :) Need remove it:)

29.11.2012, 21:41, "Ezequiel Garcia" <elezegarcia@gmail.com>:
> Mmm, that's a pretty useless printk, IMHO.
> If someone wants to trace a driver it's better to use ftrace, again IMHO.
