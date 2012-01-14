Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:47949 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab2ANSX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 13:23:57 -0500
Date: Sat, 14 Jan 2012 19:24:14 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v2 3/4] gspca: sonixj: Add
 V4L2_CID_JPEG_COMPRESSION_QUALITY control support
Message-ID: <20120114192414.05ad2e83@tele>
In-Reply-To: <4F11BE7C.3060601@gmail.com>
References: <4EBECD11.8090709@gmail.com>
	<1325873682-3754-4-git-send-email-snjw23@gmail.com>
	<20120114094720.781f89a5@tele>
	<4F11BE7C.3060601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Jan 2012 18:42:20 +0100
Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:

> Thank you for reviewing the patches. I wasn't sure I fully understood
> the locking, hence I left the 'quality' field in 'struct sd' not removed. 
> I've modified both subdrivers according to your suggestions. I would have 
> one question before I send the corrected patches though. Unlike zc3xx, 
> the configured quality value in sonixj driver changes dynamically, i.e. 
> it drifts away in few seconds from whatever value the user sets. This makes
> me wonder if .set_control operation should be implemented for the QUALITY
> control, and whether to leave V4L2_CTRL_FLAG_READ_ONLY control flag or not.
> 
> There seem to be not much value in setting such control for the user,
> but maybe it's different for other devices covered by the sonixj driver.

Setting the JPEG quality in sonixj has been removed when automatic
quality adjustment has been added (git commit b96cfc33e7). At this
time, I let the JPEG get function, but it could have been removed as
well: I don't think the users are interested by this quality, and the
applications may find it looking at the quantization tables of the
images.

Otherwise, letting the users/applications to set this quality is
dangerous: if the quality is too high, the images cannot be fully
transmitted because their size is too big for the USB 1.1 channel.

So, IMO, you should let the sonixj as it is, and I will remove the
get_jepgcomp.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
