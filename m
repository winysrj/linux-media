Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:47934 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZAMCWd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 21:22:33 -0500
Subject: Re: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor
	driver v2
From: "stanley.miao" <stanley.miao@windriver.com>
Reply-To: stanley.miao@windriver.com
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <A24693684029E5489D1D202277BE894416429F96@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894416429F96@dlee02.ent.ti.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 10:30:43 +0800
Message-Id: <1231813843.29324.2.camel@localhost>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,Sergio,

I saw you had a ov3640 patch in omapzoom tree. Why don't you submit it
together ?

Stanley.

On Mon, 2009-01-12 at 20:03 -0600, Aguirre Rodriguez, Sergio Alberto
wrote:
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
> 
> Some notes:
>  - Uses v4l2-int-device solution.
>  - Tested with 3430SDP ES3.0 VG5.0.1 with Camkit v3.0.1
>  - Applies cleanly on top of commit 0ec95b96fd77036a13398c66901e11cd301190d0 by Jouni Hogander (OMAP3: PM: Emu_pwrdm is switched off by hardware even when sdti is in use)
>  - ISP wrappers dropped from the patchset, as a rework is going on currently.
> 
> 
> I appreciate in advance your time.
> 
> Regards,
> Sergio
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
