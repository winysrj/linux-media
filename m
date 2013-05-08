Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36727 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3EHVEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 17:04:12 -0400
Received: by mail-ee0-f43.google.com with SMTP id b15so1256199eek.16
        for <linux-media@vger.kernel.org>; Wed, 08 May 2013 14:04:11 -0700 (PDT)
Message-ID: <518ABDC9.9080907@gmail.com>
Date: Wed, 08 May 2013 23:04:09 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 9/9] s5k6aa: Convert to devm_gpio_request_one()
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com> <1368020794-21264-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-10-git-send-email-laurent.pinchart@ideasonboard.com>
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
