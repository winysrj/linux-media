Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:54456 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbeALAQG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 19:16:06 -0500
Received: from [77.181.168.144] (helo=[192.168.1.189])
        by mail.kernelconcepts.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <florian.boor@kernelconcepts.de>)
        id 1eZn0t-0007xe-N5
        for linux-media@vger.kernel.org; Fri, 12 Jan 2018 01:16:03 +0100
From: Florian Boor <florian.boor@kernelconcepts.de>
Subject: MT9M131 on I.MX6DL CSI color issue
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
Date: Fri, 12 Jan 2018 01:16:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have a Phytec VM-009 camera based on MT9M131 connected to CSI0 of a I.MX6DL
based board running mainline 4.13.0 + custom devicetree. Its using the parallel
interface, 8 bit bus width on pins 12 to 19.

Basically it works pretty well apart from the really strange colors. I guess its
some YUV vs. RGB issue or similar. Here [1] is an example generated with the
following command.

gst-launch v4l2src device=/dev/video4 num-buffers=1 ! jpegenc ! filesink
location=capture1.jpeg

Apart from the colors everything is fine.
I'm pretty sure I have not seen such an effect before - what might be wrong here?

The current setup looks like this:

IF=UYVY2X8
GEOM="1280x1024"
media-ctl -l "'mt9m111 2-0048':0 -> 'ipu1_csi0_mux':4[1]"
media-ctl -l "'ipu1_csi0_mux':5 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"

media-ctl -d /dev/media0 -v -V "'ipu1_csi0':2 [fmt:${IF}/${GEOM} field:none]"
media-ctl -d /dev/media0 -v -V "'ipu1_csi0 capture':0 [fmt:${IF}/${GEOM}
field:none]"
media-ctl -d /dev/media0 -v -V "'ipu1_csi0_mux':4 [fmt:${IF}/${GEOM} field: none]"
media-ctl -d /dev/media0 -v -V "'ipu1_csi0_mux':5 [fmt:${IF}/${GEOM} field: none]"
media-ctl -d /dev/media0 -v -V "'mt9m111 2-0048':0 [fmt:${IF}/${GEOM} field: none]"


Greetings

Florian

[1] http://www.kernelconcepts.de/~florian/capture1.jpeg

-- 
The dream of yesterday                  Florian Boor
is the hope of today                    Tel: +49 271-771091-15
and the reality of tomorrow.		Fax: +49 271-338857-29
[Robert Hutchings Goddard, 1904]        florian.boor@kernelconcepts.de
                                        http://www.kernelconcepts.de/en

kernel concepts GmbH
Hauptstraße 16
D-57074 Siegen
Geschäftsführer: Ole Reinhardt
HR Siegen, HR B 9613
