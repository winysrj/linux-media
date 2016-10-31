Return-path: <linux-media-owner@vger.kernel.org>
Received: from in.ti-gw.moria.de ([217.197.85.202]:52002 "EHLO mail.moria.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934946AbcJaKre (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 06:47:34 -0400
Received: from fangorn.moria.de ([2001:67c:1407:e1::2]:33170)
        by mail.moria.de with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.87 #2)
        id 1c1A7m-0000jB-U5
        for linux-media@vger.kernel.org; Mon, 31 Oct 2016 11:47:31 +0100
Received: from michael by fangorn.moria.de with local (ID michael) (Exim 4.87 #2)
        id 1c1A7l-0001cS-8r
        for linux-media@vger.kernel.org; Mon, 31 Oct 2016 11:47:29 +0100
Date: Mon, 31 Oct 2016 11:47:29 +0100
To: linux-media@vger.kernel.org
Subject: Lower exposure times than 100 us?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1c1A7l-0001cS-8r@fangorn.moria.de>
From: Michael Haardt <michael@moria.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

V4L2_CID_EXPOSURE_ABSOLUTE uses a 100 us resolution.  Quite a few
sensors offer lower exposures and more fine resolutions than that.
Can the resolution be switched to e.g. 1 us, similar to how the tuner
frequency may be specified in smaller steps if the driver implements
the V4L2_TUNER_CAP_* values?

Regards,

Michael
