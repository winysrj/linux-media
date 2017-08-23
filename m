Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57722 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753760AbdHWLZD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 07:25:03 -0400
Received: from [10.10.0.58] ([213.191.34.238]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M6Df8-1dMvLz3OyA-00y89L for
 <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 13:25:01 +0200
To: linux-media@vger.kernel.org
From: Stephan Bauroth <stephanbauroth@web.de>
Subject: Support for direct playback of camera input on imx6q
Message-ID: <13b9d535-094d-c63b-54f9-3ea54e2b138e@web.de>
Date: Wed, 23 Aug 2017 13:25:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear List,

I'm trying to directly output a captured video signal to an LVDS panel 
on an imx6q. Capturing frames works fine using the staging imx-media 
driver. I can grab JPGs using v4l2grab and I can stream the input to the 
display with gstreamer. However, when streaming, one of the cores is 
utilized by ~66%, and I have to use the videoconvert module of gstreamer.

The IPU in imx6 can directly stream an captured signal back to the 
display processor (DP) according to [1]. While the capturing paths 
within the IPU are managed by the staging media-imx driver, its output 
paths are not, so I can not simply set up links using media-ctl.

So, my question is whether it is possible to hook up the captured signal 
to the DP using either the ipuv3 driver or the frame buffer driver 
(mxcfb) or something else, and if yes, how?

Thanks for any help and/or hints
Stephan

[1] http://www.nxp.com/docs/en/reference-manual/IMX6DQRM.pdf, pg. 2732 
or chapter 37.1.2.1.4.1, 'Camera Preview'
