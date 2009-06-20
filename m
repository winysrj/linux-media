Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f195.google.com ([209.85.222.195]:42051 "EHLO
	mail-pz0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZFTJFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 05:05:11 -0400
Received: by pzk33 with SMTP id 33so209719pzk.33
        for <linux-media@vger.kernel.org>; Sat, 20 Jun 2009 02:05:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3A7AE2.9080303@maxwell.research.nokia.com>
References: <4A3A7AE2.9080303@maxwell.research.nokia.com>
Date: Sat, 20 Jun 2009 18:05:13 +0900
Message-ID: <5e9665e10906200205ga45073eue92b73abba79e41c@mail.gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update 2)
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"ext Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>, gary@mlbassoc.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

2009/6/19 Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>:
> Hi,
>
> I've again updated the patchset in Gitorious after a long break. It's
> here. The base is fairly recent linux-omap (May) but I wouldn't expect
> problems in rebasing on top of newer updates either.
>
> <URL:http://www.gitorious.org/projects/omap3camera>
>
> The amount of changes is more or less huge but I'll try to summarise
> them. The base branch is no longer needed, the patch has been integrated
> to linux-omap. The v4l2_subdev transition hasn't begun yet, however.
>
> - Many ISP subdrivers have been rewritten or refactored. The new code
> should be easier to understand.
>
> - VIDIOC_TRY_FMT has no longer have side effects except perhaps to the
> resizer. This is being worked on.
>
> - Crop has been mostly rewritten.
>
> - Locking has been corrected, although probably not definitely fixed.
>
> - A separate ispstat module for handling the H3A, AF and HIST statistics.
> H3A and AF are using it already.
>
> - Lots of redundant code has been removed.
>
> - Most busy-locked register are should be no longer updated when
> corresponding modules are busy. There are still some cases this is
> happening, though.
>
> - Configuration of the modules in the interrupt handler is done so that the
> module is disabled first or used in oneshot mode.
>
> - Lots of things I can't remember now. The individual changes can be seen in
> the omap3isp and omap34xxcam branches. The branches just contain the patches
> in order so git diff doesn't help, unfortunately.
>
> I won't be available for questions for a month or so (holidays). In the
> meantime you can contact Tuukka Toivonen, David Cohen and Sergio Aguirre for
> questions.
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>
>
>

By the way, it's quite tough doing a code review without a patch
in-lined with e-mail.
Anyway, I took a quick look at the gitorious repository and found
something strange.
Following patch.
http://www.gitorious.org/omap3camera/mainline/commit/d92c96406296310a977b00f45b209523929b15b5
What happens to the capability when the int device is dummy? (does it
mean that there is no int device?)

And the most thing that makes me cautious to review the patch is all
about v4l2 subdev thing. Because most device drivers in V4L2
repository already got started moving to subdev framework.

And one more thing. If I want to test how the "ISP" driver is working,
is there any target board that I can buy also a sensor device already
attached on it? If anybody knows that, please let me know.
Cheers,

Nate




-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
