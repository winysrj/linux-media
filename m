Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40208 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbZLOXh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 18:37:56 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"Nori, Sekhar" <nsekhar@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Tue, 15 Dec 2009 17:37:52 -0600
Subject: RE: [PATCH - v1 4/6] V4L - vpfe_capture bug fix and enhancements
Message-ID: <A69FA2915331DC488A831521EAE36FE401625D0BCC@dlee06.ent.ti.com>
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com>
 <1260464429-10537-6-git-send-email-m-karicheri2@ti.com>
 <200912152205.25491.hverkuil@xs4all.nl>
 <200912152220.41459.hverkuil@xs4all.nl>
In-Reply-To: <200912152220.41459.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I remember there was a comment against an earlier patch that asks
for combining such statements since it makes the function appear
as big. Not sure who had made that comment. That is the reason you
find code like this in this patch. It was initially done with multiple
OR statements to construct the value to be written to the register as you stated below as 

>val = bc->horz.win_count_calc &
>	ISIF_HORZ_BC_WIN_COUNT_MASK;
>val |= !!bc->horz.base_win_sel_calc <<
>	ISIF_HORZ_BC_WIN_SEL_SHIFT;

I have checked few other drivers such as bt819.c ir-kbd-i2c.c,
mt9m111.c etc, where similar statements are found, but they have used hardcoded values masks which makes it appears less complex. But I 
like to reduce magic numbers as much possible in the code.

I think what I can do is to  combine maximum of 2 such expressions in a statement which might make it less complex to read. Such as 

val = (bc->horz.win_count_calc &
	ISIF_HORZ_BC_WIN_COUNT_MASK) |
 	((!!bc->horz.base_win_sel_calc) <<
	ISIF_HORZ_BC_WIN_SEL_SHIFT);

val |= (!!bc->horz.clamp_pix_limit) <<
	 ISIF_HORZ_BC_PIX_LIMIT_SHIFT) |
 	 ((bc->horz.win_h_sz_calc &
	 ISIF_HORZ_BC_WIN_H_SIZE_MASK) <<
	 ISIF_HORZ_BC_WIN_H_SIZE_SHIFT);
val |= ((bc->horz.win_v_sz_calc &
	 ISIF_HORZ_BC_WIN_V_SIZE_MASK) <<
	 ISIF_HORZ_BC_WIN_V_SIZE_SHIFT);

Also to make the line fits in 80 characters, I will consider reducing
the number of characters in #define names such as

val = (bc->horz.win_count_calc & HZ_BC_WIN_CNT_MASK) |
((!!bc->horz.base_win_sel_calc) << HZ_BC_WIN_SEL_SHIFT) |
(!!bc->horz.clamp_pix_limit) << HZ_BC_PIX_LIMIT_SHIFT);

Let me know if you don't agree.

>
>Of course, in this particular piece of code from the function
>isif_config_bclamp()
>I am also wondering why bc->horz.win_h_sz_calc and bc->horz.win_v_sz_calc
>need to
>be ANDed anyway. I would expect that to happen when these values are set.
>But I
>did not look at this in-depth, so I may well have missed some subtlety here.

Yes, isif_config_bclamp() set values in the register.

>
>It would be interesting to know if people know of good ways of making
>awkward
>code like this more elegant (or at least less awkward).
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
