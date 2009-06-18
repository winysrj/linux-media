Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:29935 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZFRRgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 13:36:11 -0400
Message-ID: <4A3A7AE2.9080303@maxwell.research.nokia.com>
Date: Thu, 18 Jun 2009 20:35:30 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	DongSoo Kim <dongsoo.kim@gmail.com>,
	"ext Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>, gary@mlbassoc.com
Subject: OMAP3 ISP and camera drivers (update 2)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've again updated the patchset in Gitorious after a long break. It's
here. The base is fairly recent linux-omap (May) but I wouldn't expect
problems in rebasing on top of newer updates either.

<URL:http://www.gitorious.org/projects/omap3camera>

The amount of changes is more or less huge but I'll try to summarise
them. The base branch is no longer needed, the patch has been integrated
to linux-omap. The v4l2_subdev transition hasn't begun yet, however.

- Many ISP subdrivers have been rewritten or refactored. The new code
should be easier to understand.

- VIDIOC_TRY_FMT has no longer have side effects except perhaps to the
resizer. This is being worked on.

- Crop has been mostly rewritten.

- Locking has been corrected, although probably not definitely fixed.

- A separate ispstat module for handling the H3A, AF and HIST 
statistics. H3A and AF are using it already.

- Lots of redundant code has been removed.

- Most busy-locked register are should be no longer updated when 
corresponding modules are busy. There are still some cases this is 
happening, though.

- Configuration of the modules in the interrupt handler is done so that 
the module is disabled first or used in oneshot mode.

- Lots of things I can't remember now. The individual changes can be 
seen in the omap3isp and omap34xxcam branches. The branches just contain 
the patches in order so git diff doesn't help, unfortunately.

I won't be available for questions for a month or so (holidays). In the 
meantime you can contact Tuukka Toivonen, David Cohen and Sergio Aguirre 
for questions.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com


