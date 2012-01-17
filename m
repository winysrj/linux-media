Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2AQKQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 05:16:31 -0500
Date: Tue, 17 Jan 2012 11:16:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rupert Eibauer <Rupert.Eibauer@ces.ch>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT
 documentation
In-Reply-To: <201201171113.14927.hansverk@cisco.com>
Message-ID: <Pine.LNX.4.64.1201171115300.21882@axis700.grange>
References: <E1Rmmdy-0002zt-5K@www.linuxtv.org> <Pine.LNX.4.64.1201162315200.15379@axis700.grange>
 <201201171113.14927.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Tue, 17 Jan 2012, Hans Verkuil wrote:

> On Monday 16 January 2012 23:16:31 Guennadi Liakhovetski wrote:
> > On Mon, 16 Jan 2012, Mauro Carvalho Chehab wrote:
> > > This is an automatic generated email to let you know that the following
> > > patch were queued at the http://git.linuxtv.org/media_tree.git tree:
> > > 
> > > Subject: [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT documentation
> > > Author:  Hans Verkuil <hans.verkuil@cisco.com>
> > > Date:    Wed Jan 11 07:37:54 2012 -0300
> > 
> > [snip]
> > 
> > > diff --git a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > > b/Documentation/DocBook/media/v4l/vidioc-g-output.xml index
> > > fd45f1c..4533068 100644
> > > --- a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > > +++ b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > > @@ -61,8 +61,9 @@ desired output in an integer and call the
> > > 
> > >  <constant>VIDIOC_S_OUTPUT</constant> ioctl with a pointer to this
> > >  integer. Side effects are possible. For example outputs may support
> > >  different video standards, so the driver may implicitly switch the
> > >  current
> > > 
> > > -standard. It is good practice to select an output before querying or
> > > -negotiating any other parameters.</para>
> > > +standard.
> > > +standard. Because of these possible side effects applications
> > > +must select an output before querying or negotiating any other
> > > parameters.</para>
> > 
> > something seems to be wrong here.
> 
> Hi Guennadi!
> 
> What's wrong here? I've no idea what you mean.

> > > +standard.
> > > +standard. Because of these possible side effects applications

doesn't seem to make much sense?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
