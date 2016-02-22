Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36946 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbcBVKX1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 05:23:27 -0500
Date: Mon, 22 Feb 2016 07:23:21 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC 1/4] media: Sanitise the reserved fields of the G_TOPOLOGY
 IOCTL arguments
Message-ID: <20160222072321.382b235d@recife.lan>
In-Reply-To: <20160222070047.2a7ee4e1@recife.lan>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
	<1456090575-28354-2-git-send-email-sakari.ailus@linux.intel.com>
	<20160222070047.2a7ee4e1@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Feb 2016 07:00:47 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Sun, 21 Feb 2016 23:36:12 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Align them up to a power of two.  
> 
> Looks OK to me, but I would comment that the structs are aligned to
> 2^n for those structs.

Hmm... on a second tought, I don't think this patch makes any sense.
As those structs will be part of an array at media_v2_topology,
this won't be aligned to a power of two, as we don't require that
the number of links, entities, etc.. to be a aligned.

Regards,
Mauro

> 
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  include/uapi/linux/media.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 6aac2f0..008d077 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -302,7 +302,7 @@ struct media_v2_entity {
> >  	__u32 id;
> >  	char name[64];		/* FIXME: move to a property? (RFC says so) */
> >  	__u32 function;		/* Main function of the entity */
> > -	__u16 reserved[12];
> > +	__u32 reserved[14];
> >  };
> >  
> >  /* Should match the specific fields at media_intf_devnode */
> > @@ -315,7 +315,7 @@ struct media_v2_interface {
> >  	__u32 id;
> >  	__u32 intf_type;
> >  	__u32 flags;
> > -	__u32 reserved[9];
> > +	__u32 reserved[13];
> >  
> >  	union {
> >  		struct media_v2_intf_devnode devnode;
> > @@ -327,7 +327,7 @@ struct media_v2_pad {
> >  	__u32 id;
> >  	__u32 entity_id;
> >  	__u32 flags;
> > -	__u16 reserved[9];
> > +	__u32 reserved[5];
> >  };
> >  
> >  struct media_v2_link {
> > @@ -335,7 +335,7 @@ struct media_v2_link {
> >  	__u32 source_id;
> >  	__u32 sink_id;
> >  	__u32 flags;
> > -	__u32 reserved[5];
> > +	__u32 reserved[4];
> >  };
> >  
> >  struct media_v2_topology {  
> 
> 


-- 
Thanks,
Mauro
