Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60801 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750748AbcJ0GQf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 02:16:35 -0400
Received: from axis700.grange ([81.173.165.248]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MaF8e-1cJVFn3fiK-00JpVO for
 <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 08:16:31 +0200
Received: from localhost (localhost [127.0.0.1])
        by axis700.grange (Postfix) with ESMTP id 1B94F8B110
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 08:16:30 +0200 (CEST)
Date: Thu, 27 Oct 2016 08:16:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: YUV444 contradicting wikipedia
Message-ID: <Pine.LNX.4.64.1610270806540.21294@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks like the Linux definition of the (packed) YUV444 format contradicts 
wikipedia. According to 
https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-packed-yuv.html 
The Linux V4L2_PIX_FMT_YUV444 format takes 16 bits per pixel, whereas the 
wikipedia 
https://en.wikipedia.org/wiki/YUV#Converting_between_Y.E2.80.B2UV_and_RGB 
says it's 24 bits per pixel. I understand that the wikipedia doesn't have 
an absolute authority, but I also saw other sources using the same 
definition. So, looks like some confusion is possible.

Thanks
Guennadi
