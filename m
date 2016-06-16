Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40379 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbcFPSzb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 14:55:31 -0400
Subject: Re: [PATCH 2/3] drivers/media/media-entity: clear media_gobj.mdev in
 _destroy()
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
 <5762D2A0.605@osg.samsung.com> <20160616184353.GB3727@swift.blarg.de>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5762F620.3010709@osg.samsung.com>
Date: Thu, 16 Jun 2016 12:55:28 -0600
MIME-Version: 1.0
In-Reply-To: <20160616184353.GB3727@swift.blarg.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 12:43 PM, Max Kellermann wrote:
> On 2016/06/16 18:24, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> On 06/15/2016 02:15 PM, Max Kellermann wrote:
>>> media_gobj_destroy() may be called twice on one instance - once by
>>> media_device_unregister() and again by dvb_media_device_free().  The
>>> function media_remove_intf_links() establishes and documents the
>>> convention that mdev==NULL means that the object is not registered,
>>> but nobody ever NULLs this variable.  So this patch really implements
>>> this behavior, and adds another mdev==NULL check to
>>> media_gobj_destroy() to protect against double removal.
>>
>> Are you seeing null pointer dereference on gobj->mdev? In any case,
>> we have to look at if there is a missing mutex hold that creates a
>> race between media_device_unregister() and dvb_media_device_free()
>>
>> I don't this patch will solve the race condition.
> 
> I think we misunderstand.  This is not about a race condition.  And
> the problem cannot be a NULL pointer dereference.
> 
> That's because nobody NULLs the pointer!

I see 7 calls to media_gobj_destroy(). In 6 cases, calling routines
fee the pointer that contains the graph_obj.

__media_device_unregister_entity() sets mdev ot null.

entity->graph_obj.mdev = NULL;

That is why I am confused when you say it never set to null.

thanks,
-- Shuah
