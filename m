Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55941 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3AGUGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 15:06:51 -0500
MIME-Version: 1.0
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA7FBF7@DBDE01.ent.ti.com>
References: <1355850256-16135-1-git-send-email-s.trumtrar@pengutronix.de>
	<1355850256-16135-6-git-send-email-s.trumtrar@pengutronix.de>
	<C8443D0743D26F4388EA172BF4E2A7A93EA7FB02@DBDE01.ent.ti.com>
	<20130107080648.GB23478@pengutronix.de>
	<C8443D0743D26F4388EA172BF4E2A7A93EA7FBF7@DBDE01.ent.ti.com>
Date: Mon, 7 Jan 2013 14:06:50 -0600
Message-ID: <CAF6AEGuuM9_n+A4q4tq+24i4YcW97orMN_RKbJ95gFie_qoktA@mail.gmail.com>
Subject: Re: [PATCHv16 5/7] fbmon: add of_videomode helpers
From: Rob Clark <robdclark@gmail.com>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	David Airlie <airlied@linux.ie>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 7, 2013 at 2:46 AM, Mohammed, Afzal <afzal@ti.com> wrote:
> Hi Steffen,
>
> On Mon, Jan 07, 2013 at 13:36:48, Steffen Trumtrar wrote:
>> On Mon, Jan 07, 2013 at 06:10:13AM +0000, Mohammed, Afzal wrote:
>
>> > This breaks DaVinci (da8xx_omapl_defconfig), following change was
>> > required to get it build if OF_VIDEOMODE or/and FB_MODE_HELPERS
>> > is not defined. There may be better solutions, following was the
>> > one that was used by me to test this series.
>
>> I just did a quick "make da8xx_omapl_defconfig && make" and it builds just fine.
>> On what version did you apply the series?
>> At the moment I have the series sitting on 3.7. Didn't try any 3.8-rcx yet.
>> But fixing this shouldn't be a problem.
>
> You are right, me idiot, error will happen only upon try to make use of
> of_get_fb_videomode() (defined in this patch) in the da8xx-fb driver
> (with da8xx_omapl_defconfig), to be exact upon adding,
>
> "video: da8xx-fb: obtain fb_videomode info from dt" of my patch series.
>
> The change as I mentioned or something similar would be required as
> any driver that is going to make use of of_get_fb_videomode() would
> break if CONFIG_OF_VIDEOMODE or CONFIG_FB_MODE_HELPERS is not defined.

Shouldn't the driver that depends on CONFIG_OF_VIDEOMODE and
CONFIG_FB_MODE_HELPERS, explicitly select them?  I don't really see
the point of having the static-inline fallbacks.

fwiw, using 'select' is what I was doing for lcd panel support for
lcdc/da8xx drm driver (which was using the of videomode helpers,
albeit a slightly earlier version of the patches):

https://github.com/robclark/kernel-omap4/commit/e2aef5f281348afaaaeaa132699efc2831aa8384

BR,
-R

>
> And testing was done over v3.8-rc2.
>
>> > > +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
>> >
>> > As _OF_VIDEOMODE is a bool type CONFIG, isn't,
>> >
>> > #ifdef CONFIG_OF_VIDEOMODE
>> >
>> > sufficient ?
>> >
>>
>> Yes, that is right. But I think IS_ENABLED is the preferred way to do it, isn't it?
>
> Now I realize it is.
>
> Regards
> Afzal
