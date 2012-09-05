Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16988 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2IEQRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 12:17:39 -0400
Received: from eusync2.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9V006QIXA9VT80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Sep 2012 17:18:09 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M9V00KJ7X9CPY10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Sep 2012 17:17:37 +0100 (BST)
Message-id: <50477B20.1030902@samsung.com>
Date: Wed, 05 Sep 2012 18:17:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Fabio Estevam <festevam@gmail.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	=?UTF-8?B?R2HDq3RhbiA=?= =?UTF-8?B?Q2FybGllcg==?=
	<gcembed@gmail.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Camera not detected on linux-next
References: <CAOMZO5D7Ar0SE9vmi41jSxbPqv8sSOQshbL6Uzv4Ltow5xKx4w@mail.gmail.com>
In-reply-to: <CAOMZO5D7Ar0SE9vmi41jSxbPqv8sSOQshbL6Uzv4Ltow5xKx4w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/05/2012 06:06 PM, Fabio Estevam wrote:
> I am running linux-next 20120905 on a mx31pdk board with a ov2640 CMOS
> and I am not able to get the ov2640 to be probed:
> 
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
> .... (no messages showing ov2640 being probed)
> 
> I noticed that Kconfig changed the way to select the "Sensors used on
> soc_camera driver" and I selected ov2640 in the .config.
> 
> camera worked fine on this board running 3.5.3. So before start
> bisecting, I would like to know if there is anything obvious I am
> missing.
> 
> Also tested on a mx27pdk and ov2640 could not be probed there as well.

Maybe this is about the sensor/host driver linking order.
If so, then this patch should help

http://git.linuxtv.org/snawrocki/media.git/commitdiff/458b9b5ab8cb970887c9d1f1fddf88399b2d9ef2

--

Regards,
Sylwester
