Return-path: <mchehab@pedra>
Received: from mailmxout5.mailmx.agnat.pl ([193.239.44.251]:60020 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751805Ab1A0SPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 13:15:43 -0500
Message-ID: <A36CF5015AB044A28F1F3800731C351C@laptop2>
From: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <g.daniluk@elproma.com.pl>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
References: <1E539FC23CF84B8A91428720570395E0@laptop2> <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2> <Pine.LNX.4.64.1101262045550.3989@axis700.grange> <F95361ABAE1D4A70A10790A798004482@laptop2> <Pine.LNX.4.64.1101271809030.8916@axis700.grange>
Subject: Re: SoC Camera driver and TV decoder
Date: Thu, 27 Jan 2011 19:15:36 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from 
>> camera 0
>> camera: probe of 0-0 failed with error -515
>
> This is strange, however - error code 515... Can you try to find out where
> it is coming from?

Something is really wrong:
drivers/base/dd.c:                     "%s: probe of %s failed with error 
%d\n",
in
static int really_probe(struct device *dev, struct device_driver *drv)


Bus probe or "camera" probe failed.

regards
Janusz

