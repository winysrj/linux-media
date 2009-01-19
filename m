Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35362 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbZASKUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 05:20:38 -0500
Message-ID: <497453DC.6020102@nokia.com>
Date: Mon, 19 Jan 2009 12:20:12 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor driver
 v2
References: <A24693684029E5489D1D202277BE894416429F96@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894416429F96@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre Rodriguez, Sergio Alberto wrote:
> Hi,
> 
> I'm sending the following patchset for review to the relevant lists (linux-omap, v4l, linux-media).
> 
> Includes:
>  - Omap3 camera core + ISP drivers.
>  - MT9P012 sensor driver (adapted to 3430SDP)
>  - DW9710 lens driver (adapted to work with MT9P012 for SDP)
>  - Necessary v4l2-int-device changes to make above drivers work
>  - Redefine OMAP3 ISP platform device.
>  - Review comments fixed from: (Thanks a lot for their time and help)
>    - Hans Verkuil
>    - Tony Lindgreen
>    - Felipe Balbi
>    - Vaibhav Hiremath
>    - David Brownell

Hi Sergio,

We should try to figure out how we could synchronise our version of the 
ISP and camera ASAP before making any more changes... I wouldn't want to 
start posting a competing version. ;-)

-- 
Sakari Ailus
sakari.ailus@nokia.com
