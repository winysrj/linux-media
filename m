Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1945 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaIRN2w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 09:28:52 -0400
Message-ID: <541ADE07.4090805@xs4all.nl>
Date: Thu, 18 Sep 2014 15:28:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] vb2/saa7134 regression/documentation fixes
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl> <20140918095522.17ac0dc7@recife.lan>
In-Reply-To: <20140918095522.17ac0dc7@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/18/14 14:55, Mauro Carvalho Chehab wrote:
> Em Wed, 17 Sep 2014 11:14:28 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> This fixes the VBI regression seen in saa7134 when it was converted
>> to vb2. Tested with my saa7134 board.
>>
>> It also updates the poll documentation and fixes a saa7134 bug where
>> the WSS signal was never captured.
>>
>> The first patch should go to 3.17. It won't apply to older kernels,
>> so I guess once this is merged we should post a patch to stable for
>> those older kernels, certainly 3.16.
>>
>> I would expect this to be an issue for em28xx as well, but I will
>> need to test that. If that driver is affected as well, then this
>> fix needs to go into 3.9 and up.
> 
> For now:
> 
> Nacked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> 
> Changing the V4L2 API is *not* the right way to fix a regression.

Then that leaves option 4 as described by Laurent here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg79465.html

Please reply to his email rather than this one.

Regards,

	Hans
