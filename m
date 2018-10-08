Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelv0143.ext.ti.com ([198.47.23.248]:34052 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbeJHUDu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 16:03:50 -0400
Subject: Re: [PATCH 4/5] omapdrm/dss/hdmi4_cec.c: clear TX FIFO before
 transmit_done
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
 <20181004090900.32915-5-hverkuil@xs4all.nl>
 <33ddd03f-91aa-6c19-380e-a81abf390180@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <d6b30689-2529-f3ed-9886-de0ef634388c@ti.com>
Date: Mon, 8 Oct 2018 15:52:12 +0300
MIME-Version: 1.0
In-Reply-To: <33ddd03f-91aa-6c19-380e-a81abf390180@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 05/10/18 17:13, Hans Verkuil wrote:
> Tomi,
> 
> Can you review this patch and the next? They should go to 4.20.
> This patch in particular is a nasty one, hard to reproduce.
> 
> This patch should also be Cc-ed to stable for 4.15 and up.

Done. There's no dependency from the omapdrm patches to the first patch,
is there? I.e. I can apply these via omapdrm?

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
