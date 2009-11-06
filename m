Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54491 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758974AbZKFPZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 10:25:10 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
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
Date: Fri, 6 Nov 2009 09:25:01 -0600
Subject: RE: OMAP 3 ISP and N900 sensor driver update
Message-ID: <A69FA2915331DC488A831521EAE36FE401558AB44B@dlee06.ent.ti.com>
References: <4AF41BDE.4040908@maxwell.research.nokia.com>
In-Reply-To: <4AF41BDE.4040908@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,

Thanks for the update...

Who is working on the CCDC driver for OMAP35xx? After a week or so,
I need to start migrating the CCDC driver to sub device interface so that application can directly configure the parameters with out having to
go through video node. Ultimately it is expected that ccdc will have a
device node that will allow application to open the device and configure
the parameters (in the context of Media controller). But to begin with
I intend to port the existing CCDC driver for DM6446 and DM355 to
sub device interface. Since the VPFE IPs are common across DM6446 &
OMAP 35xx, we could use a common sub device across both platforms.

So I this context, could you please update me on the CCDC development
on OMAP platform that you work?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Sakari Ailus
>Sent: Friday, November 06, 2009 7:52 AM
>To: linux-media@vger.kernel.org
>Cc: Laurent Pinchart; Hans Verkuil; Cohen David Abraham; Koskipää Antti
>Jussi Petteri; Toivonen Tuukka Olli Artturi; Zutshi Vimarsh (Nokia-D-
>MSW/Helsinki); talvala@stanford.edu; Aguirre, Sergio; Ivan Ivanov; Stan
>Varbanov; Valeri Ivanov; Atanas Filipov
>Subject: OMAP 3 ISP and N900 sensor driver update
>
>Hi,
>
>I have updated the OMAP 3 ISP driver in Gitorious:
>
><URL:http://www.gitorious.org/omap3camera>
>
>Major changes since the last update:
>
>- The Nokia N900 (aka rx-51) sensor drivers are available (will be
>posted to the list shortly)
>- Say goodbye to v4l2-int-device, welcome the v4l2_subdevice interface
>(thanks to Laurent Pinchart)
>- Miscellaneous stability fixes and cleanups
>- H3A rework (by David Cohen)
>- Resizer rework (by Antti Koskipää)
>
>The next task is then the moving to Media controller, I guess.
>
>Cheers,
>
>--
>Sakari Ailus
>sakari.ailus@maxwell.research.nokia.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

