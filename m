Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:4200 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbZLPHlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 02:41:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH - v1 4/6] V4L - vpfe_capture bug fix and enhancements
Date: Wed, 16 Dec 2009 08:41:57 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"Nori, Sekhar" <nsekhar@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com> <200912152220.41459.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE401625D0BCC@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401625D0BCC@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <200912160841.57444.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 16 December 2009 00:37:52 Karicheri, Muralidharan wrote:
> Hans,
> 
> I remember there was a comment against an earlier patch that asks
> for combining such statements since it makes the function appear
> as big. Not sure who had made that comment. That is the reason you
> find code like this in this patch. It was initially done with multiple
> OR statements to construct the value to be written to the register as you stated below as 
> 
> >val = bc->horz.win_count_calc &
> >	ISIF_HORZ_BC_WIN_COUNT_MASK;
> >val |= !!bc->horz.base_win_sel_calc <<
> >	ISIF_HORZ_BC_WIN_SEL_SHIFT;
> 
> I have checked few other drivers such as bt819.c ir-kbd-i2c.c,
> mt9m111.c etc, where similar statements are found, but they have used hardcoded values masks which makes it appears less complex. But I 
> like to reduce magic numbers as much possible in the code.

Personally I have mixed feelings about the use for symbolic names for things
like this. The problem is that they do not help me understanding the code.
The names tend to be long, leading to these broken up lines, and if I want
to know how the bits are distributed in the value I continuously have to
do the look up in the header containing these defines.

Frankly, I have a similar problem with using symbolic names for registers.
Every time I need to look up a register in the datasheet I first need to
look up the register number the register name maps to. All datasheets seem
to be organized around the register addresses and there rarely is a datasheet
that has an index of symbolic names.

Using hard-coded numbers together with a well written comment tends to be much
more readable in my opinion. I don't really think there is anything magic about
these numbers: these are exactly the numbers that I need to know whenever I
have to deal with the datasheet. Having to go through a layer of obfuscation
is just plain irritating to me.

However, I seem to be a minority when it comes to this and I've given up
arguing for this...

Note that all this assumes that the datasheet is publicly available. If it
is a reversed engineered driver or based on NDA datasheets only, then the
symbolic names may be all there is to make you understand what is going on.

> 
> I think what I can do is to  combine maximum of 2 such expressions in a statement which might make it less complex to read. Such as 
> 
> val = (bc->horz.win_count_calc &
> 	ISIF_HORZ_BC_WIN_COUNT_MASK) |
>  	((!!bc->horz.base_win_sel_calc) <<
> 	ISIF_HORZ_BC_WIN_SEL_SHIFT);
> 
> val |= (!!bc->horz.clamp_pix_limit) <<
> 	 ISIF_HORZ_BC_PIX_LIMIT_SHIFT) |
>  	 ((bc->horz.win_h_sz_calc &
> 	 ISIF_HORZ_BC_WIN_H_SIZE_MASK) <<
> 	 ISIF_HORZ_BC_WIN_H_SIZE_SHIFT);
> val |= ((bc->horz.win_v_sz_calc &
> 	 ISIF_HORZ_BC_WIN_V_SIZE_MASK) <<
> 	 ISIF_HORZ_BC_WIN_V_SIZE_SHIFT);
> 
> Also to make the line fits in 80 characters, I will consider reducing
> the number of characters in #define names such as
> 
> val = (bc->horz.win_count_calc & HZ_BC_WIN_CNT_MASK) |
> ((!!bc->horz.base_win_sel_calc) << HZ_BC_WIN_SEL_SHIFT) |
> (!!bc->horz.clamp_pix_limit) << HZ_BC_PIX_LIMIT_SHIFT);
> 
> Let me know if you don't agree.

That seems overkill. I actually think it can be improved a lot by visually
grouping the lines:

                     val = (bc->horz.win_count_calc &
                             ISIF_HORZ_BC_WIN_COUNT_MASK) |
                           ((!!bc->horz.base_win_sel_calc) <<
                             ISIF_HORZ_BC_WIN_SEL_SHIFT) |
                           ((!!bc->horz.clamp_pix_limit) <<
                             ISIF_HORZ_BC_PIX_LIMIT_SHIFT) |
                           ((bc->horz.win_h_sz_calc &
                             ISIF_HORZ_BC_WIN_H_SIZE_MASK) <<
                             ISIF_HORZ_BC_WIN_H_SIZE_SHIFT) |
                           ((bc->horz.win_v_sz_calc &
                             ISIF_HORZ_BC_WIN_V_SIZE_MASK) <<
                             ISIF_HORZ_BC_WIN_V_SIZE_SHIFT);

Now I can at least see the various values that are ORed.

> 
> >
> >Of course, in this particular piece of code from the function
> >isif_config_bclamp()
> >I am also wondering why bc->horz.win_h_sz_calc and bc->horz.win_v_sz_calc
> >need to
> >be ANDed anyway. I would expect that to happen when these values are set.
> >But I
> >did not look at this in-depth, so I may well have missed some subtlety here.
> 
> Yes, isif_config_bclamp() set values in the register.

Huh? That does not explain why apparently bc->horz.win_h_sz_calc can be larger
than ISIF_HORZ_BC_WIN_H_SIZE_MASK.

Regards,

	Hans

> 
> >
> >It would be interesting to know if people know of good ways of making
> >awkward
> >code like this more elegant (or at least less awkward).
> >
> >Regards,
> >
> >	Hans
> >
> >--
> >Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
