Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:43130 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbcFOUhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 16:37:55 -0400
Date: Wed, 15 Jun 2016 22:37:53 +0200
From: Max Kellermann <max@duempel.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/media/media-device: fix double free bug in
 _unregister()
Message-ID: <20160615203753.GA30666@swift.blarg.de>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602171226.9818.8828702464432665144.stgit@woodpecker.blarg.de>
 <5761BB4A.9040309@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5761BB4A.9040309@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016/06/15 22:32, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> This change introduces memory leaks, since drivers are relying on
> media_device_unregister() to free interfaces.

This is what I thought, too, until I checked the code paths.  Who adds
entries to that list?  Only media_gobj_create() does, and only when
type==MEDIA_GRAPH_INTF_DEVNODE.  That is called via
media_interface_init(), via media_devnode_create().

In the whole kernel, there are two calls to media_devnode_create():
one in dvbdev.c and another one in v4l2-dev.c.  Both callers take care
for freeing their interface.  Both would crash if somebody else would
free it for them before they get a chance to do it.  Which is the very
thing my patch addresses.

Did I miss something?

Max
