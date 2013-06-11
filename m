Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17112 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3FKLgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 07:36:49 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO80050D893XLD0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Jun 2013 12:36:47 +0100 (BST)
Message-id: <51B70BCE.6010709@samsung.com>
Date: Tue, 11 Jun 2013 13:36:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, a.hajda@samsung.com
Subject: Re: [RFC PATCH v3 0/2] Media entity links handling
References: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
 <1370876070-23699-2-git-send-email-s.nawrocki@samsung.com>
 <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
In-reply-to: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/11/2013 12:50 PM, Sakari Ailus wrote:
> On Mon, Jun 10, 2013 at 04:54:28PM +0200, Sylwester Nawrocki wrote:
>> This is an updated version of the patch set
>> http://www.spinics.net/lists/linux-media/msg64536.html
>>
>> Comparing to v2 it includes improvements of the __media_entity_remove_links()
>> function, thanks to Sakari. 
>>
>> The cover letter of v2 is included below.
>>
>> This small patch set adds a function for removing all links at a media
>> entity. I found out such a function is needed when media entites that
>> belong to a single media device have drivers in different kernel modules.
>> This means virtually all camera drivers, since sensors are separate
>> modules from the host interface drivers.
>>
>> More details can be found at each patch's description.
>>
>> The links removal from a media entity is rather strightforward, but when
>> and where links should be created/removed is not immediately clear to me.
>>
>> I assumed that links should normally be created/removed when an entity
>> is registered to its media device, with the graph mutex held.
>>
>> I'm open to opinions whether it's good or not and possibly suggestions
>> on how those issues could be handled differently.
>>
>> The changes since original version are listed in patch 1/2, in patch 2/2
>> only the commit description has changed slightly.
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> That said, I'd wish they won't be merged before the two patches I'm sending
> shortly. The thing is that the media entity links array is freed by
> media_entity_cleanup(), and there are two drivers that call
> media_entity_cleanup() first. The patches fix the issue, so could you
> prepend them to your set (after review, naturally)?

Your patches look good, thanks a lot for inspecting those drivers! I'm going
to put all those patches on a separate branch and will hold on with sending
a pull request for a couple days.

Regards,
Sylwester
