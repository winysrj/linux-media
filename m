Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59490 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2D1IWv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 04:22:51 -0400
Received: by wejx9 with SMTP id x9so879505wej.19
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 01:22:49 -0700 (PDT)
Message-ID: <4F9BA8D8.6010603@gmail.com>
Date: Sat, 28 Apr 2012 10:22:48 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, sungchun.kang@samsung.com,
	subash.ramaswamy@linaro.org
Subject: Re: [PATCH 01/13] V4L: Extend V4L2_CID_COLORFX with more image effects
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com> <201204271212.09323.hverkuil@xs4all.nl> <4F9ADD6A.6040005@gmail.com> <201204272102.57705.hverkuil@xs4all.nl>
In-Reply-To: <201204272102.57705.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/27/2012 09:02 PM, Hans Verkuil wrote:
> On Friday, April 27, 2012 19:54:50 Sylwester Nawrocki wrote:
>  > On 04/27/2012 12:12 PM, Hans Verkuil wrote:
>  > > On Friday, April 27, 2012 11:52:54 Sylwester Nawrocki wrote:
>  > >> This patch adds definition of additional color effects:
>  > >> - V4L2_COLORFX_AQUA,
>  > >> - V4L2_COLORFX_ART_FREEZE,
>  > >> - V4L2_COLORFX_SILHOUETTE,
>  > >> - V4L2_COLORFX_SOLARIZATION,
>  > >> - V4L2_COLORFX_ANTIQUE,
>  > >> - V4L2_COLORFX_ARBITRARY_CBCR.
> 
> BTW, reading this again I think "ARBITRARY_CBCR" is a confusing name. 
> Perhaps "REPLACE_CBCR" or "SET_CBCR" is better?

This is how it was named in the datasheets ;-) I like 
V4L2_COLORFX_REPLACE_CBCR better. What about 

V4L2_COLORFX_CONSTANT_CBCR,
V4L2_COLORFX_PATTERN_CBCR or
V4L2_COLORFX_FILL_IN_CBCR ?

...
> Maybe it would be better to add a V4L2_COLORFX_COLOR menu entry and
>  > V4L2_CID_COLORFX_CB, V4L2_CID_COLORFX_CR controls ?
> 
> That would work, yes. Although I am not convinced splitting it up is 
> worthwhile.
> The colorspace can change on the fly, so you would have to handle 
> out-of-range
> values anyway. Personally I would stick with CID_COLORFX_CBCR (and 
> clearly document in which byte the CB and the CR go).

That's going to be sufficient I guess. Applications will most likely 
be just pre-configured with some fixed CB/CR values, mapped to some 
meaningful names. It should be fine, as far as those coefficient 
registers are accessible from user space. 

> That's just my opinion, though.
> 
> Regards,
> Hans
> 
> PS: I'll review the "camera control enhancements" patch series in the 
> next few days.

Great, thanks a lot!

I was thinking about a guide on which control groups should be used 
for each devices, to make the driver and application writers' life 
easier, but its not an easy task in light of high diversity of 
camera devices...


--
Regards,
Sylwester
