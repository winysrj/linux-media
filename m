Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59249 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbZKFOdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 09:33:19 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?iso-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	"talvala@stanford.edu" <talvala@stanford.edu>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Stan Varbanov <svarbanov@mm-sol.com>,
	Valeri Ivanov <vivanov@mm-sol.com>,
	Atanas Filipov <afilipov@mm-sol.com>
Date: Fri, 6 Nov 2009 20:03:03 +0530
Subject: RE: OMAP 3 ISP and N900 sensor driver update
Message-ID: <19F8576C6E063C45BE387C64729E73940436F93CE2@dbde02.ent.ti.com>
References: <4AF41BDE.4040908@maxwell.research.nokia.com>
In-Reply-To: <4AF41BDE.4040908@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Friday, November 06, 2009 6:22 PM
> To: linux-media@vger.kernel.org
> Cc: Laurent Pinchart; Hans Verkuil; Cohen David Abraham; Koskipää
> Antti Jussi Petteri; Toivonen Tuukka Olli Artturi; Zutshi Vimarsh
> (Nokia-D-MSW/Helsinki); talvala@stanford.edu; Aguirre, Sergio; Ivan
> Ivanov; Stan Varbanov; Valeri Ivanov; Atanas Filipov
> Subject: OMAP 3 ISP and N900 sensor driver update
> 
> Hi,
> 
> I have updated the OMAP 3 ISP driver in Gitorious:
> 
> <URL:http://www.gitorious.org/omap3camera>
> 
> Major changes since the last update:
> 
> - The Nokia N900 (aka rx-51) sensor drivers are available (will be
> posted to the list shortly)
> - Say goodbye to v4l2-int-device, welcome the v4l2_subdevice
> interface
> (thanks to Laurent Pinchart)
[Hiremath, Vaibhav] Thanks Sakari and Laurent, this will definitely unblock me.

Thanks,
Vaibhav

> - Miscellaneous stability fixes and cleanups
> - H3A rework (by David Cohen)
> - Resizer rework (by Antti Koskipää)
> 
> The next task is then the moving to Media controller, I guess.
> 
> Cheers,
> 
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

