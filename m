Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57433 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753062AbdLKOuX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 09:50:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 09/10] v4l: i2c: Copy tw9910 soc_camera sensor driver
Date: Mon, 11 Dec 2017 16:50:24 +0200
Message-ID: <45852136.NkeXGtRUS2@avalon>
In-Reply-To: <1510743363-25798-10-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-10-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Wednesday, 15 November 2017 12:56:02 EET Jacopo Mondi wrote:
> Copy the soc_camera based driver in v4l2 sensor driver directory.
> This commit just copies the original file without modifying it.

As for patch 07/10, you might want to explain why you're not patching the 
Kconfig and Makefile here, that is because you will first convert the driver 
away from soc-camera in the next commit.

Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/tw9910.c | 999 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 999 insertions(+)
>  create mode 100644 drivers/media/i2c/tw9910.c

-- 
Regards,

Laurent Pinchart
