Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45072 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0G3PmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 11:42:13 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 30 Jul 2010 10:42:09 -0500
Subject: RE: [media-ctl PATCH 2/3] Just include kernel headers
Message-ID: <A24693684029E5489D1D202277BE894456C0B5B8@dlee02.ent.ti.com>
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
 <201007301623.46995.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894456C0B4F4@dlee02.ent.ti.com>
 <201007301739.59013.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007301739.59013.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, July 30, 2010 10:40 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: Re: [media-ctl PATCH 2/3] Just include kernel headers
> 
> Hi Sergio,

<snip>

> 
> Ideally the application should be built against installed kernel headers,
> bug
> given the early stage of development of the media controller, I expect
> most
> people to build it against a kernel tree. I would like to keep the
> Makefile
> as-is for now, and change it when the media controller patches will reach
> the
> mainline kernel.

Ok, understood. Not a problem.

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
