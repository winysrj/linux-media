Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46840 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbbASOxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 09:53:10 -0500
Message-ID: <54BD1A3D.7010001@xs4all.nl>
Date: Mon, 19 Jan 2015 15:52:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to .stop_streaming
 handler
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>  <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>  <Pine.LNX.4.64.1501182141400.23540@axis700.grange> <1421664620.1222.207.camel@xylophone.i.decadent.org.uk> <Pine.LNX.4.64.1501191208490.27578@axis700.grange> <alpine.DEB.2.02.1501191404570.4586@xk120>
In-Reply-To: <alpine.DEB.2.02.1501191404570.4586@xk120>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2015 03:11 PM, William Towle wrote:
> 
> On Mon, 19 Jan 2015, Guennadi Liakhovetski wrote:
> 
>>>> On Thu, 18 Dec 2014, Ben Hutchings wrote:
>>> Well, I thought that too.  Will's submission from last week has that
>>> change:
>>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/87009
> 
>> Anyway, yes, that looks better! But I would still consider keeping buffers
>> on the list in .buf_clean(), in which case you can remove it. And walk the
>> list instead of the VB2 internal buffer array, as others have pointed out.
> 
> Hi Guennadi,
>    Thanks for the clarification. Ian (when he was with us) did say "it
> was particularly difficult to understand WTH this driver was doing".
> 
>    Regarding your first point, if it's safe to skip the actions left
> in rcar_vin_videobuf_release() then I will do a further rework to
> remove it completely.

Yes, that's safe. Just remove it altogether.

The buf_init and buf_release ops are matching ops that are normally only
used if you have to do per-buffer initialization and/or release. These
are only called when the buffer memory changes. In most drivers including
this one it's not needed at all.

The same is true for rcar_vin_videobuf_init: it's pointless since the
list initialization is done implicitly when you add the buffer to a
list with list_add_tail(). Just drop the function.

Regards,

	Hans

> 
>    Regarding your second, in the patchset Ben linked to above we think
> we have the appropriate loops: a for loop for queue_buf[], and
> list_for_each_safe() for anything left in priv->capture; this is
> consistent with rcar_vin_fill_hw_slot() setting up queue_buf[] with
> pointers unlinked from priv->capture. This in turn suggests that we
> are right not to call list_del_init() in both of
> rcar_vin_stop_streaming()'s loops ... as long as I've correctly
> interpreted the code and everyone's feedback thus far.
> 
> 
> Cheers,
>    Wills.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

