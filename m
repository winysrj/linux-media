Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:60927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1BWOrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 09:47:05 -0500
Date: Wed, 23 Feb 2011 15:46:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <201102231517.23055.hansverk@cisco.com>
Message-ID: <Pine.LNX.4.64.1102231526510.11581@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
 <A24693684029E5489D1D202277BE894488C57571@dlee02.ent.ti.com>
 <201102231517.23055.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 23 Feb 2011, Hans Verkuil wrote:

> On Wednesday, February 23, 2011 15:06:49 Aguirre, Sergio wrote:
> > Guennadi and Hans,
> > 
> > <snip>
> > 
> > > > The only static data I am concerned about are those that affect signal
> > > integrity.
> > > > After thinking carefully about this I realized that there is really only
> > > one
> > > > setting that is relevant to that: the sampling edge. The polarities do
> > > not
> > > > matter in this.
> > 
> > I respectfully disagree.
> > 
> > AFAIK, There is not such thing as sampling edge configuration for MIPI
> > Receivers, and the polarities DO matter, since it's a differential
> > signal.
> 
> The polarities do not matter for a standard parallel bus. I cannot speak for 
> MIPI or CSI busses as I have no experience there. So if you say that 
> polarities matter for MIPI, then for MIPI those should be specified statically 
> as well.

Do I misunderstand? I interpreted Hans' proposal as: clock edge 
sensitivity is critical mainly because of high frequency, at which the 
signal integrity is harder to maintain, and therefore we cannot rely on 
automagic. Whereas sync signals are much lower frequency, and therefore 
any breakage would be easier to detect. I don't otherwise understand what 
"polarities do not matter" mean - of course they do. What am I missing?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
