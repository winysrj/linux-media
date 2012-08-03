Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39461 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab2HCOYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 10:24:05 -0400
Received: by yhmm54 with SMTP id m54so875738yhm.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 07:24:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501ADEF6.1080901@gmail.com>
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org>
	<501ADEF6.1080901@gmail.com>
Date: Fri, 3 Aug 2012 15:24:04 +0100
Message-ID: <CADPsn1b6TxhmWVzzH1u-wr0UZs6D3cif4+r1S9OOROx1iXCXUQ@mail.gmail.com>
Subject: Re: [PATH v3 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with
 embedded SoC ISP
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi  Sylwester

Thank you for the review.

On 2 August 2012 21:11, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
>
> Hi Sangwook,
>
> On 08/02/2012 03:42 PM, Sangwook Lee wrote:
> > The following 2 patches add driver for S5K4ECGX sensor with embedded ISP SoC,
> > and minor v4l2 control API enhancement. S5K4ECGX is 5M CMOS Image sensor from Samsung
> >
> > Changes since v2:
> > - added GPIO (reset/stby) and regulators
> > - updated I2C read/write, based on s5k6aa datasheet
> > - fixed set_fmt errors
> > - reduced register tables a bit
> > - removed vmalloc
>
> It looks like a great improvement, well done! Thanks!
>
> In the S5K4CAGX sensor datasheet, that can be found on the internet,
> there is 0x0000...0x002E registers description, which look very much
> same as in S5K6AAFX case and likely is also valid for S5K4CAGX.


[snip]

>
>
> What do you think about converting s5k4ecgx_img_regs arrays (it has
> over 2700 entries) to a firmware file and adding some simple parser
> to the driver ? Then we would have the problem solved in most part.
>

Thanks, fair enough. let me try this.


>
> Regarding various preview resolution set up, the difference in all
> those s5k4ecgx_*_preview[] arrays is rather small, only register
> values differ, e.g. for 640x480 and 720x480 there is only 8 different
> entries:
>

Ok, let me reduce table size again.

>
> $ diff -a s5k4ec_640.txt s5k4ec_720.txt
> 1c1
> < static const struct regval_list s5k4ecgx_640_preview[] = {
> ---
> > static const struct regval_list s5k4ecgx_720_preview[] = {
> 3c3
> <       { 0x70000252, 0x0780 },
> ---
> >       { 0x70000252, 0x06a8 },
> 5c5



[snip]

>
> <       { 0x70000256, 0x000c },
> >       { 0x700002a6, 0x02d

[snip]
>
> Could you please try to implement a function that replaces those tables,
> based s5k6aa_set_prev_config() and s5k6aa_set_output_framefmt() ?
>
I was thinking about this, but this seems to be is a bit time-consuming because
I have to do this just due to lack of s5k4ecgx hardware information.
let me try it later once
this patch is accepted.

Thanks
Sangwook

> Regards,
> Sylwester
