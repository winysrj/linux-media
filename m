Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41394 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZCFPcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 10:32:18 -0500
Message-ID: <49B141F6.6040301@maxwell.research.nokia.com>
Date: Fri, 06 Mar 2009 17:32:06 +0200
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
	Alexey Klimov <klimov.linux@gmail.com>
Subject: OMAP3 ISP and camera drivers (update)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've updated the patchset in Gitorious.

<URL:http://www.gitorious.org/projects/omap3camera>

Changes include

- Power management support. ISP suspend/resume should work now.

- Reindented and cleaned up everything. There are still some warnings 
from checkpatch.pl from the CSI2 code.

- Fix for crash in device registration, posted to list already. (Thanks, 
Vaibhav, Alexey!)

- LSC errors should be handled properly now.

I won't post the modified patches to the list this time since I guess it 
wouldn't be much of use, I guess. Or does someone want that? :)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
