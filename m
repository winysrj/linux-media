Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:37010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab1EMHkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 03:40:07 -0400
Message-ID: <4DCCE051.2060707@infradead.org>
Date: Fri, 13 May 2011 09:40:01 +0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [GIT PATCHES FOR 2.6.39] Fix subdev control enumeration
References: <201105021319.03696.hansverk@cisco.com> <201105122200.18449.hverkuil@xs4all.nl>
In-Reply-To: <201105122200.18449.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 12-05-2011 22:00, Hans Verkuil escreveu:
> Hi Mauro,
> 
> I haven't seen this fix appearing upstream, did it slip through the cracks?

I need to check it on my main machine. I'll probably be capable of doing it only
after my return back.
> 
> Regards,
> 
> 	Hans
> 
> On Monday, May 02, 2011 13:19:03 Hans Verkuil wrote:
>> Hi Mauro,
>>
>> This fix is for 2.6.39. Control enumeration for subdev device nodes is broken. 
>> The fix is simple and has been tested by Sakari.
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit 28df73703e738d8ae7a958350f74b08b2e9fe9ed:
>>   Mauro Carvalho Chehab (1):
>>         [media] xc5000: Improve it to work better with 6MHz-spaced channels
>>
>> are available in the git repository at:
>>
>>   ssh://linuxtv.org/git/hverkuil/media_tree.git ctrl-fix
>>
>> Hans Verkuil (1):
>>       v4l2-subdev: fix broken subdev control enumeration
>>
>>  drivers/media/video/v4l2-subdev.c |   14 +++++++-------
>>  1 files changed, 7 insertions(+), 7 deletions(-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

