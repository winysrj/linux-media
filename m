Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63984 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932840AbdKQNAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 08:00:37 -0500
Date: Fri, 17 Nov 2017 11:00:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        <linux-kernel@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 07/11] [media] vb2: add in-fence support to QBUF
Message-ID: <20171117110025.2a49db49@vento.lan>
In-Reply-To: <422c5326-374b-487f-9ef1-594f239438f1@chromium.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
        <20171115171057.17340-8-gustavo@padovan.org>
        <422c5326-374b-487f-9ef1-594f239438f1@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Nov 2017 15:49:23 +0900
Alexandre Courbot <acourbot@chromium.org> escreveu:

> > @@ -178,6 +179,12 @@ static int vb2_queue_or_prepare_buf(struct 
> > vb2_queue *q, struct v4l2_buffer *b,
> >  		return -EINVAL;
> >  	}
> >  
> > +	if ((b->fence_fd != 0 && b->fence_fd != -1) &&  
> 
> Why do we need to consider both values invalid? Can 0 ever be a valid fence 
> fd?

Programs that don't use fences will initialize reserved2/fence_fd field
at the uAPI call to zero.

So, I guess using fd=0 here could be a problem. Anyway, I would, instead,
do:

	if ((b->fence_fd < 1) &&
		...

as other negative values are likely invalid as well.

-- 
Thanks,
Mauro
