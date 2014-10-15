Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33791 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaJOOkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 10:40:13 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so1177119lab.19
        for <linux-media@vger.kernel.org>; Wed, 15 Oct 2014 07:40:12 -0700 (PDT)
Message-ID: <543E8746.80809@cogentembedded.com>
Date: Wed, 15 Oct 2014 18:40:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/3] media: soc_camera: rcar_vin: Add NV16 horizontal
 scaling-up support
References: <1413268013-8437-1-git-send-email-ykaneko0929@gmail.com> <1413268013-8437-4-git-send-email-ykaneko0929@gmail.com> <543D1DD1.2060700@cogentembedded.com> <20141015045213.GA18646@verge.net.au>
In-Reply-To: <20141015045213.GA18646@verge.net.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/15/2014 08:52 AM, Simon Horman wrote:

>>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

>>> The scaling function had been forbidden for the capture format of
>>> NV16 until now. With this patch, a horizontal scaling-up function
>>> is supported to the capture format of NV16. a vertical scaling-up
>>> by the capture format of NV16 is forbidden for the H/W specification.

>>     s/for/by/?

> How about the following text?

> Up until now scaling has been forbidden for the NV16 capture format. This
> patch adds support for horizontal scaling-up for NV16. Vertical scaling-up
> for NV16 is forbidden for by the H/W specification.

    "For by", hehe? Were you trying to keep every happy? :-)

WBR, Sergei

