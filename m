Return-path: <mchehab@pedra>
Received: from static.88-198-183-135.clients.your-server.de ([88.198.183.135]:35770
	"EHLO v220100453032947.yourvserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab1FRVQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 17:16:55 -0400
Message-ID: <4DFD1479.1060501@helmutauer.de>
Date: Sat, 18 Jun 2011 23:11:21 +0200
From: Helmut Auer <helmut@helmutauer.de>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Bug: media_build always compiles with '-DDEBUG'
References: <201106182246.03051@orion.escape-edv.de>
In-Reply-To: <201106182246.03051@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi
>
> Replacing
>      ifdef CONFIG_VIDEO_OMAP3_DEBUG
> by
>      ifeq ($(CONFIG_VIDEO_OMAP3_DEBUG),y)
> would do the trick.
>
I guess that would not ive the intended result.
Setting CONFIG_VIDEO_OMAP3_DEBUG to yes should not lead to debug messages in all media modules,

Bye
Helmut
