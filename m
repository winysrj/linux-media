Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:34462 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548Ab3ECGNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 02:13:01 -0400
Received: by mail-we0-f178.google.com with SMTP id t11so1092677wey.9
        for <linux-media@vger.kernel.org>; Thu, 02 May 2013 23:13:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367492652-28704-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1367492652-28704-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 3 May 2013 11:42:40 +0530
Message-ID: <CA+V-a8vW84WqiJN5qTGHCGQ3tq0HHV3kyAuwjMQNJrBnQ551ag@mail.gmail.com>
Subject: Re: [PATCH] mt9p031: Use gpio_is_valid()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Thu, May 2, 2013 at 4:34 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Replace the manual validity checks for the reset GPIO with the
> gpio_is_valid() function.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
