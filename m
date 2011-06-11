Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45109 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab1FKJQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 05:16:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Crash on unplug with the uvc driver in linuxtv/staging/for_v3.1
Date: Sat, 11 Jun 2011 11:16:10 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4DF0ACDB.9000800@redhat.com>
In-Reply-To: <4DF0ACDB.9000800@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106111116.10615.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Thursday 09 June 2011 13:22:03 Hans de Goede wrote:
> Hi,
> 
> When I unplug a uvc camera *while streaming* I get:
> 
> [15824.809741] BUG: unable to handle kernel NULL pointer dereference at          
> (null)

[snip]

> I've not tested if this also impacts 3.0!!

It probably does. Thanks for the report. I'll fix it.

> I also get the following during building linuxtv/staging/for_v3.1:
> 
>    CC [M]  drivers/media/video/uvc/uvc_entity.o
> drivers/media/video/uvc/uvc_entity.c: In function
> ‘uvc_mc_register_entities’: drivers/media/video/uvc/uvc_entity.c:110:6:
> warning: ‘ret’ may be used uninitialized in this function
> [-Wuninitialized]

Mauro sent a patch to fix that.

-- 
Regards,

Laurent Pinchart
