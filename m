Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36100 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbcFRQ07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 12:26:59 -0400
Date: Sat, 18 Jun 2016 09:26:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/2] input: add support for HDMI CEC
Message-ID: <20160618162655.GC12210@dtor-ws>
References: <1466261428-12616-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466261428-12616-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Jun 18, 2016 at 04:50:26PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Hi Dmitry,
> 
> This patch series adds input support for the HDMI CEC bus through which
> remote control keys can be passed from one HDMI device to another.
> 
> This has been posted before as part of the HDMI CEC patch series. We are
> going to merge that in linux-media for 4.8, but these two patches have to
> go through linux-input.
> 
> Only the rc-cec keymap file depends on this, and we will take care of that
> dependency (we'll postpone merging that until both these input patches and
> our own CEC patches have been merged in mainline).

If it would be easier for you I am perfectly fine with these patches
going through media tree; you have my acks on them.

Thanks.

-- 
Dmitry
