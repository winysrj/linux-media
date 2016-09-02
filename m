Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34249 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932373AbcIBQNZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 12:13:25 -0400
Received: by mail-lf0-f47.google.com with SMTP id p41so68644067lfi.1
        for <linux-media@vger.kernel.org>; Fri, 02 Sep 2016 09:13:24 -0700 (PDT)
Date: Fri, 2 Sep 2016 18:13:21 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, slongerbeam@gmail.com,
        lars@metafoo.de, hans.verkuil@cisco.com, mchehab@kernel.org
Subject: Re: [PATCH] [media] rcar-vin: add legacy mode for wrong media bus
 formats
Message-ID: <20160902161321.GM24983@bigcity.dyn.berto.se>
References: <20160708104327.6329-1-niklas.soderlund+renesas@ragnatech.se>
 <4776c0f7-22da-6e72-f0c8-c02fc07b38dc@xs4all.nl>
 <20160720122907.GC20569@bigcity.dyn.berto.se>
 <578F7054.2000302@cisco.com>
 <ab5a8bf5-39c4-585e-e1f6-5151e888a8cf@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab5a8bf5-39c4-585e-e1f6-5151e888a8cf@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-08-22 11:12:59 +0200, Hans Verkuil wrote:
> On 07/20/2016 02:36 PM, Hans Verkuil wrote:
> > On 07/20/2016 02:29 PM, Niklas Söderlund wrote:
> >> Hi Hans,
> >>
> >> Thanks for your feedback.
> >>
> >> On 2016-07-20 11:48:40 +0200, Hans Verkuil wrote:
> >>> On 07/08/2016 12:43 PM, Niklas Söderlund wrote:
> >>>> A recent bugfix to adv7180 brought to light that the rcar-vin driver are
> >>>> looking for the wrong media bus format. It was looking for a YUVU format
> >>>> but then expecting UYVY data. The bugfix for adv7180 will break the
> >>>> usage of rcar-vin together with a adv7180 as found on Renesas R-Car2
> >>>> Koelsch boards for example.
> >>>>
> >>>> This patch fix the rcar-vin driver to look for the correct UYVU formats
> >>>> and adds a legacy mode. The legacy mode is needed since I don't know if
> >>>> other devices provide a incorrect media bus format and I don't want to
> >>>> break any working configurations. Hopefully the legacy mode can be
> >>>> removed sometime in the future.
> >>>
> >>> I'd rather have a version without the legacy code. You have to assume that
> >>> subdevs return correct values otherwise what's the point of the mediabus
> >>> formats?
> >>>
> >>> So this is simply an adv7180 bug fix + this r-car fix to stay consistent
> >>> with the adv7180.
> >>
> >> On principal I agree with you. My goal with this patch is just to make
> >> sure there is no case where the rcar-vin driver won't work with the
> >> adv7180. The plan was to drop the legacy mode in a separate patch after
> >> both the adv7182 and rcar-vin patches where picked up.
> >>
> >> I'm happy to drop the 'legacy support' for the wrong formats from this
> >> patch as long as I can be sure that there is no breaking. Should I
> >> rewrite this patch to drop the wrong formats and submit it as a series
> >> together with the adv7180 patch so they can be picked up together? Or do
> >> you know of a better way?
> > 
> > Why not combine this patch and the adv7180 patch in a single patch? Just keep
> > Steve's Signed-off-by line together with yours. That way everything stays
> > in sync. The only other user of the adv7180 doesn't look at the mediabus
> > formats at all, so it isn't affected.
> 
> Niklas,
> 
> Were you planning to make a combined adv7180/rcar-vin patch for this?
> 
> I would prefer this solution rather than keeping legacy code around.

Sorry for the delay Hans. I just posted a combined patch for adv7180 and 
rcar-vin. Thanks for picking up the cleanup patches!

-- 
Regards,
Niklas Söderlund
