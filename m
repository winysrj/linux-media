Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59573 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759224Ab2EPG5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 02:57:20 -0400
Date: Wed, 16 May 2012 09:57:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 03/23] V4L: Add an extended camera white balance control
Message-ID: <20120516065715.GK3373@valkosipuli.retiisi.org.uk>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
 <1336645858-30366-4-git-send-email-s.nawrocki@samsung.com>
 <20120514000234.GG3373@valkosipuli.retiisi.org.uk>
 <4FB2CA63.2000605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB2CA63.2000605@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, May 15, 2012 at 11:28:03PM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 05/14/2012 02:02 AM, Sakari Ailus wrote:
> > Hi Sylwester,
> > 
> > Thanks for the patch. I noticed your pull req; I hope you could take into
> > account a few more comments. :)
> 
> Thank you for your comments, I'll try to come up with a fix up patch.
>  
> > On Thu, May 10, 2012 at 12:30:38PM +0200, Sylwester Nawrocki wrote:
> >> This patch adds V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE control which is
> >> an extended version of the V4L2_CID_AUTO_WHITE_BALANCE control,
> >> including white balance presets. The following presets are defined:
> >>
> >>   - V4L2_WHITE_BALANCE_INCANDESCENT,
> >>   - V4L2_WHITE_BALANCE_FLUORESCENT,
> >>   - V4L2_WHITE_BALANCE_FLUORESCENT_H,
> >>   - V4L2_WHITE_BALANCE_HORIZON,
> >>   - V4L2_WHITE_BALANCE_DAYLIGHT,
> >>   - V4L2_WHITE_BALANCE_FLASH,
> >>   - V4L2_WHITE_BALANCE_CLOUDY,
> >>   - V4L2_WHITE_BALANCE_SHADE.
> >>
> >> Signed-off-by: HeungJun Kim<riverful.kim@samsung.com>
> >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> Acked-by: Hans de Goede<hdegoede@redhat.com>
> >> ---
> >>   Documentation/DocBook/media/v4l/controls.xml |   70 ++++++++++++++++++++++++++
> >>   drivers/media/video/v4l2-ctrls.c             |   17 +++++++
> >>   include/linux/videodev2.h                    |   14 ++++++
> >>   3 files changed, 101 insertions(+)
> >>
> >> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> >> index 40e6485..85d1ca0 100644
> >> --- a/Documentation/DocBook/media/v4l/controls.xml
> >> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >> @@ -3022,6 +3022,76 @@ camera sensor on or off, or specify its strength. Such band-stop filters can
> >>   be used, for example, to filter out the fluorescent light component.</entry>
> >>   	</row>
> >>   	<row><entry></entry></row>
> >> +
> >> +	<row id="v4l2-auto-n-preset-white-balance">
> >> +	<entry spanname="id"><constant>V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE</constant>&nbsp;</entry>
> >> +	<entry>enum&nbsp;v4l2_auto_n_preset_white_balance</entry>
> >> +	</row><row><entry spanname="descr">Sets white balance to automatic,
> >> +manual or a preset. The presets determine color temperature of the light as
> >> +a hint to the camera for white balance adjustments resulting in most accurate
> >> +color representation. The following white balance presets are listed in order
> >> +of increasing color temperature.</entry>
> >> +	</row>
> >> +	<row>
> >> +	<entrytbl spanname="descr" cols="2">
> >> +	<tbody valign="top">
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_MANUAL</constant>&nbsp;</entry>
> >> +		<entry>Manual white balance.</entry>
> >> +		</row>
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_AUTO</constant>&nbsp;</entry>
> >> +		<entry>Automatic white balance adjustments.</entry>
> >> +		</row>
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_INCANDESCENT</constant>&nbsp;</entry>
> >> +		<entry>White balance setting for incandescent (tungsten) lighting.
> >> +It generally cools down the colors and corresponds approximately to 2500...3500 K
> >> +color temperature range.</entry>
> >> +		</row>
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>&nbsp;</entry>
> >> +		<entry>White balance preset for fluorescent lighting.
> >> +It corresponds approximately to 4000...5000 K color temperature.</entry>
> >> +		</row>
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT_H</constant>&nbsp;</entry>
> >> +		<entry>With this setting the camera will compensate for
> >> +fluorescent H lighting.</entry>
> >> +		</row>
> > 
> > I don't remember for quite sure if I replied to this already... what's the
> > diff between the above two?
> 
> No, you didn't, otherwise I would certainly remember that ;)
> 
> V4L2_WHITE_BALANCE_FLUORESCENT_H is for newer, daylight calibrated fluorescent
> lamps. So this preset will generally cool down the colours less than
> V4L2_WHITE_BALANCE_FLUORESCENT. I was even thinking about a separate control 
> for V4L2_WHITE_BALANCE_FLUORESCENT, since some ISPs have several presets for
> fluorescent lighting. I dropped that idea finally though.

I don't know about the daylight calibrated ones, but the older ones often
tend to give colder light. Nevertheless, I think it'd be good to mention
this in the documentation. I couldn't thave guessed it. :)

> > The colour temperature of the fluorescent light depends on the lamp; 2500 K
> > is not uncommon here in Finland. It's the spectrum that's different from
> > incandescents, not necessarily the colour temperature.
> >
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_HORIZON</constant>&nbsp;</entry>
> >> +		<entry>White balance setting for horizon daylight.
> >> +It corresponds approximately to 5000 K color temperature.</entry>
> >> +		</row>
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_DAYLIGHT</constant>&nbsp;</entry>
> >> +		<entry>White balance preset for daylight (with clear sky).
> >> +It corresponds approximately to 5000...6500 K color temperature.</entry>
> >> +		</row>
> >> +		<row>
> >> +		<entry><constant>V4L2_WHITE_BALANCE_FLASH</constant>&nbsp;</entry>
> >> +		<entry>With this setting the camera will compensate for the flash
> >> +light. It slightly warms up the colors and corresponds roughly to 5000...5500 K
> >> +color temperature.</entry>
> > 
> > This also depends heavily on the type of the flash.
> 
> OK, I'm going to remove this one, and for V4L2_WHITE_BALANCE_FLUORESCENT as well.
> I would prefer to keep the remaining ones though.

Sounds good to me.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
