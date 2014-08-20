Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45775 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaHTSAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 14:00:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: H3A module on omap4 iss
Date: Wed, 20 Aug 2014 20:00:47 +0200
Message-ID: <46978413.ceo9aCTgT3@avalon>
In-Reply-To: <CAH9_wRNTQXhqD1LNXOoS=6Vm7Xun6V49516=-3yUN-UKjoLjjw@mail.gmail.com>
References: <CAH9_wRM_CkRSRiaBDprvVONHXuZ2W6GLorqYTyA3G5N8G1Si6A@mail.gmail.com> <2048451.TcpJ3DtSY9@avalon> <CAH9_wRNTQXhqD1LNXOoS=6Vm7Xun6V49516=-3yUN-UKjoLjjw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sriram,

On Wednesday 20 August 2014 21:01:30 Sriram V wrote:
> Thanks for your response.
> 
> Going through the Datasheet & omap3isp code. what i understand is
> The code enables the H3A engine for AF, AE and AWB.
> 
> Now, the H3A produces co-efficients which need to be used for achieving
> actual AF, AE & AWB.
> 
> Now, I could not find any references where these co-efficents are used to
> do AF, AE & AWB.
> 
> My specific question is now if i need to do AF - Do you know any formula or
> algorithm which can make use of these co-coefficients and control the sensor
> motor.

I haven't worked with AF personally, I can't really help you.

> Similarly - How AWB is done with the help of these co-efficients when
> AWB is enabled?

I've implemented simple AE and AWB code for the OMAP3 ISP. You can find it at 
http://git.ideasonboard.org/omap3-isp-live.git (look at the iq_aewb_process 
function in iq.c).

The code should be considered as a proof of concept, in a real system you will 
very likely want to implement more complex AE and AWB algorithms. I'd be happy 
to receive patches that make my trivial implementation smarter :-)

-- 
Regards,

Laurent Pinchart


