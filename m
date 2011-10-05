Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56564 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378Ab1JEUE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 16:04:56 -0400
Received: by gyg10 with SMTP id 10so1923350gyg.19
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 13:04:56 -0700 (PDT)
MIME-Version: 1.0
From: Evan Platt <evplatt@gmail.com>
Date: Wed, 5 Oct 2011 15:04:34 -0500
Message-ID: <CABHmaNMw8OUoSZ8XsWA_QQz5H9h6+3aVTVMcW30VzOCGTx7=gw@mail.gmail.com>
Subject: Media_build Issue with altera on cx23885
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L-DVB was previously working correctly for me.  I was experiencing
some problems which had been solved before by recompiling v4l.  So I
cloned the latest media_build tree and ran the build process.

Afterward, the driver does not load correctly and dmesg shows an error
(cx23885: Unknown symbol altera_init (err 0)).  I know there was a
change to move altera from staging to misc but I see that the changes
were propogated to media_build on 9/26/11.

I ran menuconfig and made sure that MISC_DEVICES was set to 'y' to
include altera-stapl but to no avail.

Please advise.

Some relevant information:

Device:  Hauppauge HVR-1250 Tuner
Driver:  cx23885
Environment: Ubuntu 11.04, 2.6.38-11-generic

Thanks!
