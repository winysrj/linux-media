Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60027 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbbHZOvV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 10:51:21 -0400
Date: Wed, 26 Aug 2015 11:51:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Subject: Re: [PATCH v7 09/44] [media] media: add a debug message to warn
 about gobj creation/removal
Message-ID: <20150826115115.2d166a50@recife.lan>
In-Reply-To: <CAKocOOOpv-5XbpZyxwmd+vwpcOgCR6A_g8gAOzBdRhti2iLzOA@mail.gmail.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<1f0cabf7f3606b7ade2548820a2e03904d32f727.1440359643.git.mchehab@osg.samsung.com>
	<CAKocOOOpv-5XbpZyxwmd+vwpcOgCR6A_g8gAOzBdRhti2iLzOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2015 11:51:35 -0600
Shuah Khan <shuahkhan@gmail.com> escreveu:

> On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > It helps to check if the media controller is doing the
> > right thing with the object creation and removal.
> >
> > No extra code/data will be produced if DEBUG or
> > CONFIG_DYNAMIC_DEBUG is not enabled.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 36d725ec5f3d..6d515e149d7f 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -27,6 +27,69 @@
> >  #include <media/media-device.h>
> >
> >  /**
> > + *  dev_dbg_obj - Prints in debug mode a change on some object
> > + *
> > + * @event_name:        Name of the event to report. Could be __func__
> > + * @gobj:      Pointer to the object
> > + *
> > + * Enabled only if DEBUG or CONFIG_DYNAMIC_DEBUG. Otherwise, it
> > + * won't produce any code.
> > + */
> > +static inline const char *gobj_type(enum media_gobj_type type)
> > +{
> > +       switch (type) {
> > +       case MEDIA_GRAPH_ENTITY:
> > +               return "entity";
> > +       case MEDIA_GRAPH_PAD:
> > +               return "pad";
> > +       case MEDIA_GRAPH_LINK:
> > +               return "link";
> > +       default:
> > +               return "unknown";
> > +       }
> > +}
> > +
> 
> Shouldn't the above gobj_type be defined in if defined(DEBUG) || defined
> (CONFIG_DYNAMIC_DEBUG) scope? Unless gobj_type() is used from
> other places, you will see defined, but not used warning when DEBUG
> and CONFIG_DYNAMIC_DEBUG are undefined.

No need. The function was declared as inline. it won't be at the
text segment if not used.

> Kind of related, maybe we should be looking into adding trace event
> support for media as opposed to dynamic and debug.

I already explained why we need debug here. See the discussions of 
patch 7/8 on the previous series.

Regards,
Mauro
