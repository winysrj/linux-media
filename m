Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:40736 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbZKHUck (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 15:32:40 -0500
Message-ID: <4AF72ACA.1020206@maxwell.research.nokia.com>
Date: Sun, 08 Nov 2009 22:32:10 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	"talvala@stanford.edu" <talvala@stanford.edu>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Stan Varbanov <svarbanov@mm-sol.com>,
	Valeri Ivanov <vivanov@mm-sol.com>,
	Atanas Filipov <afilipov@mm-sol.com>
Subject: Re: OMAP 3 ISP and N900 sensor driver update
References: <4AF41BDE.4040908@maxwell.research.nokia.com> <A24693684029E5489D1D202277BE89444D5CDB42@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89444D5CDB42@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> Sakari, 

Hi, Sergio!

>> - The Nokia N900 (aka rx-51) sensor drivers are available (will be 
>> posted to the list shortly)
>> - Say goodbye to v4l2-int-device, welcome the v4l2_subdevice 
>> interface 
>> (thanks to Laurent Pinchart)
>> - Miscellaneous stability fixes and cleanups
>> - H3A rework (by David Cohen)
>> - Resizer rework (by Antti Koskipää)
> 
> Does the v4l2_subdevice conversion had some functional regressions?
> 
> Or everything is in place still?

I'd guess more or less so. I'm not aware of any regressions at least. :)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
