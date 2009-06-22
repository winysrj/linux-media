Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34891 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbZFVHbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 03:31:44 -0400
Received: by bwz9 with SMTP id 9so2916513bwz.37
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 00:31:46 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Jun 2009 10:31:46 +0300
Message-ID: <88b49f150906220031o75e69b20id5e6a282fb96e581@mail.gmail.com>
Subject: Kworld DVB-T 323UR problems
From: Laszlo Kustan <lkustan@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,
Sorry, it seems that sometimes my usb is not recognized as 2.0, I
wonder why this happens.
Anyway, I'll send you in the afternoon a correct dmesg output, but the
results are the same: same problems with analog routing and no remote.
After I installed your tvtime version (had to install the deb version
as the sources are not available on your site (internal server
error)), there were some problems with libswscale (the link had other
name than tvtime was looking for), I renamed the link and that's how I
ended up with the error message I already wrote:
Access type not available

Any idea how to get rid of this or any feasible solution for the analog audio?

Thanks, Laszlo


   please pay attention to that line... it probably will not work with usb 1.0.

   Markus
