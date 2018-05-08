Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46814 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750716AbeEHKyY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 06:54:24 -0400
Date: Tue, 8 May 2018 13:54:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 05/28] media-request: add media_request_object_find
Message-ID: <20180508105422.uu47qx35zk7uyltg@valkosipuli.retiisi.org.uk>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-6-hverkuil@xs4all.nl>
 <20180504124307.sddriagirmig4yf4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180504124307.sddriagirmig4yf4@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 04, 2018 at 03:43:07PM +0300, Sakari Ailus wrote:
> > diff --git a/include/media/media-request.h b/include/media/media-request.h
> > index 997e096d7128..5367b4a2f91c 100644
> > --- a/include/media/media-request.h
> > +++ b/include/media/media-request.h
> > @@ -196,6 +196,22 @@ static inline void media_request_object_get(struct media_request_object *obj)
> >   */
> >  void media_request_object_put(struct media_request_object *obj);
> >  
> > +/**
> > + * media_request_object_find - Find an object in a request
> > + *
> > + * @ops: Find an object with this ops value
> > + * @priv: Find an object with this priv value
> > + *
> > + * Both @ops and @priv must be non-NULL.
> > + *
> > + * Returns NULL if not found or the object pointer. The caller must
> 
> I'd describe the successful case first. I.e. "Returns the object pointer or
> NULL it not found".

Oops... "Returns the object pointer or NULL if not found".

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
