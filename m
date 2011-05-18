Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64000 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab1ERKeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 06:34:10 -0400
Received: by iwn34 with SMTP id 34so1178841iwn.19
        for <linux-media@vger.kernel.org>; Wed, 18 May 2011 03:34:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105171414.34179.ivan.nazarenko@gmail.com>
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1105171345580.5582@axis700.grange>
	<BANLkTinR3g7DcXLqOngw8kkNc-LLysFX=w@mail.gmail.com>
	<201105171414.34179.ivan.nazarenko@gmail.com>
Date: Wed, 18 May 2011 12:34:09 +0200
Message-ID: <BANLkTimCZm5-mtLfCn-_s1EVcL6DxaqC-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mt9p031: Add mt9p031 sensor driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: Ivan Nazarenko <ivan.nazarenko@gmail.com>
Cc: linux-media@vger.kernel.org, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Ivan,

On 17 May 2011 19:14, Ivan Nazarenko <ivan.nazarenko@gmail.com> wrote:
> Javier,
>
> I have been using the aptina patch (https://github.com/Aptina/BeagleBoard-xM) on beagleboard while waiting linux-media solve this mt9p031 issue. Now that you have something working, I would like to try it - but I would like to know what is the clock rate you actually drove the sensor.
>
> Reviewing your path, I suppose it is 54MHz, so you would be achieving some 10 full 5MPix frames/s from the sensor. Is that correct? (the aptina patch delivers less than 4 fps).
>

Yes, you are right. Whereas clock rate is set to 54MHz, with my
oscilloscope I have measured 57 MHz.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
