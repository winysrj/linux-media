Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:59176 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbATM1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 07:27:55 -0500
Date: Tue, 20 Jan 2015 12:27:52 +0000 (GMT)
From: William Towle <william.towle@codethink.co.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: William Towle <william.towle@codethink.co.uk>,
	Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to
 .stop_streaming handler
In-Reply-To: <Pine.LNX.4.64.1501191522190.27578@axis700.grange>
Message-ID: <alpine.DEB.2.02.1501201211490.4535@xk120>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>  <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>  <Pine.LNX.4.64.1501182141400.23540@axis700.grange> <1421664620.1222.207.camel@xylophone.i.decadent.org.uk>
 <Pine.LNX.4.64.1501191208490.27578@axis700.grange> <alpine.DEB.2.02.1501191404570.4586@xk120> <Pine.LNX.4.64.1501191522190.27578@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 19 Jan 2015, Guennadi Liakhovetski wrote:
> On Mon, 19 Jan 2015, William Towle wrote:
>>   in the patchset Ben linked to above we think
>> we have the appropriate loops: a for loop for queue_buf[], and
>> list_for_each_safe() for anything left in priv->capture; this is
>> consistent with rcar_vin_fill_hw_slot() setting up queue_buf[] with
>> pointers unlinked from priv->capture. This in turn suggests that we
>> are right not to call list_del_init() in both of
>> rcar_vin_stop_streaming()'s loops ... as long as I've correctly
>> interpreted the code and everyone's feedback thus far.
>
> I'm referring to this comment by Hans Verkuil of 14 August last year:
>
>> I'm assuming all buffers that are queued to the driver via buf_queue() are
>> linked into priv->capture. So you would typically call vb2_buffer_done
>> when you are walking that list:
>>
>> 	list_for_each_safe(buf_head, tmp, &priv->capture) {
>> 		// usually you go from buf_head to the real buffer struct
>> 		// containing a vb2_buffer struct
>> 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> 		list_del_init(buf_head);
>> 	}
>>
>> Please use this rather than looking into internal vb2_queue
>> datastructures.
>
> I think, that's the right way to implement that clean up loop.

Hi,
   I was describing the code in my latest patch; we start with
rcar_vin_stop_streaming() having a list_for_each_safe() loop like
that above, and leave that loop in place but add statements to it.

   I add another loop to rcar_vin_stop_streaming() [which you will
have seen -in the patch Ben published in my absence over Christmas-
was particularly inelegant initially], but it can't be rewritten in
the same way.  The new version is undeniably neater, though.

   We believe the latest patches take Hans' comment above into
account properly, and we are looking into his latest suggestion at
the moment.

Thanks again,
   Wills.
