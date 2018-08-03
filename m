Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732236AbeHCQoc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 12:44:32 -0400
Date: Fri, 3 Aug 2018 11:47:44 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv5 01/12] media: add 'index' to struct media_v2_pad
Message-ID: <20180803114744.673a49ff@coco.lan>
In-Reply-To: <20180803123426.7tmsibfnpv6jdbth@valkosipuli.retiisi.org.uk>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
        <4833769.fujQdFkPkF@avalon>
        <360b9ee9-8e29-1c34-0887-182f5c91be38@xs4all.nl>
        <2727885.HQxqLs6WZl@avalon>
        <20180803123426.7tmsibfnpv6jdbth@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 3 Aug 2018 15:34:26 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> > Still thinking out loud, the fact that we can't change the size of the 
> > structures pointed to by media_v2_topology bothers me. We could add a version 
> > field to media_v2_topology that would be set by applications to tell the 
> > kernel which version of the API they expect. On the other hand, maybe we'll 
> > just do a media_v3_topology when the need arises...  
> 
> What you could to is to allocate another field for the new struct; we're
> entirely free to put whatever we want there, and the kernel would simply
> need to convert between the two. Not ideal though. Another option would be to
> explicitly convey the struct size as for the IOCTL argument itself. Both
> should probably be used sparingly.

The idea we had at the MC workshop is that anything else would be mapped
via the properties API.

So, the per-type structs will be kept on a minimal format.


Thanks,
Mauro
