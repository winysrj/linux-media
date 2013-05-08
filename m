Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:38712 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3EHVCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 17:02:33 -0400
Received: by mail-ea0-f181.google.com with SMTP id a15so1168346eae.26
        for <linux-media@vger.kernel.org>; Wed, 08 May 2013 14:02:32 -0700 (PDT)
Message-ID: <518ABD64.1020904@gmail.com>
Date: Wed, 08 May 2013 23:02:28 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 8/9] s5c73m3: Convert to devm_gpio_request_one()
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com> <1368020794-21264-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-9-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2013 03:46 PM, Laurent Pinchart wrote:
> Use the devm_gpio_request_one() managed function to simplify cleanup
> code paths.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
