Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43897 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1HIJwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 05:52:10 -0400
Received: by qyk34 with SMTP id 34so2208037qyk.19
        for <linux-media@vger.kernel.org>; Tue, 09 Aug 2011 02:52:09 -0700 (PDT)
Message-ID: <4E410342.3010502@gmail.com>
Date: Tue, 09 Aug 2011 15:22:02 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <201108081750.07000.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108081750.07000.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I have a point with the pixel clock. During discussion we found that 
pixel clock get/set is required for user space to do fine control over 
the frame-rate etc. What if the user sets the pixel array clock which is 
above the system/if bus clock? Suppose we are setting the pixel clock 
(which user space sets) to higher rate at sensor array, but for some 
reason the bus cannot handle that rate (either low speed or loaded) or 
lower PCLK at say CSI2 interface is being set. Are we not going to loose 
data due to this? Also, there would be data validation overhead in 
driver on what is acceptable PCLK values for a particular sensor on an 
interface etc.

I am still not favoring user space controlling this, and wish driver 
decides this for a given frame-rate requested by the user space :)

Frame-rate   resolution  HSYNC  VSYNC  PCLK(array)  PCLK (i/f bus) ...

Let user space control only first two, and driver decide rest (PCLK can 
be different at different ISP h/w units though)

Regards,
Subash

 > Pixel clock and blanking
 > ------------------------
 >
 >   Preliminary conclusions:
 >
 >   - Pixel clock(s) and blanking will be exported through controls on 
subdev
 >     nodes.
 >   - The pixel array pixel clock is needed by userspace.
 >   - Hosts/bridges/ISPs need pixel clock and blanking information to 
validate
 >     pipelines.
 >
 >   Actions:
 >
 >   - CSI2 and CCP2 bus frequencies will be selectable use integer menu 
controls.
 >     (Sakari)
 >   - Add an integer menu control type, replacing the name with a 
64-bit integer.
 >     (Sakari, Hans)
 >   - Research which pixel clock(s) to expose based on the SMIA sensor.
 >     (Sakari)
 >   - Add two new internal subdev pad operations to get and set clocks and
 >     blanking.
 >     (Laurent, Sakari)
