Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:58473 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1BWPGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 10:06:11 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Wed, 23 Feb 2011 09:06:02 -0600
Subject: RE: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Message-ID: <A24693684029E5489D1D202277BE894488C5763C@dlee02.ent.ti.com>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <4D642DE2.3090705@gmail.com> <201102230910.43069.hverkuil@xs4all.nl>
 <201102231031.34362.hansverk@cisco.com>
In-Reply-To: <201102231031.34362.hansverk@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: Hans Verkuil [mailto:hansverk@cisco.com]
> Sent: Wednesday, February 23, 2011 3:32 AM
> To: Hans Verkuil
> Cc: Sylwester Nawrocki; Guennadi Liakhovetski; Stan; linux-
> media@vger.kernel.org; Laurent Pinchart; Aguirre, Sergio
> Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
> 
> On Wednesday, February 23, 2011 09:10:42 Hans Verkuil wrote:
> > Unfortunately, if a subdev is set to 'sample at rising edge', then that
> does
> > not necessarily mean that the host should sample at the same edge.
> Depending
> > on the clock line routing and the integrity of the clock signal the host
> may
> > actually have to sample on the other edge. And yes, I've seen this.
> 
> It might be useful to give some background information regarding the
> sampling
> edge problems.
> 
> There are two main reasons why the sampling edge can be hardware
> dependent.
> The first is if the data lines go through an amplifier or something
> similar
> that will slightly delay the data lines compared to the clock signal. This
> can
> shift the edge at which you have to sample.
> 
> Actually, this may even be dependent on the clock frequency. I have not
> seen
> that in real life yet, but it might happen. This will complicate things
> even
> more since in that case you need to make a callback function in the board
> code
> that determines the sampling edge based on the clock frequency. I think we
> can
> ignore that for now, but we do need to keep it in mind.
> 
> The other is the waveform of the clock. For relatively low frequencies
> this
> will resemble a symmetrical square wave. But for higher frequencies this
> more
> resembles the bottom waveform in this picture:
> 
> http://myweb.msoe.edu/williamstm/Images/Divider2.jpg
> 
> This is asymmetric so depending on the slopes the sampling edge can make
> quite
> a difference.
> 
> The higher the clock frequency, the more asymmetric the waveform will
> look.

I think this a very specific HW problem (Low slew rate), and it's something
That should be fixed in HW, or avoided in SW after proper experimentation is
done.

One example on how to fix this is described in this document:

http://www.actel.com/documents/SchmittTrigger_AN.pdf

Regards,
Sergio

> 
> Regards,
> 
> 	Hans
