Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57914 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1KBOUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 10:20:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: new mbus formats
Date: Wed, 2 Nov 2011 15:20:32 +0100
Cc: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	"'Sakari Ailus'" <sakari.ailus@iki.fi>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com> <20110831112323.GL12368@valkosipuli.localdomain> <B85A65D85D7EB246BE421B3FB0FBB5930328A9BD1E@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930328A9BD1E@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111021520.32483.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Sunday 23 October 2011 20:30:11 Hadli, Manjunath wrote:
> Hi,
> 
> I need a few mbus formats to be defined loosely for following. Please tell
> me if anyone has already thought of taking care of them already.
> 
> These are supported for Texas Instruments DM365 and DM355 SoCs.
> 
> 1. RGB 888 parallel:

How is that transfered ? Do you have a 24-bit bus ? Or do you use an 8-bit bus 
with 3 transfers per pixel ? In the first case you will need something like 
V4L2_MBUS_FMT_RGB888_1X24, in the second case V4L2_MBUS_FMT_RGB888_3X8 (and 
the corresponding BGR formats).

> 2. YUV420  color separate:
> 3. C plane 420: ( On the lines of Y plane:  V4L2_MBUS_FMT_Y8_1X8)
> 4. C plane 422

Could you please detail how those three formats are transferred on the bus ?

> 5. 10 bit bayer with ALAW compression.

Is that 10 bit compressed to 8 bit with alaw ? If so

V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8
V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8
V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8
V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8

should do.

-- 
Regards,

Laurent Pinchart
