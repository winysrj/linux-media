Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab1FSLrZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 07:47:25 -0400
Message-ID: <4DFDE1C4.7000006@redhat.com>
Date: Sun, 19 Jun 2011 08:47:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Helmut Auer <helmut@helmutauer.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Oliver Endriss <o.endriss@gmx.de>
Subject: Re: Bug: media_build always compiles with '-DDEBUG'
References: <201106182246.03051@orion.escape-edv.de> <4DFD1479.1060501@helmutauer.de> <201106182338.25983@orion.escape-edv.de> <4DFD827E.3000605@helmutauer.de>
In-Reply-To: <4DFD827E.3000605@helmutauer.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-06-2011 02:00, Helmut Auer escreveu:
> Am 18.06.2011 23:38, schrieb Oliver Endriss:
>> On Saturday 18 June 2011 23:11:21 Helmut Auer wrote:
>>> Hi
>>>>
>>>> Replacing
>>>>       ifdef CONFIG_VIDEO_OMAP3_DEBUG
>>>> by
>>>>       ifeq ($(CONFIG_VIDEO_OMAP3_DEBUG),y)
>>>> would do the trick.
>>>>
>>> I guess that would not ive the intended result.
>>> Setting CONFIG_VIDEO_OMAP3_DEBUG to yes should not lead to debug messages in all media modules,
>>
>> True, but it will happen only if you manually enable
>> CONFIG_VIDEO_OMAP3_DEBUG in Kconfig.
>>
>> You cannot avoid this without major changes of the
>> media_build system - imho not worth the effort.
>>
> Then imho it would be better to drop the  CONFIG_VIDEO_OMAP3_DEBUG variable completely, you can set CONFIG_DEBUG which would give the same results.

Good catch!

Yes, I agree that the better is to just drop CONFIG_VIDEO_OMAP3_DEBUG variable completely.
If someone wants to build with -DDEBUG, he can just use CONFIG_DEBUG.

Laurent,

Any comments?

Thanks,
Mauro
