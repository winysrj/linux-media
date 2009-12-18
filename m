Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45099 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbZLRFOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 00:14:09 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 18 Dec 2009 10:43:57 +0530
Subject: RE: [PATCH - v1 4/6] V4L - vpfe_capture bug fix and enhancements
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301E19F685B@dbde02.ent.ti.com>
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com>
 <200912152220.41459.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE401625D0BCC@dlee06.ent.ti.com>
 <200912160841.57444.hverkuil@xs4all.nl>
In-Reply-To: <200912160841.57444.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 16, 2009 at 13:11:57, Hans Verkuil wrote:
> On Wednesday 16 December 2009 00:37:52 Karicheri, Muralidharan wrote:
> > Hans,
> >
> > I remember there was a comment against an earlier patch that asks
> > for combining such statements since it makes the function appear
> > as big. Not sure who had made that comment. That is the reason you
> > find code like this in this patch. It was initially done with multiple
> > OR statements to construct the value to be written to the register as you stated below as
> >
> > >val = bc->horz.win_count_calc &
> > >   ISIF_HORZ_BC_WIN_COUNT_MASK;
> > >val |= !!bc->horz.base_win_sel_calc <<
> > >   ISIF_HORZ_BC_WIN_SEL_SHIFT;
> >
> > I have checked few other drivers such as bt819.c ir-kbd-i2c.c,
> > mt9m111.c etc, where similar statements are found, but they have used hardcoded values masks which makes it appears less complex. But I
> > like to reduce magic numbers as much possible in the code.
>
> Personally I have mixed feelings about the use for symbolic names for things
> like this. The problem is that they do not help me understanding the code.
> The names tend to be long, leading to these broken up lines, and if I want
> to know how the bits are distributed in the value I continuously have to
> do the look up in the header containing these defines.
>
> Frankly, I have a similar problem with using symbolic names for registers.
> Every time I need to look up a register in the datasheet I first need to
> look up the register number the register name maps to. All datasheets seem
> to be organized around the register addresses and there rarely is a datasheet
> that has an index of symbolic names.
>
> Using hard-coded numbers together with a well written comment tends to be much
> more readable in my opinion. I don't really think there is anything magic about
> these numbers: these are exactly the numbers that I need to know whenever I
> have to deal with the datasheet. Having to go through a layer of obfuscation
> is just plain irritating to me.
>
> However, I seem to be a minority when it comes to this and I've given up
> arguing for this...
>
> Note that all this assumes that the datasheet is publicly available. If it
> is a reversed engineered driver or based on NDA datasheets only, then the
> symbolic names may be all there is to make you understand what is going on.
>

[...]

>
> That seems overkill. I actually think it can be improved a lot by visually
> grouping the lines:
>
>                      val = (bc->horz.win_count_calc &
>                              ISIF_HORZ_BC_WIN_COUNT_MASK) |
>                            ((!!bc->horz.base_win_sel_calc) <<
>                              ISIF_HORZ_BC_WIN_SEL_SHIFT) |
>                            ((!!bc->horz.clamp_pix_limit) <<
>                              ISIF_HORZ_BC_PIX_LIMIT_SHIFT) |
>                            ((bc->horz.win_h_sz_calc &
>                              ISIF_HORZ_BC_WIN_H_SIZE_MASK) <<
>                              ISIF_HORZ_BC_WIN_H_SIZE_SHIFT) |
>                            ((bc->horz.win_v_sz_calc &
>                              ISIF_HORZ_BC_WIN_V_SIZE_MASK) <<
>                              ISIF_HORZ_BC_WIN_V_SIZE_SHIFT);
>
> Now I can at least see the various values that are ORed.
>

I liked this piece of code from drivers/mtd/nand/s3c2410.c. Serves as
a good template to do this sort of thing.

#define S3C2410_NFCONF_TACLS(x)    ((x)<<8)
#define S3C2410_NFCONF_TWRPH0(x)   ((x)<<4)
#define S3C2410_NFCONF_TWRPH1(x)   ((x)<<0)

[Okay, spaces around '<<', please :)]

[...]

        if (plat != NULL) {
                tacls = s3c_nand_calc_rate(plat->tacls, clkrate, tacls_max);
                twrph0 = s3c_nand_calc_rate(plat->twrph0, clkrate, 8);
                twrph1 = s3c_nand_calc_rate(plat->twrph1, clkrate, 8);
        }

[...]

                mask = (S3C2410_NFCONF_TACLS(3) |
                        S3C2410_NFCONF_TWRPH0(7) |
                        S3C2410_NFCONF_TWRPH1(7));
                set = S3C2410_NFCONF_EN;
                set |= S3C2410_NFCONF_TACLS(tacls - 1);
                set |= S3C2410_NFCONF_TWRPH0(twrph0 - 1);
                set |= S3C2410_NFCONF_TWRPH1(twrph1 - 1);

[...]

        cfg = readl(info->regs + S3C2410_NFCONF);
        cfg &= ~mask;
        cfg |= set;
        writel(cfg, info->regs + S3C2410_NFCONF);

And Murali said:

> >Huh? That does not explain why apparently bc->horz.win_h_sz_calc can be
> >larger
> >than ISIF_HORZ_BC_WIN_H_SIZE_MASK.
> because the values come from the user and since we can't use the enum
> for the types, I have to make sure the value is within range. Other way
> to do is to check the value in the validate() function. I am inclined to
> do the validation so that the & statements with masks can be removed while setting it in
> the register.

Agree fully here. Either a separate validate function or
an if check before using the values. Results with masking
or without masking are both unpredictable.

Thanks,
Sekhar

