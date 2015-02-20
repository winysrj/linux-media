Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52042 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbbBTJ7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 04:59:30 -0500
Message-ID: <54E70564.6000103@xs4all.nl>
Date: Fri, 20 Feb 2015 10:59:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Herrmann <dh.herrmann@gmail.com>,
	Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 4/7] [media] dvb core: rename the media controller entities
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>	<56874b07885afd9d58dd3d3985d6167eb9a3deea.1424273378.git.mchehab@osg.samsung.com>	<54E4B1C2.20403@xs4all.nl> <20150219173307.36b043f3@recife.lan>
In-Reply-To: <20150219173307.36b043f3@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2015 08:33 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 18 Feb 2015 16:37:38 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Mauro,
>>
>> On 02/18/2015 04:29 PM, Mauro Carvalho Chehab wrote:
>>> Prefix all DVB media controller entities with "dvb-" and use dash
>>> instead of underline at the names.
>>>
>>> Requested-by: Hans Verkuil <hverkuil@xs4all.nl>
>> 			      ^^^^^^^^^^^^^^^^^^
>>
>> For these foo-by lines please keep my hans.verkuil@cisco.com email.
>> It's my way of thanking Cisco for allowing me to do this work. Not a
>> big deal, but if you can change that before committing?
>>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> 
> Sure, I'll run a
> git filter-branch -f --msg-filter 'cat |sed s,hverkuil@xs4all.nl,hans.verkuil@cisco.com,' origin..
> 
> To replace the e-mail on this series.
> 
> Next time, it would be better if you could reply using your @cisco
> email on your From: if you want me to use it, as I generally just
> cut-and-paste whatever e-mail used at the replies ;)

My Signed-offs, acks, etc. are (almost) always with the cisco email (occasionally I
forget as well :-) ), but all my email correspondence uses my private email. Mainly
because to read my work email I need a vpn, which is a pain and which I cannot use
everywhere.

Regards,

	Hans
