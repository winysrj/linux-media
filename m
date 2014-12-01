Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:55547 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbaLAMxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 07:53:54 -0500
Received: by mail-qg0-f43.google.com with SMTP id q108so7368700qgd.2
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 04:53:54 -0800 (PST)
Date: Mon, 1 Dec 2014 12:53:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>,
	SangYoung Son <hello.son@smasung.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v8 09/14] mfd: max77693: adjust
 max77693_led_platform_data
Message-ID: <20141201125347.GC12068@x1>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-10-git-send-email-j.anaszewski@samsung.com>
 <20141201113430.GC15845@x1>
 <547C63F4.4060203@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547C63F4.4060203@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 01 Dec 2014, Jacek Anaszewski wrote:
> On 12/01/2014 12:34 PM, Lee Jones wrote:
> >On Fri, 28 Nov 2014, Jacek Anaszewski wrote:
> >
> >I'm guessing this will effect the other patches in the set?
> >
> 
> max77692 flash driver depends on it and it has to be
> in synch with the related DT bindings patch.

Very well.  Providing you address the commitlog issues:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
