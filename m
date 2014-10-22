Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38682 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaJVJ3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 05:29:25 -0400
Message-ID: <1413970161.3107.2.camel@pengutronix.de>
Subject: Re: [media] CODA960: Fails to allocate memory
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Wed, 22 Oct 2014 11:29:21 +0200
In-Reply-To: <CAL8zT=jQ-pg8x1rqX5SFvgbtKuTsaJXdSVuMU3ocJGRUBCo3Bg@mail.gmail.com>
References: <CAL8zT=j2STDuLHW3ONw1+cOfePZceBN7yTsV1WxDjFo0bZMBaA@mail.gmail.com>
	 <54465F34.1000400@xs4all.nl>
	 <CAL8zT=herYZ9d3TKrx_5Nre0_RRRXK3Az9-NvmqGE7_SkHLzHg@mail.gmail.com>
	 <54466471.8050607@xs4all.nl>
	 <CAL8zT=jykeu33QRvj9JxhuSxV2Cg8La2J8KxVJpu+GsaE9wZnA@mail.gmail.com>
	 <1413908485.3081.4.camel@pengutronix.de>
	 <CAL8zT=hDEth-xoEr=9phzdZ9dXJMBeP9rpiTLYHwoqgf7E4tjQ@mail.gmail.com>
	 <CAL8zT=jQ-pg8x1rqX5SFvgbtKuTsaJXdSVuMU3ocJGRUBCo3Bg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

Am Mittwoch, den 22.10.2014, 11:21 +0200 schrieb Jean-Michel Hautbois:
> I may have misunderstand something...
> I try to encode, and modified the CODA_MAX_FRAME_SIZE to 0x500000 just to see.
>
> And here is the trace-cmd :
> 
> $> trace-cmd  record -e v4l2*  v4l2-ctl -d1  --stream-out-mmap
> --stream-mmap --stream-to x.raw

Are you sure /dev/video1 is the encoder device?

  $ cat /sys/class/video4linux/video12/name
  coda-encoder

  $ cat /sys/class/video4linux/video13/name
  coda-decoder

[...]
> And the bytesused is 5MB which corresponds to the 0x500000...
> How is the encoder supposed to work precisely ? I missed something...

The encoder just takes raw frames and returns encoded frames. The
bitstream ringbuffer is not involved there.

regards
Philipp

