Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57152 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964863AbbHKNDO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:03:14 -0400
Date: Tue, 11 Aug 2015 10:03:08 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 05/13] v4l: subdev: Add pad config allocator and init
Message-ID: <20150811100308.26cc76b4@recife.lan>
In-Reply-To: <55B247DC.4080606@xs4all.nl>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
	<1437654103-26409-6-git-send-email-william.towle@codethink.co.uk>
	<55B247DC.4080606@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 24 Jul 2015 16:12:44 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 07/23/2015 02:21 PM, William Towle wrote:
> > From: Laurent Pinchart <laurent.pinchart@linaro.org>
> > 
> > Add a new subdev operation to initialize a subdev pad config array, and
> > a helper function to allocate and initialize the array. This can be used
> > by bridge drivers to implement try format based on subdev pad
> > operations.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@linaro.org>
> > Acked-by: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Won't merge this patch. 

The Media Controller implementation is currently broken.

So, as agreed at the MC workshop, we won't be changing anything related
to the MC while we don't rework its implementation in order to fix its
mess.

In this particular case, we'll very likely need to replace pads from
arrays to linked lists, in order to properly support dynamic addition
and removal. If we go to that direction, the implementation of this
patch will be different.

So, it should wait for the changes.

Feel free to submit a new version of this change once we finish
with the MC rework patches.

Regards,
Mauro
