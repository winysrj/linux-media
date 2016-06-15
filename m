Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34116 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbcFOVuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 17:50:51 -0400
Subject: Re: [PATCH 3/3] drivers/media/media-device: fix double free bug in
 _unregister()
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602171226.9818.8828702464432665144.stgit@woodpecker.blarg.de>
 <5761BB4A.9040309@osg.samsung.com> <20160615203753.GA30666@swift.blarg.de>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5761CDB7.9020001@osg.samsung.com>
Date: Wed, 15 Jun 2016 15:50:47 -0600
MIME-Version: 1.0
In-Reply-To: <20160615203753.GA30666@swift.blarg.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2016 02:37 PM, Max Kellermann wrote:
> On 2016/06/15 22:32, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> This change introduces memory leaks, since drivers are relying on
>> media_device_unregister() to free interfaces.
> 
> This is what I thought, too, until I checked the code paths.  Who adds
> entries to that list?  Only media_gobj_create() does, and only when
> type==MEDIA_GRAPH_INTF_DEVNODE.  That is called via
> media_interface_init(), via media_devnode_create().
> 
> In the whole kernel, there are two calls to media_devnode_create():
> one in dvbdev.c and another one in v4l2-dev.c.  Both callers take care
> for freeing their interface.  Both would crash if somebody else would
> free it for them before they get a chance to do it.  Which is the very
> thing my patch addresses.
> 
> Did I miss something?
> 

Yes media_devnode_create() creates the interfaces links and these links
are deleted by media_devnode_remove(). media_device_unregister() still
needs to delete the interfaces links. The reason for that is the API
dynalic use-case.

Drivers (other than dvb-core and v4l2-core) can create and delete media
devnode interfaces during run-time, hence media_devnode_remove() has to
call media_remove_intf_links(). However, driver isn't required to call
media_devnode_remove() and media-core can't enforce that. So it is safe
for media_device_unregister() to remove interface links if the list isn't
empty. If driver does delete them,  media_device_unregister() has nothing
to do since the list is going to be empty.

So removing kfree() from media_device_unregister() isn't the correct
fix.

I don't see the stack trace for the double free error you are seeing? Could
it be that there is a driver problem in the order in which it is calling
media_device_unregister()?

thanks,
-- Shuah
