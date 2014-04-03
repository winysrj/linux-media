Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30919 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaDCKR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 06:17:28 -0400
Message-id: <533D352E.7050302@samsung.com>
Date: Thu, 03 Apr 2014 12:17:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v2 4/6] v4l: vsp1: Add DT support
References: <1396461690-2334-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <533C832C.3080608@gmail.com> <1484365.AL7arRdPNh@avalon>
In-reply-to: <1484365.AL7arRdPNh@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/04/14 01:16, Laurent Pinchart wrote:
>>> @@ -534,6 +569,7 @@ static struct platform_driver vsp1_platform_driver = {
>>> > >   		.owner	= THIS_MODULE,
>>> > >   		.name	= "vsp1",
>>> > >   		.pm	= &vsp1_pm_ops,
>>> > > +		.of_match_table = of_match_ptr(vsp1_of_match),
>> > 
>> > Is of_match_ptr() really useful here, when vsp1_of_match[] array is always
>> > compiled in ?
>
> Would it be better to compile the vsp1_of_match[] array conditionally ? On the 
> other hand the driver is only useful (at least at the moment) on ARM Renesas 
> SoCs, which are transitioning to DT anyway.

Given that #ifdefs could be soon removed anyway (when the platform becomes
dt-only) I guess it's better not to introduce it now.

-- 
Regards,
Sylwester
