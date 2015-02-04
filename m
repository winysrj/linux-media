Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36028 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbbBDOOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 09:14:15 -0500
Date: Wed, 4 Feb 2015 14:14:02 +0000 (GMT)
From: William Towle <william.towle@codethink.co.uk>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 4/8] WmT: m-5mols_core style pad handling for adv7604
In-Reply-To: <CAL8zT=gQF+OeRqTU0X+eeKA1UmyNNyAfmyr5cmj6h6ALHuSF1A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1502041352230.4720@xk120.dyn.ducie.codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-5-git-send-email-william.towle@codethink.co.uk> <CAL8zT=gQF+OeRqTU0X+eeKA1UmyNNyAfmyr5cmj6h6ALHuSF1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Jean-Michel and others,

On Thu, 29 Jan 2015, Jean-Michel Hautbois wrote:
> First of all, this subject puzzles me... What means WmT ??

   That's just my initialism, to differentiate my work from that of
colleagues'. I'll submit without those in due course (and SOBs).


>> -               fmt = v4l2_subdev_get_try_format(fh, format->pad);
>> +               fmt = (fh == NULL) ? NULL
>> +                       : v4l2_subdev_get_try_format(fh, format->pad);
>> +               if (fmt == NULL)
>> +                       return EINVAL;
>> +
>
> Mmmh, Hans probably has an explanation on this, I just don't get a use
> case where fh can be NULL... So can't see the point of this patch ?

   There isn't currently a case where fh can be NULL, but we do
introduce them into rcar_vin_try_fmt() in the places where we add
v4l2_subdev_has_op() tests, which I am hoping to clarify.

   I have seen Guennadi's suggestion regarding wrapper functions, and am
also looking at the patchset Hans mentioned. In particular, the
description of "v4l2-subdev: replace v4l2_subdev_fh by
v4l2_subdev_pad_config" stands out as relevant.

   ...Thanks all, I will let you know how I get on.

Cheers,
   Wills.
