Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56612 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751304AbZFYUfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 16:35:00 -0400
Date: Thu, 25 Jun 2009 22:35:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] mt9t031 - migration to sub device frame work
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139F9DEC4@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0906252229020.4663@axis700.grange>
References: <1245874609-15246-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906251944420.4663@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139F9DEC4@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(dropped moderated
"davinci-linux-open-source@linux.davincidsp.com" <davinci-linux-open-source@linux.davincidsp.com>
)

On Thu, 25 Jun 2009, Karicheri, Muralidharan wrote:

> 
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >owner@vger.kernel.org] On Behalf Of Guennadi Liakhovetski
> >Sent: Thursday, June 25, 2009 1:46 PM
> >To: Karicheri, Muralidharan
> >Cc: linux-media@vger.kernel.org; davinci-linux-open-
> >source@linux.davincidsp.com
> >Subject: Re: [PATCH] mt9t031 - migration to sub device frame work
> >
> >On Wed, 24 Jun 2009, m-karicheri2@ti.com wrote:
> >
> >> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> >>
> >> This patch migrates mt9t031 driver from SOC Camera interface to
> >> sub device interface. This is sent to get a feedback about the
> >> changes done since I am not sure if some of the functionality
> >> that is removed works okay with SOC Camera bridge driver or
> >> not. Following functions are to be discussed and added as needed:-
> >>
> >>      1) query bus parameters
> >>      2) set bus parameters
> >>      3) set crop
> >>
> >> I have tested this with vpfe capture driver and I could capture
> >> 640x480@17fps and 2048x1536@12fps resolution frames from the sensor.
> >>
> >> Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> >> Reviewed by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >
> >Excuse me? This is the first time I see this patch. FYI, "Reviewed-by"
> >means that the respective person has actually reviewed the patch and
> >submitted that line _him_ or _her_self!
> >
> >Thanks
> >Guennadi
> >
> My mistake. I was assuming that by adding this line, I can get it 
> reviewed by the mandatory reviewers. Is there a way to provide this 
> information in the patch description?

Yes, it should have been

Cc: Potential Reviewer <reviewer@provider.com>

and it would be useful to actually also cc those persons.

> Could you please review this patch and give me the comments? I had 
> exchanged emails with you in the past agreeing to do this migration. I 
> remember you had accepted the same.

Sure, I will. Hopefully tomorrow.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
