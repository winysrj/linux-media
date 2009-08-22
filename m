Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:49874 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbZHVTKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 15:10:43 -0400
Received: by rv-out-0506.google.com with SMTP id f6so483522rvb.1
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2009 12:10:45 -0700 (PDT)
Date: Sat, 22 Aug 2009 15:10:31 -0400
From: James Blanford <jhblanford@gmail.com>
To: linux-media@vger.kernel.org
Subject: Exposure set bug in stv06xx driver
Message-ID: <20090822151031.52a0f1e6@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quickcam Express 046d:0840

Driver versions:  v 2.60 from 2.6.31-rc6 and v 2.70 from 
gspca-c9f3938870ab

Problem:  Overexposure and horizontal orange lines in cam image.
Exposure and gain controls in gqcam and v4l2ucp do not work.  By
varying the default exposure and gain settings in stv06xx.h, the lines
can be orange and/or blue, moving or stationary or a fine grid.

Workaround:  Using the tool set_cam_exp, any exposure setting removes
the visual artefacts and reduces the image brightness for a given 
set of gain and exposure settings.

By default:

Aug 21 14:22:02 blackbart kernel: STV06xx: Writing exposure 5000,
rowexp 0, srowexp 0

Note what happens when I set the default exposure to 1000:

Aug 21 20:44:23 blackbart kernel: STV06xx: Writing exposure 1000,
rowexp 0, srowexp 139438350

By the way, is there any possibility of enabling autogain?

Thanks for your interest,

   -  Jim

-- 
There are two kinds of people.  The innocent and the living.
