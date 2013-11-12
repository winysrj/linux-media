Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65473 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KLUeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Nov 2013 15:34:08 -0500
Received: by mail-lb0-f174.google.com with SMTP id y6so224732lbh.19
        for <linux-media@vger.kernel.org>; Tue, 12 Nov 2013 12:34:06 -0800 (PST)
Message-ID: <528290BC.8070207@cogentembedded.com>
Date: Wed, 13 Nov 2013 00:34:04 +0400
From: Valentine <valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/3] media: Add SH-Mobile RCAR-H2 Lager board support
References: <1380029916-10331-1-git-send-email-valentine.barshak@cogentembedded.com> <2610202.KZTyX0lZUJ@avalon>
In-Reply-To: <2610202.KZTyX0lZUJ@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2013 03:42 AM, Laurent Pinchart wrote:
> Hi Valentine,
>
> On Tuesday 24 September 2013 17:38:33 Valentine Barshak wrote:
>> The following patches add ADV7611/ADV7612 HDMI receiver I2C driver
>> and add RCAR H2 SOC support along with ADV761x output format support
>> to rcar_vin soc_camera driver.
>>
>> These changes are needed for SH-Mobile R8A7790 Lager board
>> video input support.
>
> Do you plan to submit a v2 ? I need the ADV761x driver pretty soon and I'd
> like to avoid submitting a competing patch :-)

Yes, I plan to submit v2 when it's ready.
Currently it's a work in progress.

Do you already have anything to submit for the ADV761x support?

Thanks,
Val.
