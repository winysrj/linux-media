Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60391 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbbL1K2s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 05:28:48 -0500
Date: Mon, 28 Dec 2015 08:28:43 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] [media] media: move MEDIA_LNK_FL_INTERFACE_LINK
 logic to link creation
Message-ID: <20151228082843.181fd052@recife.lan>
In-Reply-To: <20151228003132.GV17128@valkosipuli.retiisi.org.uk>
References: <1cb01ccf2694e93040738f4dd12a86bcf8ce4994.1449865071.git.mchehab@osg.samsung.com>
	<8b0b503ba0b1246fab5519df7fe675c78989e4e9.1449865071.git.mchehab@osg.samsung.com>
	<20151228003132.GV17128@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Dec 2015 02:31:32 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> (Resending, there was an error in handling the cc field.)
> 
> On Fri, Dec 11, 2015 at 06:17:53PM -0200, Mauro Carvalho Chehab wrote:
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 181ca0de6e52..7895e17aeee9 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -526,7 +526,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
> >  
> >  	link->source = &source->pads[source_pad];
> >  	link->sink = &sink->pads[sink_pad];
> > -	link->flags = flags;
> > +	link->flags = flags && ~MEDIA_LNK_FL_INTERFACE_LINK;
> 
> s/&&/&/

Thanks for noticing it. Dan Carpenter sent a patch fixing it.

Regards,
Mauro
