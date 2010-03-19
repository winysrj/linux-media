Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51178 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0CSSNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 14:13:01 -0400
Received: by bwz1 with SMTP id 1so278585bwz.21
        for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 11:12:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <30353c3d1003191100q2446edeekb161dba45624489a@mail.gmail.com>
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
	 <201003190904.53867.laurent.pinchart@ideasonboard.com>
	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
	 <4BA38088.1020006@redhat.com>
	 <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>
	 <4BA3B7A9.2050405@redhat.com>
	 <30353c3d1003191100q2446edeekb161dba45624489a@mail.gmail.com>
Date: Fri, 19 Mar 2010 14:12:58 -0400
Message-ID: <829197381003191112i762baf17ta2658d859a858a76@mail.gmail.com>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Ellingsworth <david@identd.dyndns.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 19, 2010 at 2:00 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> Yes it is an old camera, but that does not mean there aren't people
> out there who still own cameras which would otherwise be usable if the
> driver worked. And sure people could just buy another camera.. but why
> replace hardware that's obviously not broken?

Because of the cost of keeping a driver in the tree for an old piece
of hardware that almost nobody has, where there is no developer
willing to maintain it, at the cost of preventing removal of a bunch
of old common infrastructure which increases the maintenance cost of
all the drivers that people do care about.

In a perfect world, it would be great to support every piece of
hardware under the sun until the end of time.  In reality though, with
limited developer resources, we sometimes have to decided that
supporting certain archaic hardware that isn't popular "just isn't
worth it".

Removing all the old V4L1 cruft will make currently maintained drivers
cleaner, faster and simpler to understand and implement, and less
likely to have bugs.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
