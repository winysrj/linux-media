Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49705 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2HBMtA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 08:49:00 -0400
Received: by eeil10 with SMTP id l10so2367052eei.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 05:48:59 -0700 (PDT)
Message-ID: <1343911731.4113.5.camel@edge>
Subject: s5p-fimc capturing interlaced BT656
From: Mike Dyer <mike.dyer@md-soft.co.uk>
To: linux-media@vger.kernel.org
Date: Thu, 02 Aug 2012 13:48:51 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm using the S5PV210 camera IF and capturing BT656 video from a TVP5150
video decoder.

I notice that the capture driver ignores the field interlace flags
reported by the 'sensor' and always uses 'V4L2_FIELD_NONE'.  It also
seems each field ends up in it's own frame, using only half the height.

What would need to be done to store both fields in a single frame, for
example in a V4L2_FIELD_INTERLACE_TB/BT format? 

Cheers,
Mike

