Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:60689 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751927Ab2GZAtJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 20:49:09 -0400
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (SSL3.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1SuCIQ-0002iU-LU
	for linux-media@vger.kernel.org; Wed, 25 Jul 2012 17:51:18 -0700
Message-ID: <50109483.8030308@seiner.com>
Date: Wed, 25 Jul 2012 17:51:15 -0700
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx231xx interlace-like artifacts
References: <50108A15.8090005@seiner.com>
In-Reply-To: <50108A15.8090005@seiner.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner wrote:
> I just recently changed my vidcap to a Hauppage .  Now I get these 
> interlace-like artifacts:
>
> http://seiner.com/cz/rtpictures/2012_07_25T14h20m46sZ_0.451651_44.090619_-123.126059.jpg 
>
> http://seiner.com/cz/rtpictures/2012_07_25T14h22m48sZ_0.224624_44.089669_-123.139100.jpg 
>
>
> cxx231x.h has the following line:
>
> #define CX231XX_INTERLACED_DEFAULT      1
>
> Is there some way to turn off interlacing with a parameter?
>
>

OOPS! hit send too soon, it seems.  Here's the card info:

[  487.640000] cx231xx #0: New device Hauppauge Hauppauge Device @ 480 
Mbps (2040:c200) with 5 interfaces
[  487.650000] cx231xx #0: registering interface 1
[  487.650000] cx231xx #0: can't change interface 3 alt no. to 3: Max. 
Pkt size = 0
[  487.660000] cx231xx #0: can't change interface 4 alt no. to 1: Max. 
Pkt size = 0
[  487.670000] cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
[  487.790000] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[  487.800000] cx25840 0-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[  487.840000] cx25840 0-0044:  Firmware download size changed to 16 
bytes max length
[  489.940000] cx25840 0-0044: loaded v4l-cx231xx-avcore-01.fw firmware 
(16382 bytes)
[  489.990000] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.2
[  490.020000] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[  490.090000] cx231xx #0: video_mux : 0
[  490.090000] cx231xx #0: do_mode_ctrl_overrides : 0xb000
[  490.100000] cx231xx #0: do_mode_ctrl_overrides NTSC
[  490.110000] cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
[  490.120000] cx231xx #0: cx231xx #0/0: registered device vbi0
[  490.130000] cx231xx #0: V4L2 device registered as video0 and vbi0
[  490.130000] cx231xx #0: EndPoint Addr 0x8400, Alternate settings: 5
[  490.140000] cx231xx #0: Alternate setting 0, max size= 512
[  490.140000] cx231xx #0: Alternate setting 1, max size= 184
[  490.150000] cx231xx #0: Alternate setting 2, max size= 728
[  490.160000] cx231xx #0: Alternate setting 3, max size= 2892
[  490.160000] cx231xx #0: Alternate setting 4, max size= 1800
[  490.170000] cx231xx #0: EndPoint Addr 0x8500, Alternate settings: 2
[  490.170000] cx231xx #0: Alternate setting 0, max size= 512
[  490.180000] cx231xx #0: Alternate setting 1, max size= 512
[  490.180000] cx231xx #0: EndPoint Addr 0x8600, Alternate settings: 2
[  490.190000] cx231xx #0: Alternate setting 0, max size= 512
[  490.200000] cx231xx #0: Alternate setting 1, max size= 576


-- 
Help us raise money for my kids' swim team!

http://www.facebook.com/RiverRoadKids4Kids

