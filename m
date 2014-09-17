Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56096 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbaIQRgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 13:36:42 -0400
Received: by mail-pd0-f182.google.com with SMTP id w10so2569658pde.27
        for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 10:36:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Sep 2014 23:06:42 +0530
Message-ID: <CAH9_wRM_wd_GkS=j-7pkYTFRg4U1oN=NO+Wfhp56vKturYb+cg@mail.gmail.com>
Subject: OMAP3 Multiple camera support
From: Sriram V <vshrirama@gmail.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Does OMAP3 camera driver support multiple cameras at the same time.

As i understand - You can have simultaneous YUV422 (Directly to memory)
and another one passing through camera controller ISP?

I Also, wanted to check if anyone has tried having multiple cameras on omap3
with the existing driver.

-- 
Regards,
Sriram
