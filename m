Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:63783 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZDUEIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 00:08:16 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2164311wff.4
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 21:08:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C01FCF206F5D8D4C89B210408D7DB39C29B6BA@mail2.oerlikon.ca>
References: <C01FCF206F5D8D4C89B210408D7DB39C29B6BA@mail2.oerlikon.ca>
Date: Tue, 21 Apr 2009 13:08:14 +0900
Message-ID: <5e9665e10904202108s2aa88e41t77b5ff211aa51312@mail.gmail.com>
Subject: Re: need help for omap3 isp-camera interface
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "Weng, Wending" <WWeng@rheinmetall.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

First of all you have to specify which version of camera interface
driver you are using.
Because, there are two versions of omap3 camera interface.
First one is from TI, and second one is from Sakari Ailus. (second one
is the latest)
Besides the version issue, there are some point that you can check.

1. make sure that you are using parallel mode (if you are not using MIPI)
2. check your dataline shift
3. check your H/W connection and check parallel bridge setting

And in case of you are using Sakari's new driver, you can check for
the wait_hs_vs in isp_interface_config.

Cheers,

Nate



On Tue, Apr 21, 2009 at 12:01 PM, Weng, Wending <WWeng@rheinmetall.ca> wrote:
> Hi All,
>
>   I'm working on video image capture(omap3 isp) interface(PSP 1.0.2), and have met many difficulties. At the camera side, the 8 bits BT656 signal are connected to cam_d[0-7], which looks OK. The cam_fld, cam_hs and cam_vs are also connected, At the omap3 side, I use saMmapLoopback.c, it runs, however, it receives only HS_VS_IRQ, but no any image data. I checked FLDSTAT(CCDC_SYN_MODE), it's never changed.
> Right now, I don't know what to check, if you can give some suggestions, your help will be greatly appreciated. Thanks in advance.
>
> Wending Weng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
