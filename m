Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41773 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2HCU52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 16:57:28 -0400
Received: by weyx8 with SMTP id x8so694652wey.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 13:57:27 -0700 (PDT)
Message-ID: <501C3B35.8040306@gmail.com>
Date: Fri, 03 Aug 2012 22:57:25 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Subject: Re: [PATH v3 1/2] v4l: Add factory register values form S5K4ECGX
 sensor
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org> <1343914971-23007-2-git-send-email-sangwook.lee@linaro.org> <501AE81D.70608@gmail.com> <CADPsn1YHJOcx3Faz++oq1eNtuzL6vawCdn5fyvC2gbmLXVDWWA@mail.gmail.com>
In-Reply-To: <CADPsn1YHJOcx3Faz++oq1eNtuzL6vawCdn5fyvC2gbmLXVDWWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 08/03/2012 05:05 PM, Sangwook Lee wrote:
>>> +/* configure 30 fps */
>>> +static const struct regval_list s5k4ecgx_fps_30[] = {
>>
>> It really depends on sensor master clock frequency (as specified
>> in FIMC driver platform data) and PLL setting what the resulting
>> frame rate will be.
>>
>>> +     { 0x700002b4, 0x0052 },
>>
>> Looks surprising! Are we really just disabling horizontal/vertical
>> image mirror here ?
> 
> I believe, this setting values are used still in Galaxy Nexus.
> It might be some reasons  to set this values in the product, but I am not
> sure of this.

My point was that some entries in this table allegedly are setting image 
mirroring, even though the array name suggests it should be only setting 
frame rate to 30 fps. This is just bad practice. If you would have added
HFLIP/VFLIP controls, the register values would have been trashed every
time frame rate is set. Someone would have eventually have had to get rid
of this s5k4ecgx_fps_30 array, in order to add new features.


> [snip]
>>> +     { 0xffffffff, 0x0000 },
>>> +};
>>
>> You already use a sequence of i2c writes in s5k4ecgx_s_ctrl() function
>> for V4L2_CID_SHARPNESS control. So why not just create e.g.
>> s5k4ecgx_set_saturation() and send this array to /dev/null ?
>> Also, invoking v4l2_ctrl_handler_setup() will cause a call to s5k4ecgx_s_ctrl()
>> with default sharpness value (as specified during the control's creation).
>>
>> So I would say this array is redundant in two ways... :)
> 
> Thanks, let me change this.

Thanks, please at least remove those single entry arrays, with the
resolution arrays gone as well and the biggest array converted to
firmware blob I don't see a reason why this driver couldn't be accepted
upstream.

--

Regards,
Sylwester
