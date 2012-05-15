Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965665Ab2EOV2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 17:28:07 -0400
Received: by wgbdr13 with SMTP id dr13so39205wgb.1
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 14:28:05 -0700 (PDT)
Message-ID: <4FB2CA63.2000605@gmail.com>
Date: Tue, 15 May 2012 23:28:03 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 03/23] V4L: Add an extended camera white balance control
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com> <1336645858-30366-4-git-send-email-s.nawrocki@samsung.com> <20120514000234.GG3373@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120514000234.GG3373@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 05/14/2012 02:02 AM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Thanks for the patch. I noticed your pull req; I hope you could take into
> account a few more comments. :)

Thank you for your comments, I'll try to come up with a fix up patch.
 
> On Thu, May 10, 2012 at 12:30:38PM +0200, Sylwester Nawrocki wrote:
>> This patch adds V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE control which is
>> an extended version of the V4L2_CID_AUTO_WHITE_BALANCE control,
>> including white balance presets. The following presets are defined:
>>
>>   - V4L2_WHITE_BALANCE_INCANDESCENT,
>>   - V4L2_WHITE_BALANCE_FLUORESCENT,
>>   - V4L2_WHITE_BALANCE_FLUORESCENT_H,
>>   - V4L2_WHITE_BALANCE_HORIZON,
>>   - V4L2_WHITE_BALANCE_DAYLIGHT,
>>   - V4L2_WHITE_BALANCE_FLASH,
>>   - V4L2_WHITE_BALANCE_CLOUDY,
>>   - V4L2_WHITE_BALANCE_SHADE.
>>
>> Signed-off-by: HeungJun Kim<riverful.kim@samsung.com>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> Acked-by: Hans de Goede<hdegoede@redhat.com>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml |   70 ++++++++++++++++++++++++++
>>   drivers/media/video/v4l2-ctrls.c             |   17 +++++++
>>   include/linux/videodev2.h                    |   14 ++++++
>>   3 files changed, 101 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 40e6485..85d1ca0 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -3022,6 +3022,76 @@ camera sensor on or off, or specify its strength. Such band-stop filters can
>>   be used, for example, to filter out the fluorescent light component.</entry>
>>   	</row>
>>   	<row><entry></entry></row>
>> +
>> +	<row id="v4l2-auto-n-preset-white-balance">
>> +	<entry spanname="id"><constant>V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE</constant>&nbsp;</entry>
>> +	<entry>enum&nbsp;v4l2_auto_n_preset_white_balance</entry>
>> +	</row><row><entry spanname="descr">Sets white balance to automatic,
>> +manual or a preset. The presets determine color temperature of the light as
>> +a hint to the camera for white balance adjustments resulting in most accurate
>> +color representation. The following white balance presets are listed in order
>> +of increasing color temperature.</entry>
>> +	</row>
>> +	<row>
>> +	<entrytbl spanname="descr" cols="2">
>> +	<tbody valign="top">
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_MANUAL</constant>&nbsp;</entry>
>> +		<entry>Manual white balance.</entry>
>> +		</row>
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_AUTO</constant>&nbsp;</entry>
>> +		<entry>Automatic white balance adjustments.</entry>
>> +		</row>
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_INCANDESCENT</constant>&nbsp;</entry>
>> +		<entry>White balance setting for incandescent (tungsten) lighting.
>> +It generally cools down the colors and corresponds approximately to 2500...3500 K
>> +color temperature range.</entry>
>> +		</row>
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>&nbsp;</entry>
>> +		<entry>White balance preset for fluorescent lighting.
>> +It corresponds approximately to 4000...5000 K color temperature.</entry>
>> +		</row>
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT_H</constant>&nbsp;</entry>
>> +		<entry>With this setting the camera will compensate for
>> +fluorescent H lighting.</entry>
>> +		</row>
> 
> I don't remember for quite sure if I replied to this already... what's the
> diff between the above two?

No, you didn't, otherwise I would certainly remember that ;)

V4L2_WHITE_BALANCE_FLUORESCENT_H is for newer, daylight calibrated fluorescent
lamps. So this preset will generally cool down the colours less than
V4L2_WHITE_BALANCE_FLUORESCENT. I was even thinking about a separate control 
for V4L2_WHITE_BALANCE_FLUORESCENT, since some ISPs have several presets for
fluorescent lighting. I dropped that idea finally though.

> The colour temperature of the fluorescent light depends on the lamp; 2500 K
> is not uncommon here in Finland. It's the spectrum that's different from
> incandescents, not necessarily the colour temperature.
>
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_HORIZON</constant>&nbsp;</entry>
>> +		<entry>White balance setting for horizon daylight.
>> +It corresponds approximately to 5000 K color temperature.</entry>
>> +		</row>
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_DAYLIGHT</constant>&nbsp;</entry>
>> +		<entry>White balance preset for daylight (with clear sky).
>> +It corresponds approximately to 5000...6500 K color temperature.</entry>
>> +		</row>
>> +		<row>
>> +		<entry><constant>V4L2_WHITE_BALANCE_FLASH</constant>&nbsp;</entry>
>> +		<entry>With this setting the camera will compensate for the flash
>> +light. It slightly warms up the colors and corresponds roughly to 5000...5500 K
>> +color temperature.</entry>
> 
> This also depends heavily on the type of the flash.

OK, I'm going to remove this one, and for V4L2_WHITE_BALANCE_FLUORESCENT as well.
I would prefer to keep the remaining ones though.

> I'd just remove the colour temperature from most of these since it looks
> more like assumptions made in a particular system rather than something
> generic.

The colour temperature ranges are mostly rough estimates to give an overview
of what these presets are. I compared multiple information sources when
preparing those colour temperature ranges. So it's obviously not based on 
a single system. However since some may give false information, I'm going
to remove them.

Regards,
Sylwester
