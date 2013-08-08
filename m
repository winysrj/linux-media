Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54959 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966575Ab3HHU53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 16:57:29 -0400
Received: by mail-lb0-f170.google.com with SMTP id r10so2832092lbi.15
        for <linux-media@vger.kernel.org>; Thu, 08 Aug 2013 13:57:28 -0700 (PDT)
Message-ID: <5204063E.7050707@cogentembedded.com>
Date: Fri, 09 Aug 2013 00:57:34 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org
CC: magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v9] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201307260023.11460.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201307260023.11460.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 07/26/2013 12:23 AM, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

> Add Renesas R-Car VIN (Video In) V4L2 driver.

> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.

> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
> *if* statement  and used 'bool' values instead of 0/1 where necessary, removed
> unused macros, done some reformatting and clarified some comments.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

    Guennadi, Mauro, if you don't have issues with this version, perhaps we 
still can merge it to 3.11 using "the new drivers can't cause regressions, so 
mergeable any time" rule?

WBR, Sergei

