Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:37644 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727009AbeHFNRh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 09:17:37 -0400
Subject: Re: [RFC PATCH 0/3] Media Controller Properties
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org
References: <20180803143626.48191-1-hverkuil@xs4all.nl>
 <15936983-465a-2fa1-e14a-6d348cbffc06@xs4all.nl>
 <20180803122339.63c148f0@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <de8522fb-e1ba-e899-d1cb-3a91ba19b7e8@xs4all.nl>
Date: Mon, 6 Aug 2018 13:08:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180803122339.63c148f0@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2018 05:23 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 3 Aug 2018 17:03:20 +0200

<snip>

>>> I'm not sure about the G_TOPOLOGY ioctl handling: I went with the quickest
>>> option by renaming the old ioctl and adding a new one with property support.
> 
> Why? No need for that at the public header. Just add the needed fields at the
> end of the code and check for struct size at the ioctl handler.
> 
> It could make sense to have the old struct inside media-device.c, just
> to allow using sizeof() there.

Sorry, you need the old struct. The application may be newer than the kernel,
so if the new topology struct (with props support) doesn't work, then it has
to fall back to the old ioctl.

So applications will need to know the old size.

That said, it would be sufficient in this case to just export the old ioctl
define since the old struct layout is identical to the new (except of course
for the new fields added to the end).

E.g. add just this to media.h:

/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
#define MEDIA_IOC_G_TOPOLOGY_OLD 0xc0487c04

This brings me to another related question:

I can easily support both the old and new G_TOPOLOGY ioctls in media-device.c.
But what should I do if we add still more fields to the topology struct in
the future and so we might be called by a newer application with a G_TOPOLOGY
ioctl that has a size larger than we have now. We can either reject this
(that's what we do today in fact, hence the need for the TOPOLOGY_OLD), or we
can just accept it and zero the unknown fields at the end of the larger struct.

I think we need to do the latter, otherwise we will have to keep adding new
ioctl variants whenever we add a field.

Alternatively, we can just add a pile of reserved fields to struct media_v2_topology
which should last us for many years based on past experience with reserved fields.

Regards,

	Hans
