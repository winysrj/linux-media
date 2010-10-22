Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63663 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab0JVNZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 09:25:01 -0400
Received: by gyg4 with SMTP id 4so586564gyg.19
        for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 06:25:00 -0700 (PDT)
Subject: Re: [PATCH] Support for Elgato Video Capture.
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20E008D5-74E6-4BD7-8337-08A27646E265@realvnc.com>
Date: Fri, 22 Oct 2010 09:25:15 -0400
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1CA567F4-48D2-4C45-B65B-26F1F7056BEA@wilsonet.com>
References: <20E008D5-74E6-4BD7-8337-08A27646E265@realvnc.com>
To: Adrian Taylor <adrian.taylor@realvnc.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 22, 2010, at 7:30 AM, Adrian Taylor wrote:

> This patch allows this device successfully to show video, at least from
> its composite input.
> 
> I have no information about the true hardware contents of this device and so
> this patch is based solely on fiddling with things until it worked. The
> chip appears to be em2860, and the closest device with equivalent inputs
> is the Typhoon DVD Maker. Copying the settings for that device appears
> to do the trick. That's what this patch does.
> 
> Patch redone against the staging/v2.6.37 branch of the v4l/dvb
> media_tree as requested.
> 
> Signed-off-by: Adrian Taylor <adrian.taylor@realvnc.com>

Looks good, thanks for the redo.

Reviewed-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@wilsonet.com



