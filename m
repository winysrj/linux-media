Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu3sys201aog104.obsmtp.com ([207.126.148.94]:50658 "HELO
	eu3sys201aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756642Ab3BSMr3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 07:47:29 -0500
From: Camera.Geomatics@leica-geosystems.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
MIME-Version: 1.0
Subject: MT9P031 manual BLC
Message-ID: <OF2E977037.5AC0B23B-ONC1257B17.0044DC11-C1257B17.00450C1A@leica-geosystems.com>
Date: Tue, 19 Feb 2013 13:34:11 +0100
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I am looking for advise on the MT9P031 manual black level calibration. I 
can see that the MT9P031 driver on the mainline kernel supports manual BLC 
with the V4L2_CID_BLC_* controls.
Even though I use an older version of the MT9P031 driver, controlling of 
black level calibration is handled the same way with the same registers 
and bits as on mainline revision. compared to my version. When I try to 
use manual BLC instead of automatic black level calibration I get kind of 
a strange vertical interlaced pattern. I was able to adjust black level 
with 
MT9P031_ROW_BLACK_DEF_OFFSET
MT9P031_GREEN1_OFFSET
MT9P031_GREEN2_OFFSET
MT9P031_RED_OFFSET
MT9P031_BLUE_OFFSET
but haven?t get rid of that vertical line interference. As soon as I 
switch back to automatic BLC, the pattern is gone. Has anyone already 
experienced such a behavior?
The documentation about register MT9P031_BLACK_LEVEL_CALIBRATION (0x62) 
seems to be removed on newer datasheets. Are there any known issues with 
manual BLC which caused Aptina to remove the description of this register?
Regards,
Daniel Blaser

