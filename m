Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57438 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbbHLVHl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 17:07:41 -0400
Message-ID: <55CBB594.1070308@osg.samsung.com>
Date: Wed, 12 Aug 2015 15:07:32 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkhan@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH RFC v3 14/16] media: add a generic function to remove
 a link
References: <cover.1439410053.git.mchehab@osg.samsung.com> <68d8610deb78010dc1f923b991163f80466c4994.1439410053.git.mchehab@osg.samsung.com> <CAKocOON1GkPWjvgyCy-GDToSi5JF64RSW8k=D7jNS-pO1M633A@mail.gmail.com> <20150812175208.1f57e73e@recife.lan>
In-Reply-To: <20150812175208.1f57e73e@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2015 02:52 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 12 Aug 2015 14:45:52 -0600
> Shuah Khan <shuahkhan@gmail.com> escreveu:
> 
>> On Wed, Aug 12, 2015 at 2:14 PM, Mauro Carvalho Chehab
>> <mchehab@osg.samsung.com> wrote:
>>> Removing a link is simple. Yet, better to have a separate
>>> function for it, as we'll be also sharing it with a
>>> public API call.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> One thing to think about is whether or not we need some kind of callback
>> mechanism to alert the entity on the other side of the link and other entities
>> associated with the media device when a link is removed.
>>
>> This patch is fine for now and we can enhance it as and when we have the
>> need for such notifications.
> 
> Well, now, all elements of the graph are of the type media_graph_obj.
> 
> One of the things it is stored there is the media_device. It would
> be very easy to add a notify function[1] that would call a callback
> when a new object is created or removed. A single callback function
> could be used for any topology change.
> 
> So, I think that it is now simpler to track topology changes than
> before ;)
> 
> [1] Actually, I would implement a list with notification callbacks
> as more than one driver may want to be notified about topology
> changes.
> 

Right. It has to be a list as opposed to a single call.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
