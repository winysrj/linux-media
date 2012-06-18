Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33225 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2FRMUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 08:20:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 25/32] create_bufs: handle count == 0.
Date: Mon, 18 Jun 2012 14:20:53 +0200
Message-ID: <6177744.Px5AmYjcRl@avalon>
In-Reply-To: <201206181343.22067.hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <2569605.k0h3VBEz9A@avalon> <201206181343.22067.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 June 2012 13:43:22 Hans Verkuil wrote:
> On Mon June 18 2012 12:11:27 Laurent Pinchart wrote:
> > On Sunday 10 June 2012 12:25:47 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > > 
> > >  Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > > b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml index
> > > 765549f..afdba4d 100644
> > > --- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > > +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > > @@ -97,7 +97,13 @@ information.</para>
> > > 
> > >  	  <row>
> > >  	  
> > >  	    <entry>__u32</entry>
> > >  	    <entry><structfield>count</structfield></entry>
> > > 
> > > -	    <entry>The number of buffers requested or granted.</entry>
> > > +	    <entry>The number of buffers requested or granted. If count == 0,
> > > then
> > > +	    <constant>VIDIOC_CREATE_BUFS</constant> will set
> > > <structfield>index</structfield>
> > > +	    to the starting buffer index,
> > 
> > I find "starting buffer index" a bit unclear in this context, as we don't
> > create any buffer.
> 
> How about:
> 
> ... will set index to the current number of created buffers,

Sounds good to me for now (but it won't be true anymore when we'll support 
deleting buffers individually).

> Better alternatives welcome :-)

-- 
Regards,

Laurent Pinchart

