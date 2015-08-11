Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57143 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981AbbHKLQt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 07:16:49 -0400
Date: Tue, 11 Aug 2015 08:16:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v2 13/16] media: make the internal function to
 create links more generic
Message-ID: <20150811081644.05bb088e@recife.lan>
In-Reply-To: <55C9D500.3050902@xs4all.nl>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
	<078d36a3aa5db1b692ae1b8910d0be0313bd03b9.1438954897.git.mchehab@osg.samsung.com>
	<55C9D500.3050902@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Aug 2015 12:57:04 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/07/15 16:20, Mauro Carvalho Chehab wrote:
> > In preparation to add a public function to add links, let's
> > make the internal function that creates link more generic.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 96d48aec8381..c68dc421b022 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -461,7 +461,12 @@ EXPORT_SYMBOL_GPL(media_entity_put);
> >   * Links management
> >   */
> >  
> > -static struct media_link *media_entity_add_link(struct media_entity *entity)
> > +static struct media_link *__media_create_link(struct media_device *mdev,
> > +					      enum media_graph_link_dir dir,
> 
> Am I blind? I can't find the media_graph_link_dir enum definition anywhere in
> this patch series...

There were a few patches that vger didn't seem to get. This one was added
by patch 9:
	0009-media-use-media_graph_obj-for-link-endpoints.patch

I'll try to resend the missing patches.

Regards,
Mauro
