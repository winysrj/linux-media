Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:22689 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeHBSqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 14:46:13 -0400
Received: by mail-qt0-f169.google.com with SMTP id d4-v6so3014317qtn.13
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 09:54:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bdc722d622b73317ed9429a5c822bc9080f6ecb3.camel@baylibre.com>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
 <20180801193320.25313-2-maxi.jourdan@wanadoo.fr> <bdc722d622b73317ed9429a5c822bc9080f6ecb3.camel@baylibre.com>
From: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date: Thu, 2 Aug 2018 18:54:12 +0200
Message-ID: <CAHStOZ6-ZROA7cErHj79ycDg2d7cbWaDiSJhGHJUkgfdmu1Dzw@mail.gmail.com>
Subject: Re: [RFC 1/4] media: meson: add v4l2 m2m video decoder driver
To: Jerome Brunet <jbrunet@baylibre.com>
Cc: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-media@vger.kernel.org,
        linux-amlogic <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-08-02 12:30 GMT+02:00 Jerome Brunet <jbrunet@baylibre.com>:
>
> Ouch!
>
> Your architecture seems pretty modular. Maybe you could split this patch a
> little ? One patch of the 'backbone' then one for each codec ?

Hehe, it's a big baby. Sure I'll split it codec by codec.

>
> I suppose this will go away with :
> https://lkml.kernel.org/r/20180801185128.23440-1-maxi.jourdan@wanadoo.fr
>
> ? If yes, it would have been better to send a version using it directly.

Indeed they will, my bad.

>> +     while (readl_relaxed(core->dos_base + DCAC_DMA_CTRL) & 0x8000) { }
>> +     while (readl_relaxed(core->dos_base + LMEM_DMA_CTRL) & 0x8000) { }
>
> Is this guarantee to exit at some point or is there a risk of staying stuck here
> forever ?
>
> I think regmap has some helper function for polling with a timeout.

Totally forgot about those since they caused no problem so far, good catch.
I'll see with regmap.

>> +
>> +     writel_relaxed((1<<7) | (1<<6) | (1<<4), core->dos_base + DOS_SW_RESET0);
>> +     writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
>> +     readl_relaxed(core->dos_base + DOS_SW_RESET0);
>> +
>> +     writel_relaxed((1<<7) | (1<<6) | (1<<4), core->dos_base + DOS_SW_RESET0);
>> +     writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
>> +     writel_relaxed((1<<9) | (1<<8), core->dos_base + DOS_SW_RESET0);
>> +     writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
>> +     readl_relaxed(core->dos_base + DOS_SW_RESET0);
>> +
>> +     writel_relaxed(readl_relaxed(core->dos_base + POWER_CTL_VLD) | (1 << 9) | (1 << 6), core->dos_base + POWER_CTL_VLD);
>> +
>> +     writel_relaxed(0, core->dos_base + PSCALE_CTRL);
>> +     writel_relaxed(0, core->dos_base + AV_SCRATCH_0);
>> +
>> +     workspace_offset = h264->workspace_paddr - DEF_BUF_START_ADDR;
>> +     writel_relaxed(workspace_offset, core->dos_base + AV_SCRATCH_1);
>> +     writel_relaxed(h264->ext_fw_paddr, core->dos_base + AV_SCRATCH_G);
>> +     writel_relaxed(h264->sei_paddr - workspace_offset, core->dos_base + AV_SCRATCH_I);
>
> Do we have any idea what all the above does ? I suppose, it mostly comes from
> reverse engineering the vendor kernel. If possible, a few comments would be
> nice.
>
> In general, instead of (1 << x), you could write BIT(x)
>

The resets and power_ctl, not really. The last 4 lines set the phy
addr for the "workspace" which is a memory region where the decoder
keeps some stuff, unfortunately I don't know what,
the extended firmware data and the SEI dumps.

I'll try to add some comments and see if I can find more info in the aml kernel.

I'll also change all the (1 << x) to BIT(x).


>
> What the about defining the filter shift and width, using GENMASK() maybe ?
>
>> +     mb_total = (parsed_info >> 8) & 0xffff;
>> +
>> +     /* Size of Motion Vector per macroblock ? */
>> +     mb_mv_byte = (parsed_info & 0x80000000) ? 24 : 96;
>
> #define FOO_MB_SIZE BIT(28)
> (parsed_info & FOO_MB_SIZE) ?

>> +     writel_relaxed((max_reference_size << 24) | (actual_dpb_size << 16) | (max_dpb_size << 8), core->dos_base + AV_SCRATCH_0);
>
> I know it is not always easy, especially with very little documentation, but
> could you #define a bit more the content of the registers:
>
> something like
> #define BAR_MAX_REF_SHIFT 24
>
> You get the idea ..

>> +     cmd = status & 0xff;
>> +
>> +     if (cmd == 1) {
>
> Same kind of comment, could define those command somewhere to this a bit more
> readable ?
>

>> +     for (i = 0; i < 16; i++) {
>> +             u16 cur_rps = params->p.CUR_RPS[i];
>> +             int delt = cur_rps & ((1 << (RPS_USED_BIT - 1)) - 1);
>
> Looks like using GENMASK would make things a bit more readable here.
>
>> +
>> +             if (cur_rps & 0x8000)
>
> BIT(15) ? any idea what this is ? could we define this ?
>
> Same comment in general for the rest of the patch. If you can replace mask and
> bit calculation with related macro and define things a bit more, it would be
> nice.

>> +     for (i = 0; i < num_ref_idx_l0_active; i++) {
>> +             int cIdx;
>
> Could we avoid cAmEl case ?
>

>> +             //writel_relaxed(buf_uv_paddr >> 5, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_DATA);
>
> Clean up ?
>

Thanks for all the advice above.

>> +#define DOS_SW_RESET0                0xfc00
>
> I think this is not the first time you've defined this.
> Maybe this (and other re-used register offsets) needs to be in some header ?

Yes at present each file has their set of registers declared within
the .c but there are some redundancies.
I'll cater them in a header.


>> +#define HEVC_ASSIST_AFIFO_CTRL (0x3001 * 4)
>
> Defining register this way is something amlogic does in their.
> We they submitted the AXG clock controller we kindly asked them
> to directly put what the offset is and drop the calculation.
>
> Could please do the same ?

Sure

>> +     core->dos_parser_clk = devm_clk_get(dev, "dos_parser");
>> +     if (IS_ERR(core->dos_parser_clk)) {
>
> You should handle EPROBE_DEFER and not print an error in such case.
> It is fairly common for the device probe to be deferred because of a clock
> provider.
>

>> +MODULE_ALIAS("platform:meson-video-decoder");
>
> On the target platform, the device should always be instantiated from DT
> With the MODULE_DEVICE_TABLE above, I don't think you need this MODULE_ALIAS.
>

Thanks!
