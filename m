Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:8546 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1BWJaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 04:30:23 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 10:31:34 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <4D642DE2.3090705@gmail.com> <201102230910.43069.hverkuil@xs4all.nl>
In-Reply-To: <201102230910.43069.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231031.34362.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, February 23, 2011 09:10:42 Hans Verkuil wrote:
> Unfortunately, if a subdev is set to 'sample at rising edge', then that does
> not necessarily mean that the host should sample at the same edge. Depending
> on the clock line routing and the integrity of the clock signal the host may
> actually have to sample on the other edge. And yes, I've seen this.

It might be useful to give some background information regarding the sampling 
edge problems.

There are two main reasons why the sampling edge can be hardware dependent. 
The first is if the data lines go through an amplifier or something similar 
that will slightly delay the data lines compared to the clock signal. This can 
shift the edge at which you have to sample.

Actually, this may even be dependent on the clock frequency. I have not seen 
that in real life yet, but it might happen. This will complicate things even 
more since in that case you need to make a callback function in the board code 
that determines the sampling edge based on the clock frequency. I think we can 
ignore that for now, but we do need to keep it in mind.

The other is the waveform of the clock. For relatively low frequencies this 
will resemble a symmetrical square wave. But for higher frequencies this more 
resembles the bottom waveform in this picture:

http://myweb.msoe.edu/williamstm/Images/Divider2.jpg

This is asymmetric so depending on the slopes the sampling edge can make quite 
a difference.

The higher the clock frequency, the more asymmetric the waveform will look.

Regards,

	Hans
