Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:33371 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZHBRsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 13:48:36 -0400
Received: by fxm17 with SMTP id 17so2276782fxm.37
        for <linux-media@vger.kernel.org>; Sun, 02 Aug 2009 10:48:36 -0700 (PDT)
Date: Sun, 2 Aug 2009 20:48:36 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Subject: correct implementation of FE_READ_UNCORRECTED_BLOCKS
Message-ID: <20090802174836.GA19034@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB API documentation says:
"This ioctl call returns the number of uncorrected blocks detected by the device driver during its lifetime.... Note that the counter will wrap to zero after its maximum count has been reached.
