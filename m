Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4857 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbZLOVU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 16:20:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH - v1 4/6] V4L - vpfe_capture bug fix and enhancements
Date: Tue, 15 Dec 2009 22:20:41 +0100
Cc: linux-media@vger.kernel.org, khilman@deeprootsystems.com,
	nsekhar@ti.com, hvaibhav@ti.com,
	davinci-linux-open-source@linux.davincidsp.com
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com> <1260464429-10537-6-git-send-email-m-karicheri2@ti.com> <200912152205.25491.hverkuil@xs4all.nl>
In-Reply-To: <200912152205.25491.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <200912152220.41459.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note that the other patches from this series are fine as far as I am concerned.

One general note: I always have difficulties with constructions like this:

> +                     val = (bc->horz.win_count_calc &
> +                             ISIF_HORZ_BC_WIN_COUNT_MASK) |
> +                             ((!!bc->horz.base_win_sel_calc) <<
> +                             ISIF_HORZ_BC_WIN_SEL_SHIFT) |
> +                             ((!!bc->horz.clamp_pix_limit) <<
> +                             ISIF_HORZ_BC_PIX_LIMIT_SHIFT) |
> +                             ((bc->horz.win_h_sz_calc &
> +                             ISIF_HORZ_BC_WIN_H_SIZE_MASK) <<
> +                             ISIF_HORZ_BC_WIN_H_SIZE_SHIFT) |
> +                             ((bc->horz.win_v_sz_calc &
> +                             ISIF_HORZ_BC_WIN_V_SIZE_MASK) <<
> +                             ISIF_HORZ_BC_WIN_V_SIZE_SHIFT);

It's just about impossible for me to parse. And some of the patches in this
series are full of such constructs.

Unfortunately, I do not have a magic bullet solution. In some cases I suspect
that a static inline function can help.

In other cases it might help to split it up in smaller parts. For example:

u32 tmp;

val = bc->horz.win_count_calc &
	ISIF_HORZ_BC_WIN_COUNT_MASK;
val |= !!bc->horz.base_win_sel_calc <<
	ISIF_HORZ_BC_WIN_SEL_SHIFT;
val |= !!bc->horz.clamp_pix_limit <<
	ISIF_HORZ_BC_PIX_LIMIT_SHIFT;
tmp = bc->horz.win_h_sz_calc &
	ISIF_HORZ_BC_WIN_H_SIZE_MASK;
val |= tmp << ISIF_HORZ_BC_WIN_H_SIZE_SHIFT;
tmp = bc->horz.win_v_sz_calc &
	ISIF_HORZ_BC_WIN_V_SIZE_MASK;
val |= tmp << ISIF_HORZ_BC_WIN_V_SIZE_SHIFT;

Of course, in this particular piece of code from the function isif_config_bclamp()
I am also wondering why bc->horz.win_h_sz_calc and bc->horz.win_v_sz_calc need to
be ANDed anyway. I would expect that to happen when these values are set. But I
did not look at this in-depth, so I may well have missed some subtlety here.

It would be interesting to know if people know of good ways of making awkward
code like this more elegant (or at least less awkward).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
