Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:16336 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2AQKN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 05:13:29 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT documentation
Date: Tue, 17 Jan 2012 11:13:14 +0100
Cc: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Rupert Eibauer <Rupert.Eibauer@ces.ch>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <E1Rmmdy-0002zt-5K@www.linuxtv.org> <Pine.LNX.4.64.1201162315200.15379@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1201162315200.15379@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171113.14927.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 January 2012 23:16:31 Guennadi Liakhovetski wrote:
> On Mon, 16 Jan 2012, Mauro Carvalho Chehab wrote:
> > This is an automatic generated email to let you know that the following
> > patch were queued at the http://git.linuxtv.org/media_tree.git tree:
> > 
> > Subject: [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT documentation
> > Author:  Hans Verkuil <hans.verkuil@cisco.com>
> > Date:    Wed Jan 11 07:37:54 2012 -0300
> 
> [snip]
> 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > b/Documentation/DocBook/media/v4l/vidioc-g-output.xml index
> > fd45f1c..4533068 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > @@ -61,8 +61,9 @@ desired output in an integer and call the
> > 
> >  <constant>VIDIOC_S_OUTPUT</constant> ioctl with a pointer to this
> >  integer. Side effects are possible. For example outputs may support
> >  different video standards, so the driver may implicitly switch the
> >  current
> > 
> > -standard. It is good practice to select an output before querying or
> > -negotiating any other parameters.</para>
> > +standard.
> > +standard. Because of these possible side effects applications
> > +must select an output before querying or negotiating any other
> > parameters.</para>
> 
> something seems to be wrong here.

Hi Guennadi!

What's wrong here? I've no idea what you mean.

Regards,

	Hans
