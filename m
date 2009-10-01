Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1554 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbZJAAYI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 20:24:08 -0400
Subject: Re: [PATCH 6/9] drivers/media/video/uvc: Use %pUr to print UUIDs
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org,
	Adrian Hunter <adrian.hunter@nokia.com>,
	Alex Elder <aelder@sgi.com>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Jeff Garzik <jgarzik@redhat.com>,
	Matt Mackall <mpm@selenic.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Neil Brown <neilb@suse.de>,
	Steven Whitehouse <swhiteho@redhat.com>,
	xfs-masters@oss.sgi.com, linux-media@vger.kernel.org
In-Reply-To: <200910010220.17534.laurent.pinchart@ideasonboard.com>
References: <cover.1254193019.git.joe@perches.com>
	 <111526fa2ce7f728d1f81465a00859c1780f0607.1254193019.git.joe@perches.com>
	 <200910010220.17534.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 17:24:10 -0700
Message-Id: <1254356650.2960.132.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-10-01 at 02:20 +0200, Laurent Pinchart wrote:
> >  		flags = info->flags;
> >  		if (((flags & UVC_CONTROL_GET_CUR) && !(inf & (1 << 0))) ||
> >  		    ((flags & UVC_CONTROL_SET_CUR) && !(inf & (1 << 1)))) {
> > -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> > -				UVC_GUID_FORMAT "/%u flags don't match "
> > -				"supported operations.\n",
> > -				UVC_GUID_ARGS(info->entity), info->selector);
> > +			uvc_trace(UVC_TRACE_CONTROL,
> > +				  "Control %pUr/%u flags don't match supported operations.\n",
> > +				  info->entity, info->selector);
> 
> This doesn't fit the 80 columns limit. Please run checkpatch.pl on your patches.

Intentional.  Strings shouldn't be broken across lines unnecessarily.

> >  			snprintf(format->name, sizeof format->name,
> > -				UVC_GUID_FORMAT, UVC_GUID_ARGS(&buffer[5]));
> > +				 "%pUr", &Buffer[5]);
> 
> Should be &buffer[5], not &Buffer[5]. You haven't compiled the patch, have
> you ? :-)

Unintentional.  Did compile allyesconfig.

cheers, Joe


