Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52101 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab2CZPox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 11:44:53 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so4005484wgb.1
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 08:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <16456215.DlCuaG1n70@avalon>
References: <CAGD8Z75ELkV6wJOfuCFU3Z2dS=z5WbV-7izazaG7SVtfPMcn=A@mail.gmail.com>
	<CAGD8Z77akUx2S=h_AU+UcJ6yWf1Y_Rk4+8N78nFe4wP9OHYE=g@mail.gmail.com>
	<16456215.DlCuaG1n70@avalon>
Date: Mon, 26 Mar 2012 09:44:52 -0600
Message-ID: <CAGD8Z76ctw2F669D4PdJpYm4L1caYm=stE3WW_5JNxXpZZwx9g@mail.gmail.com>
Subject: Re: Using MT9P031 digital sensor
From: Joshua Hintze <joshua.hintze@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

On Mon, Mar 26, 2012 at 2:25 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Joshua,
>
> On Sunday 25 March 2012 23:13:02 Joshua Hintze wrote:
>> Alright I made some progress on this.
>>
>> I can access the Mt9p031 registers that are exposed using a command such as
>>
>> ./yavta -l /dev/v4l-subdev8 to list the available controls. Then I can
>> set the exposure and analog gain with
>> ./yavta --set-control '0x00980911 1500' /dev/v4l-subdev8   <--- This
>> seems to give the desired effect.
>>
>> Note that ./yavta -w (short option for --set-control) gives a seg
>> fault for me. Possible bug in yavta??
>
> That's strange, I use -w all the time and haven't noticed any segfault. Can
> you compile yavta with debugging information and provide some context ?
>

Then this must be my problem. I slightly modified yavta to output to
stdout for net cat streaming to mplayer on my desktop. I probably
didn't get the short options string correct.

>> Now I'm working on fixing the white balance. In my office the incandescent
>> light bulbs give off a yellowish tint late at night. I've been digging
>> through the omap3isp code to figure out how to enable the automatic white
>> balance. I was able to find the private IOCTLs for the previewer and I was
>> able to use VIDIOC_OMAP3ISP_PRV_CFG. Using this IOCTL I adjusted the
>> OMAP3ISP_PREV_WB, OMAP3ISP_PREV_BLKADJ, and OMAP3ISP_PREV_RGB2RGB.
>>
>> Since I wasn't sure where to start on adjusting these values I just set them
>> all to the TRM's default register values. However when I did so a strange
>> thing occurred. What I saw was all the colors went to a decent color. I'm
>> curious if anybody can shed some light on the best way to get a high quality
>> image. Ideally if I could just set a bit for auto white balance and auto
>> exposure that could be good too.
>
> The ISP doesn't implement automatic white balance. It can apply white
> balancing (as well as other related processing), but computing values for
> those parameters needs to be performed in userspace. The ISP statistics engine
> engine can help speeding up the process, but the AEWB algorithm must be
> implemented in your application.
>

Dang, I'll have to look up some AEWB algorithms. I'm curious why TI
would have this register bit then (AEW_EN bit 15 in H3A_PCR)?

Is this the same for auto focus and auto exposure? Meaning that I'll
need to get information from the histogram/statistics to adjust focus
and exposure times?

Thanks,

Josh

> --
> Regards,
>
> Laurent Pinchart
>
