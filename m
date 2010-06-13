Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:24203 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0FMKHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 06:07:36 -0400
Received: by ey-out-2122.google.com with SMTP id 25so521645eya.19
        for <linux-media@vger.kernel.org>; Sun, 13 Jun 2010 03:07:35 -0700 (PDT)
Date: Sun, 13 Jun 2010 12:07:22 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: VDR User <user.vdr@gmail.com>
cc: "mailing list: linux-media" <linux-media@vger.kernel.org>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: [PATCH] Fix av7110 driver name
In-Reply-To: <AANLkTilYElPyhhej6XYF15D9wwBtkiMWrmkTvsviCI3W@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1006131200580.17071@localhost.localdomain>
References: <AANLkTilYElPyhhej6XYF15D9wwBtkiMWrmkTvsviCI3W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat (Saturday) 12.Jun (June) 2010, 05:10,  VDR User wrote:

> This patch simply changes the name of the av7110 driver to "AV7110"
> instead of the generic "dvb" it's set to currently.  Although it's
> somewhat trivial, it still seems appropriate to fix the name to be
> descriptive of the driver.

Thanks Derek; I'll just note that as submitted, the trivial patch
is a ``reversed'' patch, but I'd hope that any tools written for
auto-patch-handing should be able to detect this and correct this
issue.

The other patch is in ``proper'' order, so no worries.



> --- v4l-dvb/linux/drivers/media/dvb/ttpci/av7110.c      2010-06-11
> 13:24:29.000000000 -0700
> +++ v4l-dvb.orig/linux/drivers/media/dvb/ttpci/av7110.c 2010-06-11
> 12:49:50.000000000 -0700


> -       .name           = "AV7110",
> +       .name           = "dvb",


thanks,
barry bouwsma
