Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19435 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZFWGkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 02:40:23 -0400
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: ext Dongsoo Kim <dongsoo.kim@gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update 2)
Date: Tue, 23 Jun 2009 09:40:04 +0300
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"ext Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	"gary@mlbassoc.com" <gary@mlbassoc.com>
References: <4A3A7AE2.9080303@maxwell.research.nokia.com> <200906221652.02119.tuukka.o.toivonen@nokia.com> <9FCF32A4-259F-43EA-BA43-02248198FDE6@gmail.com>
In-Reply-To: <9FCF32A4-259F-43EA-BA43-02248198FDE6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230940.04465.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 June 2009 17:00:53 ext Dongsoo Kim wrote:
> OK, what I'm afraid is that even though the device could be opened and  
> recognized as a v4l2 device but has no capability should be weird.  
> Actually I'm not sure about this case is spec-in or not.
> In my opinion it should be better when the camera interface (or ISP)  
> has no int device (or subdev) attahced on it, no device node mounted  
> in /dev or returning ENODEV. But before that, I'm very curious about  
> why you made in that way.

We had to be able to use other slave devices (eg. flash)
before attaching the actual camera module.

- Tuukka
