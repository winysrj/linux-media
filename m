Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46446 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813AbbLHOgw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 09:36:52 -0500
Date: Tue, 8 Dec 2015 12:36:48 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 14/55] [media] media: add functions to allow creating
 interfaces
Message-ID: <20151208123648.5a2a69fb@recife.lan>
In-Reply-To: <55F2CFC5.7010805@xs4all.nl>
References: <510dc75bdef5462b55215ba8aed120b1b7c4997d.1440902901.git.mchehab@osg.samsung.com>
	<ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<55F2CFC5.7010805@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Sep 2015 14:57:41 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/06/2015 02:02 PM, Mauro Carvalho Chehab wrote:
> > Interfaces are different than entities: they represent a
> > Kernel<->userspace interaction, while entities represent a
> > piece of hardware/firmware/software that executes a function.
> > 
> > Let's distinguish them by creating a separate structure to
> > store the interfaces.
> > 
> > Later patches should change the existing drivers and logic
> > to split the current interface embedded inside the entity
> > structure (device nodes) into a separate object of the graph.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> But see a small note below:
> 
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index a23c93369a04..dc679dfe8ade 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -44,11 +44,41 @@ static inline const char *gobj_type(enum media_gobj_type type)
> >  		return "pad";
> >  	case MEDIA_GRAPH_LINK:
> >  		return "link";
> > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > +		return "intf-devnode";
> >  	default:
> >  		return "unknown";
> >  	}
> >  }
> >  
> > +static inline const char *intf_type(struct media_interface *intf)
> > +{
> > +	switch (intf->type) {
> > +	case MEDIA_INTF_T_DVB_FE:
> > +		return "frontend";
> > +	case MEDIA_INTF_T_DVB_DEMUX:
> > +		return "demux";
> > +	case MEDIA_INTF_T_DVB_DVR:
> > +		return "DVR";
> > +	case MEDIA_INTF_T_DVB_CA:
> > +		return  "CA";
> 
> Would lower case be better? "dvr" and "ca"? Although for some reason I feel that "CA"
> is fine too. Not sure why :-)
> 
> What is the name of the associated device node? Upper or lower case? I feel that the
> name here should match the name of the device node.

Not sure if I answered that before. I opted to use upper case for DVR and 
CA because both are initials:
	DVR - Digital Video Record
	CA - Conditional Access

and initials are in upper case, in English.

The devnode names are whatever the udev rules tell ;) The Kernel actually 
asks to create DVB class devices for the first DVR and CA, located on the first
DVB adapter as:
	/dev/dvb/adapter0/dvr0
	/dev/dvb/adapter0/ca0

I don't mind changing those to lowercase to match the devnames on some
future patch, if it is a consensus that making those names matching the
device node is a requirement, but, in this case, maybe we should rename the
dvb stuff to:
	dvb/adapter/foo, in order to better reflect how they'll appear
at devfs.

Please also notice that:

+	case MEDIA_INTF_T_DVB_NET:
+		return "dvbnet";


This is also not the device node. The device node there is actually:
	/dev/dvb/adapter0/net0

So, IMHO, it is fine the way it is, as we don't want big names here
on those printks.

Regards,
Mauro
