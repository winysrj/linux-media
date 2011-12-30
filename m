Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:21689 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1L3GgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 01:36:03 -0500
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LX000B1N7NZMEI0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Dec 2011 15:36:00 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LX000L577NZLT80@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Fri, 30 Dec 2011 15:36:00 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: 'Sylwester Nawrocki' <snjw23@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	'Hans de Goede' <hdegoede@redhat.com>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
 <4EFB1B04.6060305@gmail.com>
 <201112281451.39399.laurent.pinchart@ideasonboard.com>
 <20111229233406.GU3677@valkosipuli.localdomain>
In-reply-to: <20111229233406.GU3677@valkosipuli.localdomain>
Subject: RE: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
Date: Fri, 30 Dec 2011 15:35:59 +0900
Message-id: <000801ccc6bd$4b844520$e28ccf60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the comments!

Your comments help me to order my thoughts and re-send RFC.

Anyway, I hope to be happy new year :)

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Friday, December 30, 2011 8:34 AM
> To: Laurent Pinchart
> Cc: Sylwester Nawrocki; HeungJun, Kim; linux-media@vger.kernel.org;
> mchehab@redhat.com; hverkuil@xs4all.nl; kyungmin.park@samsung.com; Hans de
> Goede
> Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu
> control
> 
> Hi Laurent, Sylwester and HeungJun,
> 
> On Wed, Dec 28, 2011 at 02:51:38PM +0100, Laurent Pinchart wrote:
> > Hi,
> >
> > On Wednesday 28 December 2011 14:35:00 Sylwester Nawrocki wrote:
> > > On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
> > > > It adds the new CID for setting White Balance Preset. This CID is
> > > > provided as menu type using the following items:
> > > > 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
> > > > 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
> > > > 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
> > > > 3 - V4L2_WHITE_BALANCE_CLOUDY,
> > > > 4 - V4L2_WHITE_BALANCE_SHADE,
> > >
> > > I have been also investigating those white balance presets recently and
> > > noticed they're also needed for the pwc driver. Looking at
> > > drivers/media/video/pwc/pwc-v4l2.c there is something like:
> > >
> > > const char * const pwc_auto_whitebal_qmenu[] = {
> > > 	"Indoor (Incandescant Lighting) Mode",
> > > 	"Outdoor (Sunlight) Mode",
> > > 	"Indoor (Fluorescent Lighting) Mode",
> > > 	"Manual Mode",
> > > 	"Auto Mode",
> > > 	NULL
> > > };
> > >
> > > static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
> > > 	.ops	= &pwc_ctrl_ops,
> > > 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
> > > 	.type	= V4L2_CTRL_TYPE_MENU,
> > > 	.max	= awb_auto,
> > > 	.qmenu	= pwc_auto_whitebal_qmenu,
> > > };
> > >
> > > ...
> > >
> > > 	cfg = pwc_auto_white_balance_cfg;
> > > 	cfg.name = v4l2_ctrl_get_name(cfg.id);
> > > 	cfg.def = def;
> > > 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
> > >
> > > So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu control
> > > with custom entries. That's interesting... However it works in practice
> > > and applications have access to what's provided by hardware.
> > > Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would be a better fit for
> > > that :)
> > >
> > > Nevertheless, redefining standard controls in particular drivers sounds
> > > a little dubious. I wonder if this is a generally agreed approach ?
> >
> > No agreed with me at least :-)
> >
> > > Then, how does your V4L2_CID_PRESET_WHITE_BALANCE control interact with
> > > V4L2_CID_AUTO_WHITE_BALANCE control ? Does V4L2_CID_AUTO_WHITE_BALANCE
need
> > > to be set to false for V4L2_CID_PRESET_WHITE_BALANCE to be effective ?
> >
> > Is the preset a fixed white balance setting, or is it an auto white balance
> > with the algorithm tuned for a particular configuration ? In the first case,
> > does it correspond to a fixed white balance temperature value ?
> 
> While I'm waiting for a final answer to this, I guess it's the second. There
> are three things involved here:
> 
> - V4L2_CID_WHITE_BALANCE_TEMPERATURE: relatively low level control telling
>   the colour temperature of the light source. Setting a value for this
>   essentially means using manual white balance.
> 
> - V4L2_CID_AUTO_WHITE_BALANCE: automatic white balance enabled or disabled.
> 
> The new control proposed by HeungJun is input for the automatic white
> balance algorithm unless I'm mistaken. Whether or not the value is static,
> however, might be considered of secondary importance: it is a name instead
> of a number and clearly intended to be used as a high level control. I'd
> still expect it to be a hint for the algorithm.
> 
> The value of the new control would have an effect as long as automatic white
> balance is enabled.
No, it's a kind of Manual White Balance, not Auto. It's the same level of
V4L2_CID_WHITE_BALANCE_TEMPERATURE. So, only when V4L2_CID_AUTO_WHITE_BALANCE is

disabled, this control is enabled.

The relationship between each white balance controls by my understanding is
here.

Auto White Balance
  - V4L2_CID_AUTO_WHITE_BALANCE(Boolean)
    : enable/disable Auto white balance.
    : Enable means current mode is Auto, and disable means current mode is
Manual

Manual White Balance
  - V4L2_CID_WHITE_BALANCE_TEMPERATURE(integer)
    : Setting the temperature of Manual
    : Only when the V4L2_CID_AUTO_WHITE_BALANCE is disabled, and current mode
Manual.

- V4L2_CID_WHITE_BALANCE_PRESET(menu) - I suggested
    : Setting the specific temperature value(but, the value is not fetched by
user) of Manual
    : Only when the V4L2_CID_AUTO_WHITE_BALANCE is disabled, and current mode
Manual.

The "input" is right. And, this "input" just triggers the ISP(sensor) set the
specific
manual white balance value embedded in the ISP. 
I think this control does not affect the Auto White Balance.

Regards,
Heungjun Kim

> 
> >
> > > > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > > > b/Documentation/DocBook/media/v4l/controls.xml index c0422c6..350c138
> > > > 100644
> > > > --- a/Documentation/DocBook/media/v4l/controls.xml
> > > > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > > > @@ -2841,6 +2841,44 @@ it one step further. This is a write-only
> > > > control.</entry>
> > > >
> > > >  	  </row>
> > > >  	  <row><entry></entry></row>
> > > >
> > > > +	  <row id="v4l2-preset-white-balance">
> > > > +	    <entry
> > > > spanname="id"><constant>V4L2_CID_PRESET_WHITE_BALANCE</constant>&nbsp;</
> > > > entry>
> > >
> > > Wouldn't V4L2_CID_WHITE_BALANCE_PRESET be better ?
> >
> > That's what I was about to say.
> 
> And the menu items would contain the same prefix with CID_ removed. They're
> going to be long, but I don't see that as an issue for menu items.
> 
> Cheers,
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

