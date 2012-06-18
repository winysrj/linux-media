Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2109 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2FRLn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:43:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 25/32] create_bufs: handle count == 0.
Date: Mon, 18 Jun 2012 13:43:22 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <0b5df251d2a54d54ee2810d86b6da0cf7efbe38d.1339321562.git.hans.verkuil@cisco.com> <2569605.k0h3VBEz9A@avalon>
In-Reply-To: <2569605.k0h3VBEz9A@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181343.22067.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 12:11:27 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sunday 10 June 2012 12:25:47 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml index
> > 765549f..afdba4d 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > @@ -97,7 +97,13 @@ information.</para>
> >  	  <row>
> >  	    <entry>__u32</entry>
> >  	    <entry><structfield>count</structfield></entry>
> > -	    <entry>The number of buffers requested or granted.</entry>
> > +	    <entry>The number of buffers requested or granted. If count == 0,
> > then
> > +	    <constant>VIDIOC_CREATE_BUFS</constant> will set
> > <structfield>index</structfield>
> > +	    to the starting buffer index,
> 
> I find "starting buffer index" a bit unclear in this context, as we don't 
> create any buffer.

How about:

... will set index to the current number of created buffers,

Better alternatives welcome :-)

	Hans

> 
> > and it will check the validity of
> > +	    <structfield>memory</structfield> and
> > <structfield>format.type</structfield>.
> > +	    If those are invalid -1 is returned and errno is set to &EINVAL;,
> > +	    otherwise <constant>VIDIOC_CREATE_BUFS</constant> returns 0. It will
> > +	    never set errno to &EBUSY; in this particular case.</entry>
> >  	  </row>
> >  	  <row>
> >  	    <entry>__u32</entry>
> 
