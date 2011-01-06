Return-path: <mchehab@gaivota>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58543 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1AFVzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 16:55:42 -0500
Received: by qyk12 with SMTP id 12so19057776qyk.19
        for <linux-media@vger.kernel.org>; Thu, 06 Jan 2011 13:55:41 -0800 (PST)
References: <20101230094512.3c29ad71@gaivota>
In-Reply-To: <20101230094512.3c29ad71@gaivota>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <D1E3D050-06C3-484B-A248-689E7945AD91@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 0/4] Remove lirc_i2c driver
Date: Thu, 6 Jan 2011 16:55:52 -0500
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Dec 30, 2010, at 6:45 AM, Mauro Carvalho Chehab wrote:

> This series remove lirc_i2c driver. The first patch just
> adds a note to bttv-input. The next patches add two
> parsers for two devices that are supported by lirc_i2c, but
> not by ir-kbd-i2c. The last one finally drops lirc_i2c.
> 
> Mauro Carvalho Chehab (4):
>  [media] bttv-input: Add a note about PV951 RC
>  [media] cx88: Add RC logic for Leadtek PVR 2000
>  [media] ivtv: Add Adaptec Remote Controller
>  [media] Remove staging/lirc/lirc_i2c driver

Ack, amen, and good riddance to bad rubbish. :)

-- 
Jarod Wilson
jarod@wilsonet.com



