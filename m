Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56214 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753170Ab2LKOs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 09:48:28 -0500
Message-ID: <50C747B7.20107@gmx.net>
Date: Tue, 11 Dec 2012 15:48:23 +0100
From: Andreas Nagel <andreasnagel@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: How to configure resizer in ISP pipeline?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

using Media Controller API, I can successfully configure a simple ISP 
pipeline on an OMAP3530 and capture video data. Now I want to include 
the resizer. So the pipeline would look like this (where MEM would be 
the devnode corresponding to "resizer output"):

Sensor --> CCDC --> Resizer --> MEM

My "sensor" (TVP5146) already provides YUV data, so I can skip the 
previewer. I tried setting the input and output pad of the resizer 
subdevice to incoming resolution (input pad) and desired resolution 
(output pad). For example: 720x576 --> 352x288. But it didn't work out 
quite well.

Can someone explain how one properly configures the resizer in an ISP 
pipeline (with Media Controller API) ? I spend some hours researching, 
but this topic seems to be a well guarded secret...

Kind regards,
Andreas
