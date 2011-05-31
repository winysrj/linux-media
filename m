Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51600 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1EaJMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 05:12:53 -0400
Received: by ewy4 with SMTP id 4so1551200ewy.19
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 02:12:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E9456CEE-9CC5-450F-BEC7-5E6D81D9466E@dominion.thruhere.net>
References: <1306744637-9051-1-git-send-email-javier.martin@vista-silicon.com>
	<1306744637-9051-2-git-send-email-javier.martin@vista-silicon.com>
	<8EFA38E5-E9C6-4C2E-A552-3E7D07DBC596@beagleboard.org>
	<E9456CEE-9CC5-450F-BEC7-5E6D81D9466E@dominion.thruhere.net>
Date: Tue, 31 May 2011 11:12:51 +0200
Message-ID: <BANLkTinU9h7m6BiCnsxf5oWRUWaS3ONwgg@mail.gmail.com>
Subject: Re: [beagleboard] [PATCH v4 2/2] Add support for mt9p031 (LI-5M03
 module) in Beagleboard xM.
From: javier Martin <javier.martin@vista-silicon.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: "beagleboard@googlegroups.com Board" <beagleboard@googlegroups.com>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Chris Rodley <carlighting@yahoo.co.nz>, mch_kot@yahoo.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 31 May 2011 09:59, Koen Kooi <koen@dominion.thruhere.net> wrote:
>
> Op 31 mei 2011, om 09:52 heeft Koen Kooi het volgende geschreven:
>
>>
>> Op 30 mei 2011, om 10:37 heeft Javier Martin het volgende geschreven:
>>
>>> Since isp clocks have not been exposed yet, this patch
>>> includes a temporal solution for testing mt9p031 driver
>>> in Beagleboard xM.
>>
>> When compiling both as Y I get:
>>
>> [    4.231628] mt9p031 2-0048: Failed to reset the camera
>> [    4.237030] omap3isp omap3isp: Failed to power on: -121
>> [    4.242523] mt9p031 2-0048: Failed to power on device: -121
>> [    4.248474] isp_register_subdev_group: Unable to register subdev mt9p031
>
> I tried on an xM rev A2 and xM rev C, same error on both
>

Crap,
I get the same error here. Sorry for the inconvenience.
I'll send a new version in some minutes.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
