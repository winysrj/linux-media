Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45612 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1CAK0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 05:26:35 -0500
Received: by fxm17 with SMTP id 17so4641912fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2011 02:26:34 -0800 (PST)
Subject: RE: [st-ericsson] v4l2 vs omx for camera
From: Edward Hervey <bilboed@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Nicolas Pitre' <nicolas.pitre@linaro.org>,
	'Kyungmin Park' <kmpark@infradead.org>,
	'Linus Walleij' <linus.walleij@linaro.org>,
	linaro-dev@lists.linaro.org,
	'Harald Gustafsson' <harald.gustafsson@ericsson.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Discussion of the development of and with GStreamer'
	<gstreamer-devel@lists.freedesktop.org>,
	johan.mossberg.lml@gmail.com,
	'ST-Ericsson LT Mailing List' <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
In-Reply-To: <002b01cbd724$8e528bc0$aaf7a340$%szyprowski@samsung.com>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	 <AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	 <201102100847.15212.hverkuil@xs4all.nl>
	 <201102171448.09063.laurent.pinchart@ideasonboard.com>
	 <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	 <1298578789.821.54.camel@deumeu>
	 <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
	 <AANLkTini7xuQ2kcrWbfGSUomdoPkLLJiik2soer8SL+X@mail.gmail.com>
	 <alpine.LFD.2.00.1102261408010.22034@xanadu.home>
	 <002b01cbd724$8e528bc0$aaf7a340$%szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 11:25:45 +0100
Message-ID: <1298975145.24906.60.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-02-28 at 09:50 +0100, Marek Szyprowski wrote:
> Hello,
[...]
> 
> I'm not sure that highmem is the right solution. First, this will force
> systems with rather small amount of memory (like 256M) to use highmem just
> to support DMA allocable memory. It also doesn't solve the issue with
> specific memory requirement for our DMA hardware (multimedia codec needs
> video memory buffers from 2 physical banks).

  Could you explain why a codec would require memory buffers from 2
physical banks ?

  Thanks,

   Edward

> 
> The relocation issue has been already addressed in the last CMA patch series.
> Michal managed to create a framework that allowed to relocate on demand any
> pages from the CMA area.
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 


