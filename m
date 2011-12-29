Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39036 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1L2X5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 18:57:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
Date: Fri, 30 Dec 2011 00:58:01 +0100
Cc: "'Sylwester Nawrocki'" <snjw23@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, kyungmin.park@samsung.com,
	"'Hans de Goede'" <hdegoede@redhat.com>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <201112281451.39399.laurent.pinchart@ideasonboard.com> <001101ccc5e7$d9f48620$8ddd9260$%kim@samsung.com>
In-Reply-To: <001101ccc5e7$d9f48620$8ddd9260$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112300058.01726.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 29 December 2011 06:08:07 HeungJun, Kim wrote:
> On Wednesday, December 28, 2011 10:52 PM Laurent Pinchart wrote:
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
> > > 
> > > 	"Indoor (Incandescant Lighting) Mode",
> > > 	"Outdoor (Sunlight) Mode",
> > > 	"Indoor (Fluorescent Lighting) Mode",
> > > 	"Manual Mode",
> > > 	"Auto Mode",
> > > 	NULL
> > > 
> > > };
> > > 
> > > static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
> > > 
> > > 	.ops	= &pwc_ctrl_ops,
> > > 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
> > > 	.type	= V4L2_CTRL_TYPE_MENU,
> > > 	.max	= awb_auto,
> > > 	.qmenu	= pwc_auto_whitebal_qmenu,
> > > 
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
> > > Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would be a better fit
> > > for that :)
> > > 
> > > Nevertheless, redefining standard controls in particular drivers sounds
> > > a little dubious. I wonder if this is a generally agreed approach ?
> > 
> > No agreed with me at least :-)
> 
> I guess the WBP menu controls of pwc driver is probably defined in the
> other headers, for users being well known the PWC hardware. So it should
> be managed separately to videodev2.h. Is it right? Even if the way might
> be slightly different, it can't avoid to be "managed separately".
> 
> It means the users being not well known the specific hardware like PWC,
> have difficulty to use that driver well.
> And, at least, It doesn't looks generic API for me.
> In this case, the unfamiliar user with such unique hardware, can use
> whatever he wants to use finally, after finding & looking around the
> headers.

I think Sylwester was just pointing the pwc driver out as implementing a 
custom white balance preset control to make sure we're aware of it, not to 
advocate such an approach. We need to make sure that the generic white balance 
preset control can handle the pwc driver's needs.

> On the other hand, if the definition is defined in the videodev2.h, or at
> least the videodev2.h also include separated API's headers(I'm not sure
> this way, but my real meaning is needed to be consolidated only one way to
> control hardware, like videodev2.h), it looks more be better.
> 
> As such meaning, I agreed to Sylwester's word "dubious".
> 
> But, here's the thing.
> If the any control suggested does not look general function on camera,
> and it is used "only at the specific hardware", we should avoid this.
> 
> As you know, the White Balance Preset is very general camera's feature,
> and the term's name is also very normal to the digital camera users.
> Almost digital camera have this function.
> 
> Probably, Laurent might be concern about such "generality". Am I right?

I agree that a generic white balance preset control is needed. I think the 
documentation should be improved though, to clearly define how the control 
works.

> > > Then, how does your V4L2_CID_PRESET_WHITE_BALANCE control interact with
> > > V4L2_CID_AUTO_WHITE_BALANCE control ? Does V4L2_CID_AUTO_WHITE_BALANCE
> > > need to be set to false for V4L2_CID_PRESET_WHITE_BALANCE to be
> > > effective ?
> > 
> > Is the preset a fixed white balance setting, or is it an auto white
> > balance with the algorithm tuned for a particular configuration ? In the
> > first case, does it correspond to a fixed white balance temperature
> > value ?
> > 
> > [snip]
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
> > > > spanname="id"><constant>V4L2_CID_PRESET_WHITE_BALANCE</constant>&nbsp
> > > > ;</ entry>
> > > 
> > > Wouldn't V4L2_CID_WHITE_BALANCE_PRESET be better ?
> > 
> > That's what I was about to say.
> 
> I saw the controls related with White Balance and most cid's name
> is V4L2_CID_XXXX_WHITE_BALANCE. So, I just used that name.
> But, I don't know why the PRESET's position is important.
> Can anyone explain to me?
> After I know it, I seems to talk about this subject.
> 
> Anyway, I guess Laurent had in mind for another class "preset".

I'm not sure about the name, but I think it might make sense to put those 
high-level camera controls in a new class.

-- 
Regards,

Laurent Pinchart
