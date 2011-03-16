Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1CPKBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 06:01:54 -0400
Received: by iwn34 with SMTP id 34so1490291iwn.19
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 03:01:53 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Mar 2011 11:01:53 +0100
Message-ID: <AANLkTimB5br6fydkHnE9sYwhpPh0u56Swn-qKHN0s_J4@mail.gmail.com>
Subject: Where to find 8-bit sbggr patch for omap3-isp
From: Bastian Hecht <hechtb@googlemail.com>
To: Michael Jones <michael.jones@matrix-vision.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello dear omap-isp developers,

I'm working with a  OV5642 sensor with an 8-bit parallel bus.

I'm referring to this patch:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/29876/match=sgrbg8

Michael, you say that the patch applies to media-0005-omap3isp from Laurent.
I cannot see it in the repo:
http://git.linuxtv.org/pinchartl/media.git?a=blob;f=drivers/media/video/omap3-isp/ispccdc.c;h=5ff9d14ce71099cc672e71e2bd1d7ca619bbcc98;hb=media-0005-omap3isp

Hasn't the patch been merged into your tree yet, Laurent?
Or am I looking at the wrong spot?

Thanks for help,

 Bastian Hecht
