Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37377 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1JWSaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Oct 2011 14:30:30 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>
CC: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
Date: Mon, 24 Oct 2011 00:00:11 +0530
Subject: new mbus formats
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930328A9BD1E@dbde02.ent.ti.com>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
 <1309439597-15998-2-git-send-email-manjunath.hadli@ti.com>
 <20110713185050.GC27451@valkosipuli.localdomain>
 <B85A65D85D7EB246BE421B3FB0FBB593025729ADDF@dbde02.ent.ti.com>
 <20110831112323.GL12368@valkosipuli.localdomain>
In-Reply-To: <20110831112323.GL12368@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

 I need a few mbus formats to be defined loosely for following. Please tell me if anyone has already thought of taking care of them already.

These are supported for Texas Instruments DM365 and DM355 SoCs.

 
1. RGB 888 parallel:    

2. YUV420  color separate:

3. C plane 420: ( On the lines of Y plane:  V4L2_MBUS_FMT_Y8_1X8)

4. C plane 422

5. 10 bit bayer with ALAW compression.

If not, could you please suggest/discuss on the possible MBUS formats for the above?


Thanks and Regards,

-Manju
