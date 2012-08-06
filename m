Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2HFIVH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 04:21:07 -0400
Message-ID: <501F7E8F.1090809@redhat.com>
Date: Mon, 06 Aug 2012 10:21:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] gspca: dubious one-bit signed bitfield
References: <1344170066-19727-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1344170066-19727-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/05/2012 02:34 PM, Emil Goode wrote:
> This patch changes some signed integers to unsigned because
> they are not intended for negative values and sparse
> is making noise about it.
>
> Sparse gives eight of these errors:
> drivers/media/video/gspca/ov519.c:144:29: error: dubious one-bit signed bitfield
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Thanks, I'll add this to my gspca tree.

Regards,

Hans
