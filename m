Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1GOMIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 08:08:50 -0400
Message-ID: <4E202DCC.40006@redhat.com>
Date: Fri, 15 Jul 2011 09:08:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.1] [media] DVB: dvb_frontend: off by one
 in	dtv_property_dump()
References: <E1Qh7ma-00025Z-5V@www.linuxtv.org> <4E1E376B.30108@linuxtv.org> <4E201BC8.5000305@linuxtv.org>
In-Reply-To: <4E201BC8.5000305@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-07-2011 07:51, Andreas Oberritter escreveu:
> On 14.07.2011 02:25, Andreas Oberritter wrote:
>> On 13.07.2011 23:28, Mauro Carvalho Chehab wrote:
>>> This is an automatic generated email to let you know that the following patch were queued at the 
>>> http://git.linuxtv.org/media_tree.git tree:
>>>
>>> Subject: [media] DVB: dvb_frontend: off by one in dtv_property_dump()
>>> Author:  Dan Carpenter <error27@gmail.com>
>>> Date:    Thu May 26 05:44:52 2011 -0300
>>>
>>> If the tvp->cmd == DTV_MAX_COMMAND then we read past the end of the
>>> array.
> 
> Hi Mauro,
> 
> in case you missed my comment, here's the changeset that already fixed the
> issue differently:
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=3995223038d71e75def28c11d4e802f0bb7eff38
> 
> See also this thread: http://www.spinics.net/lists/linux-kernel-janitors/msg09077.html

Ah, thanks for remind me!

Yeah, I followed that tread and applied the right place, but hundreds of patches later,
and patchwork 'blaming' me of not committing or rejecting that patch, I ended by applying
the wrong version also. Thanks for pointing me!

I've reverted the wrong patch at the tree.

Thanks!
Mauro
