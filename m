Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2659 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZFOWkb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 18:40:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 7/10 - v2] DM355 platform changes for vpfe capture driver
Date: Tue, 16 Jun 2009 00:40:16 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <200906141622.55197.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40139DF95B3@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139DF95B3@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906160040.16827.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 16 June 2009 00:24:34 Karicheri, Muralidharan wrote:
> Hans,
>
> Please see my response below.

<snip>

> >A general remark: currently you link your inputs directly to a subdev.
> > This approach has two disadvantages:
> >
> >1) It doesn't work if there are no subdevs at all (e.g. because
> > everything goes through an fpga).
>
> [MK] Not sure what you mean here. If there is an FPGA, there should be
> something to make a selection between FPGA vs the rest of the decoders.
> FPGA will have an input and there should be some way it reports the
> detected standard etc. So why can't it be implemented by a sub device
> (may be less configuration since most of the logic is in FPGA).

Hopefully my previous reply explains what I meant. I wasn't clear here 
either.

> >2) It fixes the reported order of the inputs to the order of the
> > subdevs.
>
> [MK]Is that an issue? I don't see why.

It's a minor issue. But applications typically enumerate inputs to present a 
list to the user which inputs there are. And if there are a lot then it can 
be useful to have them in a specific order. Either to group the inputs 
based on some criterium or to reflect the labeling on the box. It's a 
nice-to-have, I admit.

> >I think it is better to have a separate array of input descriptions that
> >refer to a subdev when an input is associated with that subdev.
>
> [MK] Are suggesting an link from input array entry into sub device entry
> input index?

Yes.

> How do you translate the input from application to a sub 
> device or FPGA input? What if there are two "composite" inputs on two
> different sub devices?

A "Composite 1" input would point to subdev 1 and the "Composite 2" input 
would point to subdev 2. Or do you mean something else? (I'm not sure I 
entirely understand your question)

>
> >flexible that way, and I actually think that the vpfe driver will be
> >simplified as well.
>
> [MK], Not sure at this point.

The advantage is that the ENUMINPUT and S/G_INPUT functions can do a simple 
lookup in the input array and immediately find the subdev index. Rather 
than iterating over all subdevs and counting the number of inputs in order 
to find which input belongs to which subdev.

This is probably a stronger argument than my others are :-)

Regards,

	Hans

>
> Murali
> m-karicher2@ti.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
