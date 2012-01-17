Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:48362 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2AQK6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 05:58:50 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT documentation
Date: Tue, 17 Jan 2012 11:58:35 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rupert Eibauer <Rupert.Eibauer@ces.ch>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <E1Rmmdy-0002zt-5K@www.linuxtv.org> <4F155252.2060705@redhat.com> <Pine.LNX.4.64.1201171152210.21882@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1201171152210.21882@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171158.35746.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 17 January 2012 11:54:10 Guennadi Liakhovetski wrote:
> On Tue, 17 Jan 2012, Mauro Carvalho Chehab wrote:
> > Em 17-01-2012 08:16, Guennadi Liakhovetski escreveu:
> > > Hi Hans
> > > 
> > > On Tue, 17 Jan 2012, Hans Verkuil wrote:
> > >> On Monday 16 January 2012 23:16:31 Guennadi Liakhovetski wrote:
> > >>> On Mon, 16 Jan 2012, Mauro Carvalho Chehab wrote:
> > >>>> This is an automatic generated email to let you know that the
> > >>>> following patch were queued at the
> > >>>> http://git.linuxtv.org/media_tree.git tree:
> > >>>> 
> > >>>> Subject: [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT
> > >>>> documentation Author:  Hans Verkuil <hans.verkuil@cisco.com>
> > >>>> Date:    Wed Jan 11 07:37:54 2012 -0300
> > >>> 
> > >>> [snip]
> > >>> 
> > >>>> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > >>>> b/Documentation/DocBook/media/v4l/vidioc-g-output.xml index
> > >>>> fd45f1c..4533068 100644
> > >>>> --- a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > >>>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> > >>>> @@ -61,8 +61,9 @@ desired output in an integer and call the
> > >>>> 
> > >>>>  <constant>VIDIOC_S_OUTPUT</constant> ioctl with a pointer to this
> > >>>>  integer. Side effects are possible. For example outputs may support
> > >>>>  different video standards, so the driver may implicitly switch the
> > >>>>  current
> > >>>> 
> > >>>> -standard. It is good practice to select an output before querying
> > >>>> or -negotiating any other parameters.</para>
> > >>>> +standard.
> > >>>> +standard. Because of these possible side effects applications
> > >>>> +must select an output before querying or negotiating any other
> > >>>> parameters.</para>
> > >>> 
> > >>> something seems to be wrong here.
> > >> 
> > >> Hi Guennadi!
> > >> 
> > >> What's wrong here? I've no idea what you mean.
> > >> 
> > >>>> +standard.
> > >>>> +standard. Because of these possible side effects applications
> > > 
> > > doesn't seem to make much sense?
> > 
> > Are you referring to grammar?
> 
> Sorry, am I being blind? The above seems to produce
> 
> <quote>
> different video standards, so the driver may implicitly switch the
> current standard. standard. Because of these possible side effects
> applications
> </quote>
> 
> i.e., double "standard." - one too many.

LOL! You are right, and I completely missed that :-)
I'm the one that's blind.

Mauro, can you fix this?

Thanks,

	Hans

> 
> Thanks
> Guennadi
> 
> > I think that a comma is missing there [1]:
> > 	Because of these possible side effects, applications
> > 	must select an output before querying or negotiating any other
> > 	parameters.
> > 
> > IMO, reverting the order of the explanation clause is semantically
> > better, as it bolds the need to select an output, and put the phrase at
> > the
> > 
> > cause-effect order:
> > 	Applications must select an output before querying or negotiating
> > 	any other parameters, because of these possible side effects.
> > 
> > But this is really a matter of choice. In any case, except for the
> > comma, that makes sense for me.
> > 
> > [1] Rule 4 of http://grammar.ccc.commnet.edu/grammar/commas.htm
> > 
> > 
> > Regards,
> > Mauro
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
