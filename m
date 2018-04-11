Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmx012.vodafonemail.xion.oxcs.net ([153.92.174.90]:61755 "EHLO
        vsmx012.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756345AbeDKUAn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 16:00:43 -0400
Received: from vsmx004.vodafonemail.xion.oxcs.net (unknown [192.168.75.198])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTP id 8E5618CE1AA
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 19:51:05 +0000 (UTC)
Received: from [192.168.0.1] (unknown [91.10.43.10])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 69385CDF82
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 19:51:03 +0000 (UTC)
To: linux-media@vger.kernel.org
From: Ochi <ochi@arcor.de>
Subject: Emulated formats do not allow to use highest FPS of some cameras
Message-ID: <920ff2ce-4c2b-4e76-4ff4-865b73be2003@arcor.de>
Date: Wed, 11 Apr 2018 21:51:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm using a Logitech Brio webcam which is able to capture video at 60+ 
FPS when using MJPEG input format at e.g. 1280x720 pixels, but only up 
to 30 FPS when using other formats such as YUYV.

When using the cam with OBS Studio, the MJPEG input format is not 
currently supported by OBS so that I tried to choose one of the emulated 
formats. However, when using e.g. emulated YU12 or YV12 input formats, I 
can only choose up to 30 FPS.

I think that the reason for this is that the automatic ranking of 
available input formats by the function "v4lconvert_get_rank" in 
"libv4lconvert.c" uses a heuristic to rank formats which disregards 
characteristics of a format such as the maximum available FPS. Indeed, 
if I lower the rank (in this case lower == better) manually for MJPEG in 
said function, I can choose 60 or even 90 FPS in OBS when using one of 
the emulated formats.

Do you think a change of the heuristic used in "v4lconvert_get_rank" 
would be in order here, or do you have any other advice?

Best Regards
Sebastian
