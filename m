Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59754 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbbHYKRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 06:17:50 -0400
Date: Tue, 25 Aug 2015 07:17:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v7 23/44] [media] dvbdev: add support for indirect
 interface links
Message-ID: <20150825071745.7e520c8d@recife.lan>
In-Reply-To: <55DC29AE.40700@xs4all.nl>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<c3591e8e83b785ede03633be38cb601c6284542e.1440359643.git.mchehab@osg.samsung.com>
	<55DC29AE.40700@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2015 10:39:10 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/23/15 22:17, Mauro Carvalho Chehab wrote:
> > Some interfaces indirectly control multiple entities.
> > Add support for those.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> > index 747372ba4fe1..5a2bd03f5dc0 100644
> > --- a/drivers/media/dvb-core/dvbdev.c
> > +++ b/drivers/media/dvb-core/dvbdev.c
> > @@ -440,6 +440,7 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
> >  	struct media_device *mdev = adap->mdev;
> >  	struct media_entity *entity, *tuner = NULL, *fe = NULL;
> >  	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
> > +	struct media_interface *intf;
> >  
> >  	if (!mdev)
> >  		return;
> > @@ -475,6 +476,17 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
> >  
> >  	if (demux && ca)
> >  		media_create_pad_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
> > +
> > +	/* Create indirect interface links for DVR and tuner */
> > +
> > +	list_for_each_entry(intf, &mdev->interfaces, list) {
> > +		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner)
> > +			media_create_intf_link(tuner, intf, 0);
> > +		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux)
> > +			media_create_intf_link(demux, intf, 0);
> > +	}
> 
> Shouldn't there also be a link between the CA entity and CA interface?

Good catch!

I forgot it, because the hardware I'm using to test doesn't have it.

> 
> > +
> > +
> 
> Spurious newlines at the end of the function.
> 
> >  }
> >  EXPORT_SYMBOL_GPL(dvb_create_media_graph);
> >  #endif
> > 
> 
> Regards,
> 
> 	Hans
