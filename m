Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53601 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbcCNKYp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 06:24:45 -0400
Date: Mon, 14 Mar 2016 07:24:40 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Any reason why media_entity_pads_init() isn't void?
Message-ID: <20160314072440.6aaccd86@recife.lan>
In-Reply-To: <56E6758F.7020205@xs4all.nl>
References: <56E6758F.7020205@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Mar 2016 09:25:51 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> I was fixing a sparse warning in media_entity_pads_init() and I noticed that that
> function always returns 0. Any reason why this can't be changed to a void function?
> 
> That return value is checked a zillion times in the media code. By making it void
> it should simplify code all over.
> 
> See e.g. uvc_mc_init_entity in drivers/media/usb/uvc/uvc_entity.c: that whole
> function can become a void function itself.


This function were called media_entity_init(), and it used to have a
code that would allocate the links array. The way it is right now, I
don't see any reason to keep returning an error code.

Regards,
Mauro
