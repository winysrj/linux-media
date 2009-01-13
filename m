Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46910 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbZAMCDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 21:03:31 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Mon, 12 Jan 2009 20:03:05 -0600
Subject: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor driver v2
Message-ID: <A24693684029E5489D1D202277BE894416429F96@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm sending the following patchset for review to the relevant lists (linux-omap, v4l, linux-media).

Includes:
 - Omap3 camera core + ISP drivers.
 - MT9P012 sensor driver (adapted to 3430SDP)
 - DW9710 lens driver (adapted to work with MT9P012 for SDP)
 - Necessary v4l2-int-device changes to make above drivers work
 - Redefine OMAP3 ISP platform device.
 - Review comments fixed from: (Thanks a lot for their time and help)
   - Hans Verkuil
   - Tony Lindgreen
   - Felipe Balbi
   - Vaibhav Hiremath
   - David Brownell

Some notes:
 - Uses v4l2-int-device solution.
 - Tested with 3430SDP ES3.0 VG5.0.1 with Camkit v3.0.1
 - Applies cleanly on top of commit 0ec95b96fd77036a13398c66901e11cd301190d0 by Jouni Hogander (OMAP3: PM: Emu_pwrdm is switched off by hardware even when sdti is in use)
 - ISP wrappers dropped from the patchset, as a rework is going on currently.


I appreciate in advance your time.

Regards,
Sergio
