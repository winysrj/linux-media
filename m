Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1KCNTJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 09:19:09 -0400
Message-ID: <4EB294C9.90204@redhat.com>
Date: Thu, 03 Nov 2011 11:19:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alain VOLMAT <alain.volmat@st.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MediaController support in LinuxDVB demux
References: <E27519AE45311C49887BE8C438E68FAA01010C61F5A6@SAFEX1MAIL1.st.com>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA01010C61F5A6@SAFEX1MAIL1.st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-11-2011 07:16, Alain VOLMAT escreveu:
> Hi
> 
> Last week we started the discussion about having a MediaController aware LinuxDVB demux and I would like to proceed on this discussion.
> Then, the discussion rapidly moved to having the requirement for dynamic pads in order to be able to add / remove then in the same way as demux filters are created for each open of the demux device node.
> 
> I am not really sure dynamic pads is really a MUST for MC aware demux device. The demux entity could work with a predefined number of output pads, determined by the vendor, depending on the demux capacity of the device.

It sounds like a plan to me.

> Of course it is probably better to have only pads when needed but it requires quite a lot of change to the overall MC framework and such modification could be done afterward, when the MC support for LinuxDVB is much better understood.

Changing the userspace API is something that should be done with care. E. g., we
should be sure that it won't break binary userspace compatibility if we change it
later.

> 
> During last workshop, I think we agreed that a pad would represent a demux filter. 
> My personal idea would be to have filters created via the demux device node and filters accessible via MC pads totally independent. 
> Meaning that, just as current demux, it is possible to open the demux device node, create filter, set PIDs etc. Those filters have totally no relation with MC pads, filters created via the demux device node are just not accessible via MC pads.
> As far as demux MC pads are concerned, it would be possible to link a pad to another entity pad (probably decoder or LinuxDVB CA) and thus create a new filter in the demux. By setting the demux MC pad format (not sure format is the proper term here), it would be possible to set for example the PID of a filter.
> Internally of course all filters (MC filters and demux device node filters) are all together but they are only accessible via either the demux device node or the MC pad.

We need to think a little more about that. In principle, it doesn't sound a good idea
to me to have filters mutually exclusive to one of the API's, but maybe there are
some implementation and/or API specific details that might force us to get on this
direction.

So, I'd say that we should try to write a patch for it first, trying to allow
setting it via both API's and then discuss about implementation-specific issues,
if this is not feasible, or would be very messy.
> 
> What are your thoughts about that ?
> 
> Regards,
> 
> Alain
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

