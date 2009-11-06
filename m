Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49038 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759229AbZKFMvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 07:51:47 -0500
Message-ID: <4AF41BDE.4040908@maxwell.research.nokia.com>
Date: Fri, 06 Nov 2009 14:51:42 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4?=
	 =?ISO-8859-1?Q?_Antti_Jussi_Petteri?= <antti.koskipaa@nokia.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	talvala@stanford.edu,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Stan Varbanov <svarbanov@mm-sol.com>,
	Valeri Ivanov <vivanov@mm-sol.com>,
	Atanas Filipov <afilipov@mm-sol.com>
Subject: OMAP 3 ISP and N900 sensor driver update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have updated the OMAP 3 ISP driver in Gitorious:

<URL:http://www.gitorious.org/omap3camera>

Major changes since the last update:

- The Nokia N900 (aka rx-51) sensor drivers are available (will be 
posted to the list shortly)
- Say goodbye to v4l2-int-device, welcome the v4l2_subdevice interface 
(thanks to Laurent Pinchart)
- Miscellaneous stability fixes and cleanups
- H3A rework (by David Cohen)
- Resizer rework (by Antti Koskip‰‰)

The next task is then the moving to Media controller, I guess.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
