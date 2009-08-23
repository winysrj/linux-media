Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:46483 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbZHWMuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 08:50:09 -0400
Received: by yxe5 with SMTP id 5so1164798yxe.33
        for <linux-media@vger.kernel.org>; Sun, 23 Aug 2009 05:50:10 -0700 (PDT)
Date: Sun, 23 Aug 2009 08:50:05 -0400
From: James Blanford <jhblanford@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Exposure set bug in stv06xx driver
Message-ID: <20090823085005.77e1167a@blackbart.localnet.prv>
In-Reply-To: <20090822151031.52a0f1e6@blackbart.localnet.prv>
References: <20090822151031.52a0f1e6@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well that was quick.  These issues as well as the stream drops were
remedied in 2.6.31-rc7, except exposure and gain still cannot be set
with v4l2ucp.  As a bonus, I found the autogain white list in
v4l2-apps/libv4l/libv4lconvert/control/libv4lcontrol.c.  Is there a
white list to turn on the gain and exposure manual controls?

While the autogain works great, the autoloss doesn't.  Gain increases
automatically, but is not decreased when light levels rise.  Also,
updating the exposure readout in v4l2ucp decreases the exposure about
10% and incorrectly reports an exposure somewhere between the original
level and the changed level.  E.g., click the exposure update button
and the exposure drops from 20000 to 18000 and reports 19000.

Thanks for all the work.

   -  Jim

On Sat, 22 Aug 2009 15:10:31 -0400
James Blanford <jhblanford@gmail.com> wrote:

> Quickcam Express 046d:0840
> 
> Driver versions:  v 2.60 from 2.6.31-rc6 and v 2.70 from 
> gspca-c9f3938870ab
> 
> Problem:  Overexposure and horizontal orange lines in cam image.
> Exposure and gain controls in gqcam and v4l2ucp do not work.  By
> varying the default exposure and gain settings in stv06xx.h, the lines
> can be orange and/or blue, moving or stationary or a fine grid.
> 
> Workaround:  Using the tool set_cam_exp, any exposure setting removes
> the visual artefacts and reduces the image brightness for a given 
> set of gain and exposure settings.
> 
> By default:
> 
> Aug 21 14:22:02 blackbart kernel: STV06xx: Writing exposure 5000,
> rowexp 0, srowexp 0
> 
> Note what happens when I set the default exposure to 1000:
> 
> Aug 21 20:44:23 blackbart kernel: STV06xx: Writing exposure 1000,
> rowexp 0, srowexp 139438350
> 
> By the way, is there any possibility of enabling autogain?
> 
> Thanks for your interest,
> 
>    -  Jim
> 


-- 
There are two kinds of people.  The innocent and the living.
