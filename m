Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:55547 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbeKWGE1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 01:04:27 -0500
Received: from Asus-A6VM ([87.164.84.243]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N18MG-1fSDGm0xre-012a7T for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018
 20:23:42 +0100
Date: Thu, 22 Nov 2018 20:23:41 +0100
From: Andreas Pape <ap@ca-pape.de>
To: linux-media@vger.kernel.org
Subject: Bug in stkwebcam?
Message-Id: <20181122202341.bddc151d82ce2cb7bb29a61b@ca-pape.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently updated my old 2006 Asus A6VM notebook with the latest 32bit
Ubuntu 18.04 LTS (kernel 4.15.0) and found out that the driver for the
webcam (Syntek USB2.0, USB ID 174f:a311) was not working. I only got error
messages like "Sensor resetting failed" in dmesg when starting guvcview
for example.

Far from being an expert for video devices, I tried to debug this and
figured out three patches to make the webcam work again on my old notebook
(at least I get a video again ;-).

I know the type of notebook and webcam is pretty old and the driver seems
not to be actively maintained anymore although still being part of actual
kernel versions.

Is there still an interest in getting patches for such an old device? If
yes, I could try to rebase my patches to the actual version of media_tree.git
and post them to the mailing list.

Kind regards,
Andreas
