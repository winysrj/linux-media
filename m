Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:24405 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbaFSTPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 15:15:25 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: mt9m111: add device-tree suppport
References: <1402863452-30365-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1406190929380.22703@axis700.grange>
Date: Thu, 19 Jun 2014 21:15:22 +0200
In-Reply-To: <Pine.LNX.4.64.1406190929380.22703@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu, 19 Jun 2014 09:36:48 +0200 (CEST)")
Message-ID: <877g4csoc5.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>> +static int of_get_mt9m111_platform_data(struct device *dev,
>> +					struct soc_camera_subdev_desc *desc)
>> +{
>> +	return 0;
>> +}
>
> Why do you need this function? I would just drop it.
Yeah, drop it sounds good. I wrote it at the beginning to have a clear
structure, and then didn't use it.


>> +static const struct of_device_id mt9m111_of_match[] = {
>> +	{ .compatible = "micron,mt9m111", },
>
> Not a flaw in this patch, but someone might want to add "micron" to 
> Documentation/devicetree/bindings/vendor-prefixes.txt
OK, I'll see what I can submit, it should be doable :)

Cheers.

-- 
Robert
