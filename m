Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60286 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab2JEOPi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 10:15:38 -0400
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Fri, 5 Oct 2012 07:16:42 -0700
Subject: RE: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support
 on marvell-ccic mcam-core
Message-ID: <477F20668A386D41ADCC57781B1F7043083B6575DC@SC-VEXCH1.marvell.com>
References: <1348840040-21390-1-git-send-email-twang13@marvell.com>
 <20120929134041.343c3d56@hpe.lwn.net>
In-Reply-To: <20120929134041.343c3d56@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan

We really appreciate you can review these patches!
Sorry for late response.

>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Sunday, 30 September, 2012 03:41
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support on
>marvell-ccic mcam-core
>
>On Fri, 28 Sep 2012 21:47:20 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> This patch adds the support of Soc Camera on marvell-ccic mcam-core.
>> The Soc Camera mode does not compatible with current mode.
>> Only one mode can be used at one time.
>>
>> To use Soc Camera, CONFIG_VIDEO_MMP_SOC_CAMERA should be defined.
>> What's more, the platform driver should support Soc camera at the same time.
>>
>> Also add MIPI interface and dual CCICs support in Soc Camera mode.
>
>I'm glad this work is being done, but I have some high-level grumbles to start with.
>
>This patch is too big, and does several things. I think there needs to be one to add SOC
>support (but see below), one to add planar formats, one to add MIPI, one for the
>second CCIC, etc. That will make them all easier to review.
>
Yes. Your concern is reasonable, I can understand it.
Actually, we ever try to split the patch into some smaller ones, but it looks will let thing be more complicated.
So we keep the 2 big patches and look forward your comments and suggestions firstly.

We will continue to discuss how to split them if you insist.

>The SOC camera stuff could maybe use a little more thought. Why does this driver
>*need* to be a SOC camera driver?  If that is truly necessary (or sufficiently beneficial),
>can we get to the point where that's the only mode?  I really dislike the two modes; we're
>essentially perpetuating the two-drivers concept in a #ifdef'd form; it would be good not
>to do that.
>
Yes, #ifdef is indeed not a good method.

We will continue to discuss how to remove them.

Maybe I can describe that why we add SOC camera mode:
SOC camera is optional for camera driver, so we try to keep the original method of marvell-ccic
Just let user to select use SOC camera or not use it
 
>If there is truly some reason why both modes need to exist, can we arrange things so
>that the core doesn't know the difference?  I'd like to see no new ifdefs there if possible,
>it already has way too many.
>
>That, I think, is how I'd like to go toward a cleaner, more reviewable, more maintainable
>solution.  Make sense?
>
Yes. We agree with you! :)

>Thanks,
>
>jon

Thanks
Albert Wang
86-21-61092656
