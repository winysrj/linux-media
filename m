Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52724 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbbASOLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 09:11:55 -0500
Date: Mon, 19 Jan 2015 14:11:50 +0000 (GMT)
From: William Towle <william.towle@codethink.co.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to
 .stop_streaming handler
In-Reply-To: <Pine.LNX.4.64.1501191208490.27578@axis700.grange>
Message-ID: <alpine.DEB.2.02.1501191404570.4586@xk120>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>  <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>  <Pine.LNX.4.64.1501182141400.23540@axis700.grange> <1421664620.1222.207.camel@xylophone.i.decadent.org.uk>
 <Pine.LNX.4.64.1501191208490.27578@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mon, 19 Jan 2015, Guennadi Liakhovetski wrote:

>>> On Thu, 18 Dec 2014, Ben Hutchings wrote:
>> Well, I thought that too.  Will's submission from last week has that
>> change:
>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/87009

> Anyway, yes, that looks better! But I would still consider keeping buffers
> on the list in .buf_clean(), in which case you can remove it. And walk the
> list instead of the VB2 internal buffer array, as others have pointed out.

Hi Guennadi,
   Thanks for the clarification. Ian (when he was with us) did say "it
was particularly difficult to understand WTH this driver was doing".

   Regarding your first point, if it's safe to skip the actions left
in rcar_vin_videobuf_release() then I will do a further rework to
remove it completely.

   Regarding your second, in the patchset Ben linked to above we think
we have the appropriate loops: a for loop for queue_buf[], and
list_for_each_safe() for anything left in priv->capture; this is
consistent with rcar_vin_fill_hw_slot() setting up queue_buf[] with
pointers unlinked from priv->capture. This in turn suggests that we
are right not to call list_del_init() in both of
rcar_vin_stop_streaming()'s loops ... as long as I've correctly
interpreted the code and everyone's feedback thus far.


Cheers,
   Wills.
