Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57579 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab2D0Ryy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 13:54:54 -0400
Received: by bkuw12 with SMTP id w12so712738bku.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 10:54:52 -0700 (PDT)
Message-ID: <4F9ADD6A.6040005@gmail.com>
Date: Fri, 27 Apr 2012 19:54:50 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, sungchun.kang@samsung.com,
	subash.ramaswamy@linaro.org
Subject: Re: [PATCH 01/13] V4L: Extend V4L2_CID_COLORFX with more image effects
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com> <1335520386-20835-2-git-send-email-s.nawrocki@samsung.com> <201204271212.09323.hverkuil@xs4all.nl>
In-Reply-To: <201204271212.09323.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thanks for the review!

On 04/27/2012 12:12 PM, Hans Verkuil wrote:
> Hi Sylwester!
> 
> On Friday, April 27, 2012 11:52:54 Sylwester Nawrocki wrote:
>> This patch adds definition of additional color effects:
>>   - V4L2_COLORFX_AQUA,
>>   - V4L2_COLORFX_ART_FREEZE,
>>   - V4L2_COLORFX_SILHOUETTE,
>>   - V4L2_COLORFX_SOLARIZATION,
>>   - V4L2_COLORFX_ANTIQUE,
>>   - V4L2_COLORFX_ARBITRARY_CBCR.
>>
>> The control's type in the documentation is changed from 'enum' to 'menu'
>> - V4L2_CID_COLORFX has always been a menu, not an integer type control.
>>
>> The V4L2_COLORFX_ARBITRARY_CBCR option enables custom color effects,
>> which are impossible or impractical to define as menu items. The
>> V4L2_CID_BLUE_BALANCE and V4L2_CID_RED_BALANCE controls allow in this
>> case to configure the Cb, Cr coefficients.
> 
> So this just hijacks the RED/BLUE_BALANCE controls for a different purpose?

Uh, the meaning is indeed a bit different. Probably not a good idea to reuse
the controls like this in the standard API.

> If I understand this 'effect' correctly it just replaces the Cb and Cr
> coefficients with fixed values, basically giving you a B&W picture (the Y
> coefficient), except that it is really a 'Black&FixedColor' picture.

Yes, this is also my understanding. The TRMs are not very verbose about it,
but I think it is exactly how it works. The effect is similar to looking
through a coloured glass, where colour changes from green through red to violet
when changing the (CR, CB) coefficients gradually from (0, 0) -> (0, 255) -> 
(255, 255).
 
> I think you should add a new control for setting this. V4L2_CID_COLORFX_COLOR
> or something.

Do you mean something similar to V4L2_CID_BG_COLOR ? When a different colour 
space is used then the range for those Cb, Cr components changes. It can be 
0...255 or 16...240. So best would be to have 2 controls, for reporting min/max
to the user.

Maybe it would be better to add a V4L2_COLORFX_COLOR menu entry and
V4L2_CID_COLORFX_CB, V4L2_CID_COLORFX_CR controls ?


--

Regards,
Sylwester
