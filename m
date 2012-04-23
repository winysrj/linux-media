Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2DWHwW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 03:52:22 -0400
Message-ID: <4F950AC2.1000103@redhat.com>
Date: Mon, 23 Apr 2012 09:54:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Fwd: Re: [PATCH 04/15] V4L: Add camera white balance preset control
References: <4F91842A.9070505@samsung.com> <4F9426AF.20200@gmail.com>
In-Reply-To: <4F9426AF.20200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/22/2012 05:41 PM, Sylwester Nawrocki wrote:
> Hi,
>

<snip long discussion coming down to consensus to fold manual/auto/preset1-# into
1 new (for ABI reasons) awb menu control>

> So I'm going to rework patch 04/15, to remove V4L2_WHITE_BALANCE_PRESET_NONE and
> add AUTO, MANUAL entries. Only the CID name is still an open issue.
>
>
> Some examples to start with:
>
> #define V4L2_CID_WHITE_BALANCE_AUTO  (V4L2_CID_CAMERA_CLASS_BASE+XX)
> enum v4l2_white_balance_auto {
> 	V4L2_WHITE_BALANCE_AUTO,
> 	V4L2_WHITE_BALANCE_MANUAL,
> 	V4L2_WHITE_BALANCE_INCANDESCENT,
> 	V4L2_WHITE_BALANCE_FLUORESCENT,
> 	V4L2_WHITE_BALANCE_FLUORESCENT_H,
> 	V4L2_WHITE_BALANCE_HORIZON,
> 	V4L2_WHITE_BALANCE_DAYLIGHT,
> 	V4L2_WHITE_BALANCE_FLASH,
> 	V4L2_WHITE_BALANCE_CLOUDY,
> 	V4L2_WHITE_BALANCE_SHADE,
> };
>
> or
>
> #define V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE  (V4L2_CID_CAMERA_CLASS_BASE+XX)
> enum v4l2_auto_n_preset_white_balance {
> 	V4L2_WHITE_BALANCE_AUTO,
> 	V4L2_WHITE_BALANCE_MANUAL,
> 	V4L2_WHITE_BALANCE_INCANDESCENT,
> 	V4L2_WHITE_BALANCE_FLUORESCENT,
> 	V4L2_WHITE_BALANCE_HORIZON,
> 	V4L2_WHITE_BALANCE_DAYLIGHT,
> 	V4L2_WHITE_BALANCE_FLASH,
> 	V4L2_WHITE_BALANCE_CLOUDY,
> 	V4L2_WHITE_BALANCE_SHADE,
> };

I think I like the above one best, I know the name V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE
isn't really pretty, but it clearly indicates what it is and how it is different
from V4L2_CID_AUTO_WHITE_BALANCE. Given that I guess we could just keep
V4L2_CID_AUTO_WHITE_BALANCE as is for simpler drivers, as I think in the simple
manual/auto case a boolean is a better way to represent the control.

>
>
> enum v4l2_auto_n_preset_white_balance {
> 	V4L2_AUTO_N_PRESET_WHITE_BALANCE_AUTO,
> 	V4L2_AUTO_N_PRESET_WHITE_BALANCE_MANUAL,
> 	V4L2_AUTO_N_PRESET_WHITE_BALANCE_INCANDESCENT,
> 	...
>
> would be unfortunately a bit cumbersome.

Thanks & Regards,

Hans
