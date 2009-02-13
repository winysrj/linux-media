Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:32157 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZBMKCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 05:02:40 -0500
Message-ID: <49954532.2070502@maxwell.research.nokia.com>
Date: Fri, 13 Feb 2009 12:02:26 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: DongSoo Kim <dongsoo.kim@gmail.com>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?UTF-8?B?7ZiV7KSA?= =?UTF-8?B?IOq5gA==?=
	<riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
References: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>	 <5e9665e10902102000i3433beb8jab7a70e7ac9b57e3@mail.gmail.com>	 <4993CB1F.603@maxwell.research.nokia.com> <5e9665e10902112352i57177f20r9022a7cb8a66fa0@mail.gmail.com>
In-Reply-To: <5e9665e10902112352i57177f20r9022a7cb8a66fa0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DongSoo Kim wrote:
> Thank you for your comment.
> 
> BTW, what should I do if I would rather use external ISP device than
> OMAP3 internal ISP feature?
> 
> You said that you just have raw sensors by now, so you mean this patch
> is not verified working with some ISP modules?

I haven't verified it myself. Others might be using it.

> I'm testing your patch on my own omap3 target board with NEC ISP...but
> unfortunately not working yet ;(

NEC ISP? A sensor with NEC ISP integrated?

> I should try more harder. more research is needed :)

Thanks for the interest. :-)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
