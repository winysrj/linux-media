Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:55814 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965172Ab1GOKwA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 06:52:00 -0400
Message-ID: <4E201BC8.5000305@linuxtv.org>
Date: Fri, 15 Jul 2011 12:51:52 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.1] [media] DVB: dvb_frontend: off by one
 in	dtv_property_dump()
References: <E1Qh7ma-00025Z-5V@www.linuxtv.org> <4E1E376B.30108@linuxtv.org>
In-Reply-To: <4E1E376B.30108@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.07.2011 02:25, Andreas Oberritter wrote:
> On 13.07.2011 23:28, Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the 
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] DVB: dvb_frontend: off by one in dtv_property_dump()
>> Author:  Dan Carpenter <error27@gmail.com>
>> Date:    Thu May 26 05:44:52 2011 -0300
>>
>> If the tvp->cmd == DTV_MAX_COMMAND then we read past the end of the
>> array.

Hi Mauro,

in case you missed my comment, here's the changeset that already fixed the
issue differently:

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=3995223038d71e75def28c11d4e802f0bb7eff38

See also this thread: http://www.spinics.net/lists/linux-kernel-janitors/msg09077.html

Regards,
Andreas
