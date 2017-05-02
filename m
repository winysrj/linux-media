Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:30795 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdEBOh4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 10:37:56 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Petr Cvek <petr.cvek@tul.cz>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] [media] pxa_camera: Add remaining Bayer 8 formats
References: <cover.1493612057.git.petr.cvek@tul.cz>
        <c2961fbe-c4dd-718c-75b6-bb5fad5c7b1e@tul.cz>
Date: Tue, 02 May 2017 16:37:52 +0200
In-Reply-To: <c2961fbe-c4dd-718c-75b6-bb5fad5c7b1e@tul.cz> (Petr Cvek's
        message of "Mon, 1 May 2017 06:20:45 +0200")
Message-ID: <8760hj1fzz.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Petr Cvek <petr.cvek@tul.cz> writes:

> This patch adds Bayer 8 GBRG and RGGB support and move GRBG definition
> close to BGGR (so all Bayer 8 variants are together). No other changes are
> needed as the driver handles them as RAW data stream.
>
> The RGGB variant was tested in a modified OV9640 driver.
>
> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
