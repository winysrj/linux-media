Return-path: <mchehab@pedra>
Received: from static.88-198-183-135.clients.your-server.de ([88.198.183.135]:47170
	"EHLO v220100453032947.yourvserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab1FSFA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 01:00:56 -0400
Message-ID: <4DFD827E.3000605@helmutauer.de>
Date: Sun, 19 Jun 2011 07:00:46 +0200
From: Helmut Auer <helmut@helmutauer.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Bug: media_build always compiles with '-DDEBUG'
References: <201106182246.03051@orion.escape-edv.de> <4DFD1479.1060501@helmutauer.de> <201106182338.25983@orion.escape-edv.de>
In-Reply-To: <201106182338.25983@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 18.06.2011 23:38, schrieb Oliver Endriss:
> On Saturday 18 June 2011 23:11:21 Helmut Auer wrote:
>> Hi
>>>
>>> Replacing
>>>       ifdef CONFIG_VIDEO_OMAP3_DEBUG
>>> by
>>>       ifeq ($(CONFIG_VIDEO_OMAP3_DEBUG),y)
>>> would do the trick.
>>>
>> I guess that would not ive the intended result.
>> Setting CONFIG_VIDEO_OMAP3_DEBUG to yes should not lead to debug messages in all media modules,
>
> True, but it will happen only if you manually enable
> CONFIG_VIDEO_OMAP3_DEBUG in Kconfig.
>
> You cannot avoid this without major changes of the
> media_build system - imho not worth the effort.
>
Then imho it would be better to drop the  CONFIG_VIDEO_OMAP3_DEBUG variable completely, you can 
set CONFIG_DEBUG which would give the same results.

Bye
Helmut
