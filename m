Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:8475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1AFKpO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 05:45:14 -0500
Message-ID: <4D259D31.2040403@redhat.com>
Date: Thu, 06 Jan 2011 08:45:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] davinci: convert to core-assisted locking
References: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl> <B85A65D85D7EB246BE421B3FB0FBB5930247F9A81E@dbde02.ent.ti.com> <B85A65D85D7EB246BE421B3FB0FBB5930248201846@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930248201846@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 06-01-2011 08:17, Nori, Sekhar escreveu:
> Hi Mauro,
> 
> On Thu, Jan 06, 2011 at 12:10:07, Hadli, Manjunath wrote:
>> Tested for SD loopback and other IOCTLS. Reviewed the patches.
>>
>> Patch series Acked by: Manjunath Hadli <Manjunath.hadli@ti.com> 	
> 
> Shall I add these two patches as well to the pull request I sent
> yesterday[1]? These changes are localized to the DaVinci VPIF driver
> and should be safe to take in.
> 
> I can also send a separate pull request.
> 
> Let me know and I will do that way.

Just add them and re-send your pull request.

> 
> Thanks,
> Sekhar
> 
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg26594.html
> 
>> -Manju
>>
>> On Wed, Jan 05, 2011 at 22:12:38, Hans Verkuil wrote:
>>>
>>> These two patches convert vpif_capture and vpif_display to core-assisted locking and now use .unlocked_ioctl instead of .ioctl.
>>>
>>> These patches assume that the 'DaVinci VPIF: Support for DV preset and DV timings' patch series was applied first. See:
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg26594.html
>>>
>>> These patches are targeted for 2.6.38.
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>
>>
> 

