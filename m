Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:53096 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934711AbdACNGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 08:06:25 -0500
Date: Tue, 3 Jan 2017 13:57:45 +0100 (CET)
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org
cc: modin@yuri.at, benjamin.tissoires@redhat.com,
        hans.verkuil@cisco.com
Subject: [RFC] [sur40] mapping of sensor parameters to V4L2?
Message-ID: <alpine.DEB.2.10.1701031346040.18874@butterbrot>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

next chapter in the neverending story of reverse-engineering the SUR40:

I've identified a couple of internal LCD panel registers which control 
some aspects of the built-in image sensor. In particular, these are called 
"Video Voltage", "Video Bias", and "IR Illumination Level".

Now, I have two questions:

- Video Voltage & Bias seem to affect the sensor gain. Does anyone with 
extensive background knowledge of image sensors want to venture a guess 
what the exact relation is? My own interpretation would be that Video 
Voltage is the actual amplifier gain and Video Bias is the black level...

- Is there a sensible mapping of these values to V4L2 controls? Should I 
pick something from the USER class, or from CAMERA, or FLASH, or ...

Thanks & best regards, Florian
-- 
"_Nothing_ brightens up my morning. Coffee simply provides a shade of
grey just above the pitch-black of the infinite depths of the _abyss_."
