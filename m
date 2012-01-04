Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34063 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab2ADU5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 15:57:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
Date: Wed, 4 Jan 2012 21:57:16 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <4F007DED.4070201@gmail.com> <20120104203933.GJ9323@valkosipuli.localdomain>
In-Reply-To: <20120104203933.GJ9323@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201042157.17040.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 04 January 2012 21:39:34 Sakari Ailus wrote:
> On Sun, Jan 01, 2012 at 04:38:21PM +0100, Sylwester Nawrocki wrote:
> > On 12/30/2011 09:41 PM, Sakari Ailus wrote:
> > > On Fri, Dec 30, 2011 at 11:14:39AM +0100, Sylwester Nawrocki wrote:
> > >> On 12/30/2011 12:34 AM, Sakari Ailus wrote:
> > >>> On Wed, Dec 28, 2011 at 02:51:38PM +0100, Laurent Pinchart wrote:
> > >>>> On Wednesday 28 December 2011 14:35:00 Sylwester Nawrocki wrote:
> > >>>>> On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
> > >>>>>> It adds the new CID for setting White Balance Preset. This CID is
> > >>>>>> provided as menu type using the following items:
> > >>>>>> 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
> > >>>>>> 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
> > >>>>>> 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
> > >>>>>> 3 - V4L2_WHITE_BALANCE_CLOUDY,
> > >>>>>> 4 - V4L2_WHITE_BALANCE_SHADE,
> > >>>>> 
> > >>>>> I have been also investigating those white balance presets recently
> > >>>>> and noticed they're also needed for the pwc driver. Looking at
> > >>>>> drivers/media/video/pwc/pwc-v4l2.c there is something like:
> > >>>>> 
> > >>>>> const char * const pwc_auto_whitebal_qmenu[] = {
> > >>>>> 
> > >>>>> 	"Indoor (Incandescant Lighting) Mode",
> > >>>>> 	"Outdoor (Sunlight) Mode",
> > >>>>> 	"Indoor (Fluorescent Lighting) Mode",
> > >>>>> 	"Manual Mode",
> > >>>>> 	"Auto Mode",
> > >>>>> 	NULL
> > >>>>> 
> > >>>>> };
> > >>>>> 
> > >>>>> static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
> > >>>>> 
> > >>>>> 	.ops	= &pwc_ctrl_ops,
> > >>>>> 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
> > >>>>> 	.type	= V4L2_CTRL_TYPE_MENU,
> > >>>>> 	.max	= awb_auto,
> > >>>>> 	.qmenu	= pwc_auto_whitebal_qmenu,
> > >>>>> 
> > >>>>> };
> > >>>>> 
> > >>>>> ...
> > >>>>> 
> > >>>>> 	cfg = pwc_auto_white_balance_cfg;
> > >>>>> 	cfg.name = v4l2_ctrl_get_name(cfg.id);
> > >>>>> 	cfg.def = def;
> > >>>>> 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
> > >>>>> 
> > >>>>> So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu
> > >>>>> control with custom entries. That's interesting... However it
> > >>>>> works in practice and applications have access to what's provided
> > >>>>> by hardware. Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would
> > >>>>> be a better fit for that :)
> > >>>>> 
> > >>>>> Nevertheless, redefining standard controls in particular drivers
> > >>>>> sounds a little dubious. I wonder if this is a generally agreed
> > >>>>> approach ?
> > >>>> 
> > >>>> No agreed with me at least :-)
> > >>>> 
> > >>>>> Then, how does your V4L2_CID_PRESET_WHITE_BALANCE control interact
> > >>>>> with V4L2_CID_AUTO_WHITE_BALANCE control ? Does
> > >>>>> V4L2_CID_AUTO_WHITE_BALANCE need to be set to false for
> > >>>>> V4L2_CID_PRESET_WHITE_BALANCE to be effective ?
> > >>>> 
> > >>>> Is the preset a fixed white balance setting, or is it an auto white
> > >>>> balance with the algorithm tuned for a particular configuration ?
> > >>>> In the first case, does it correspond to a fixed white balance
> > >>>> temperature value ?
> > >>> 
> > >>> While I'm waiting for a final answer to this, I guess it's the
> > >>> second. There are three things involved here:
> > >>> 
> > >>> - V4L2_CID_WHITE_BALANCE_TEMPERATURE: relatively low level control
> > >>> telling
> > >>> 
> > >>>   the colour temperature of the light source. Setting a value for
> > >>>   this essentially means using manual white balance.
> > >>> 
> > >>> - V4L2_CID_AUTO_WHITE_BALANCE: automatic white balance enabled or
> > >>> disabled.
> > >> 
> > >> Was the third thing the V4L2_CID_DO_WHITE_BALANCE control that you
> > >> wanted to say ? It's also quite essential functionality, to be able
> > >> to fix white balance after pointing camera to a white object. And I
> > >> would expect
> > >> V4L2_CID_WHITE_BALANCE_PRESET control's documentation to state how an
> > >> interaction with V4L2_CID_DO_WHITE_BALANCE looks like.
> > > 
> > > I expected the new control to be the third thing as configuration for
> > > the awb algorithm, which it turned out not to be.
> > > 
> > > I don't quite understand the purpose of the do_white_balance; the
> > > automatic white balance algorithm is operational until it's disabled,
> > > and after disabling it the white balance shouldn't change. What is the
> > > extra functionality that the do_white_balance control implements?
> > 
> > Maybe DO_WHITE_BALANCE was inspired by some hardware's behaviour, I don't
> > know. I have nothing against this control. It allows you to perform
> > one-shot white balance in a given moment in time. Simple and clear.
> 
> Well, yes, if you have an automatic white balance algorithm which supports
> "one-shot" mode. Typically it's rather a feedback loop. I guess this means
> "just run one iteration".
> 
> Something like this should possibly be used to get the white balance
> correct by pointing the camera to an object of known colour (white
> typically, I think). But this isn't it, at least based on the description
> in the spec.

Then either the spec is incorrect, or I'm mistaken. My understanding of the 
DO_WHITE_BALANCE control is exactly what you described.

> > > If we agree white_balance_preset works at the same level as
> > > white_balance_temerature control, this becomes more simple. I guess no
> > > driver should implement both.
> > 
> > Yes, AFAIU those presets are just WB temperature, with names instead
> > of numbers. Thus it doesn't make much sense to expose both at the driver.
> > 
> > But in manual white balance mode camera could be switched to new WB
> > value, with component gain/balance controls, DO_WHITE_BALANCE or
> > whatever, rendering the preset setting invalid. Should we then have an
> > invalid/unknown item in the presets menu ? This would be only allowed to
> > set by driver, i.e. read-only for applications. If device provide
> > multiple means for setting white balance it is quite likely that at some
> > point wb might not match any preset.
> 
> That's very true. I think an "undefined" menu item would be an option, at
> least I can't think of a better one right now.
> 
> > Having auto, manual and presets in one menu control wouldn't require
> > that, but we rather can't just change the V4L2_CID_WHITE_BALANCE control
> > type now.
> 
> In that case, "manual" would be just another name for "unknown" in case
> where automatic white balance has been turned off.
> 
> Also, as Hans noted, colour temperature is just one way to specify white
> balance. I guess that to achieve a perfect result we should acquire the
> whole spectrum for each pixel, and make an estimation on the spectrum of
> the light source. That doesn't sound feasible. :-)
> 
> But there are other options than just colour temperature. That still might
> be the only really practical one for the end user.

-- 
Regards,

Laurent Pinchart
