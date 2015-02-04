Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39992 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965879AbbBDOkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 09:40:32 -0500
Message-ID: <54D22F4F.5000302@xs4all.nl>
Date: Wed, 04 Feb 2015 15:40:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	Jean-Michel Hautbois <jhautbois@gmail.com>
CC: linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 4/8] WmT: m-5mols_core style pad handling for adv7604
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-5-git-send-email-william.towle@codethink.co.uk> <CAL8zT=gQF+OeRqTU0X+eeKA1UmyNNyAfmyr5cmj6h6ALHuSF1A@mail.gmail.com> <alpine.DEB.2.02.1502041352230.4720@xk120.dyn.ducie.codethink.co.uk>
In-Reply-To: <alpine.DEB.2.02.1502041352230.4720@xk120.dyn.ducie.codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/15 15:14, William Towle wrote:
> 
> Hi Jean-Michel and others,
> 
> On Thu, 29 Jan 2015, Jean-Michel Hautbois wrote:
>> First of all, this subject puzzles me... What means WmT ??
> 
>   That's just my initialism, to differentiate my work from that of
> colleagues'. I'll submit without those in due course (and SOBs).
> 
> 
>>> -               fmt = v4l2_subdev_get_try_format(fh, format->pad);
>>> +               fmt = (fh == NULL) ? NULL
>>> +                       : v4l2_subdev_get_try_format(fh, format->pad);
>>> +               if (fmt == NULL)
>>> +                       return EINVAL;
>>> +
>>
>> Mmmh, Hans probably has an explanation on this, I just don't get a use
>> case where fh can be NULL... So can't see the point of this patch ?
> 
>   There isn't currently a case where fh can be NULL, but we do
> introduce them into rcar_vin_try_fmt() in the places where we add
> v4l2_subdev_has_op() tests, which I am hoping to clarify.
> 
>   I have seen Guennadi's suggestion regarding wrapper functions, and am
> also looking at the patchset Hans mentioned. In particular, the
> description of "v4l2-subdev: replace v4l2_subdev_fh by
> v4l2_subdev_pad_config" stands out as relevant.

FYI: I've rebased my branch to the latest media_tree master. It's
available here:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=subdev2

(the last patch fixing adv7180 conflicts will of course be properly
merged in the final version).

I might have time tomorrow to work on this a bit more.

I won't accept wrapper functions: this mess has gone on long enough
and I want to see a proper solution where the old non-pad functions
are removed so everyone uses the same APIs.

Regards,

	Hans

> 
>   ...Thanks all, I will let you know how I get on.
> 
> Cheers,
>   Wills.

