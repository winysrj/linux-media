Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47502 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab1L2XeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 18:34:11 -0500
Date: Fri, 30 Dec 2011 01:34:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu
 control
Message-ID: <20111229233406.GU3677@valkosipuli.localdomain>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
 <4EFB1B04.6060305@gmail.com>
 <201112281451.39399.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112281451.39399.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Sylwester and HeungJun,

On Wed, Dec 28, 2011 at 02:51:38PM +0100, Laurent Pinchart wrote:
> Hi,
> 
> On Wednesday 28 December 2011 14:35:00 Sylwester Nawrocki wrote:
> > On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
> > > It adds the new CID for setting White Balance Preset. This CID is
> > > provided as menu type using the following items:
> > > 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
> > > 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
> > > 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
> > > 3 - V4L2_WHITE_BALANCE_CLOUDY,
> > > 4 - V4L2_WHITE_BALANCE_SHADE,
> > 
> > I have been also investigating those white balance presets recently and
> > noticed they're also needed for the pwc driver. Looking at
> > drivers/media/video/pwc/pwc-v4l2.c there is something like:
> > 
> > const char * const pwc_auto_whitebal_qmenu[] = {
> > 	"Indoor (Incandescant Lighting) Mode",
> > 	"Outdoor (Sunlight) Mode",
> > 	"Indoor (Fluorescent Lighting) Mode",
> > 	"Manual Mode",
> > 	"Auto Mode",
> > 	NULL
> > };
> > 
> > static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
> > 	.ops	= &pwc_ctrl_ops,
> > 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
> > 	.type	= V4L2_CTRL_TYPE_MENU,
> > 	.max	= awb_auto,
> > 	.qmenu	= pwc_auto_whitebal_qmenu,
> > };
> > 
> > ...
> > 
> > 	cfg = pwc_auto_white_balance_cfg;
> > 	cfg.name = v4l2_ctrl_get_name(cfg.id);
> > 	cfg.def = def;
> > 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
> > 
> > So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu control
> > with custom entries. That's interesting... However it works in practice
> > and applications have access to what's provided by hardware.
> > Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would be a better fit for
> > that :)
> > 
> > Nevertheless, redefining standard controls in particular drivers sounds
> > a little dubious. I wonder if this is a generally agreed approach ?
> 
> No agreed with me at least :-)
> 
> > Then, how does your V4L2_CID_PRESET_WHITE_BALANCE control interact with
> > V4L2_CID_AUTO_WHITE_BALANCE control ? Does V4L2_CID_AUTO_WHITE_BALANCE need
> > to be set to false for V4L2_CID_PRESET_WHITE_BALANCE to be effective ?
> 
> Is the preset a fixed white balance setting, or is it an auto white balance 
> with the algorithm tuned for a particular configuration ? In the first case, 
> does it correspond to a fixed white balance temperature value ?

While I'm waiting for a final answer to this, I guess it's the second. There
are three things involved here:

- V4L2_CID_WHITE_BALANCE_TEMPERATURE: relatively low level control telling
  the colour temperature of the light source. Setting a value for this
  essentially means using manual white balance.

- V4L2_CID_AUTO_WHITE_BALANCE: automatic white balance enabled or disabled.

The new control proposed by HeungJun is input for the automatic white
balance algorithm unless I'm mistaken. Whether or not the value is static,
however, might be considered of secondary importance: it is a name instead
of a number and clearly intended to be used as a high level control. I'd
still expect it to be a hint for the algorithm.

The value of the new control would have an effect as long as automatic white
balance is enabled.

> 
> > > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > > b/Documentation/DocBook/media/v4l/controls.xml index c0422c6..350c138
> > > 100644
> > > --- a/Documentation/DocBook/media/v4l/controls.xml
> > > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > > @@ -2841,6 +2841,44 @@ it one step further. This is a write-only
> > > control.</entry>
> > > 
> > >  	  </row>
> > >  	  <row><entry></entry></row>
> > > 
> > > +	  <row id="v4l2-preset-white-balance">
> > > +	    <entry
> > > spanname="id"><constant>V4L2_CID_PRESET_WHITE_BALANCE</constant>&nbsp;</
> > > entry>
> > 
> > Wouldn't V4L2_CID_WHITE_BALANCE_PRESET be better ?
> 
> That's what I was about to say.

And the menu items would contain the same prefix with CID_ removed. They're
going to be long, but I don't see that as an issue for menu items.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
