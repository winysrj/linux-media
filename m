Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2579 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1CNHgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 03:36:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jason Hecker <jhecker@wireless.org.au>,
	"linux-media" <linux-media@vger.kernel.org>
Subject: Re: [ANN] Agenda for the Warsaw meeting.
Date: Mon, 14 Mar 2011 08:36:22 +0100
References: <201103131331.16338.hverkuil@xs4all.nl> <AANLkTikJDt-sDaPNPipGRo7kLjLysSw4z-Yq4LOOnibg@mail.gmail.com>
In-Reply-To: <AANLkTikJDt-sDaPNPipGRo7kLjLysSw4z-Yq4LOOnibg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103140836.22353.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, March 14, 2011 05:10:53 Jason Hecker wrote:
> > B) Use of V4L2 as a frontend for SW/DSP codecs
> >   (Laurent)
> 
> This would be good.   Realtek's RT2832U chip can tune to and possibly
> demodulate DAB/DAB+ and FM along with the usual DVB-T.  Realtek does
> support DAB and FM in Windows with this part but not in Linux and in
> spite of promises from one of their developers I haven't seen anything
> from them.

When you do, make sure they post it to linux-media! FM support is part of
the V4L API. We had support for a DAB device, but it turned out that:
1) the driver hadn't worked for ages and 2) the DAB API was never reviewed
or documented, 3) the hardware wasn't available anymore, so it was removed
recently.

I'd love to help create a proper DAB API.

Regards,

	Hans

> I think it'd be good to get this part talking to the DAB
> processing routines in OpenDAB or OpenMoko as I strongly suspect the
> part can tune to and provide a digital version of the bandband signal
> for demodulation of DAB or FM in user space.
> 
> It might be a good opportunity to get a signal processing framework
> into the driver but I suspect an API to allow a user space demodulator
> to read ADC baseband data from such a device would be best and safest.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
