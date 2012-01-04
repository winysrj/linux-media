Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39011 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2ADNAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 08:00:18 -0500
Received: by eaad14 with SMTP id d14so9350523eaa.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 05:00:17 -0800 (PST)
Message-ID: <4F044D21.1030204@mvista.com>
Date: Wed, 04 Jan 2012 16:59:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 1/2] davinci: vpif: remove machine specific header
 file inclusion from the driver
References: <1325661469-4411-1-git-send-email-manjunath.hadli@ti.com> <1325661469-4411-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1325661469-4411-2-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04-01-2012 11:17, Manjunath Hadli wrote:

> remove unnecessary inclusion of machine specific header files mach/dm646x.h,
> mach/hardware.h from vpif.h  and aslo mach/dm646x.h from vpif_display.c
> driver which comes in the way of platform code consolidation.
> Add linux/i2c.h header file in vpif_types.h which is required for
> building.

    This last modification should be in a separate patch. Don;t mix changes 
having the different purpose.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Cc: Mauro Carvalho Chehab<mchehab@infradead.org>
> Cc: LMML<linux-media@vger.kernel.org>

WBR, Sergei
