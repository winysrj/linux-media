Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([63.128.21.107]:46158 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751226AbdJDQAz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 12:00:55 -0400
Subject: Re: [PATCH v6 2/2] media: rc: Add driver for tango HW IR decoder
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
To: Sean Young <sean@mess.org>
CC: Mans Rullgard <mans@mansr.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
References: <308711ef-0ba8-d533-26fd-51e5b8f32cc8@free.fr>
 <e3d91250-e6bd-bb8c-5497-689c351ac55f@free.fr> <yw1xzi9ieuqe.fsf@mansr.com>
 <893874ee-a6e0-e4be-5b4f-a49e60197e92@free.fr> <yw1xr2uuenhv.fsf@mansr.com>
 <0690fbbb-a13f-63af-bc43-b1f9d4771bc4@free.fr>
Message-ID: <3dc97914-048f-e932-c05d-211b5111eb84@sigmadesigns.com>
Date: Wed, 4 Oct 2017 18:00:47 +0200
MIME-Version: 1.0
In-Reply-To: <0690fbbb-a13f-63af-bc43-b1f9d4771bc4@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/09/2017 10:51, Marc Gonzalez wrote:

> From: Mans Rullgard <mans@mansr.com>
> 
> The tango HW IR decoder supports NEC, RC-5, RC-6 protocols.
> 
> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> ---
> Changes between v5 and v6
> * Move "register fields" macros to top of file
> * Restore IRQ pending writes
> ---
>  drivers/media/rc/Kconfig    |  10 ++
>  drivers/media/rc/Makefile   |   1 +
>  drivers/media/rc/tango-ir.c | 279 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 290 insertions(+)
>  create mode 100644 drivers/media/rc/tango-ir.c

Hello Sean,

Are there issues remaining before this series can be accepted upstream?

Are you waiting for the DT folks to review the DT binding?

Can I submit a keymap patch on top of the series?

Regards.
