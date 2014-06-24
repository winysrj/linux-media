Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48318 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaFXMAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 08:00:45 -0400
Received: by mail-lb0-f179.google.com with SMTP id z11so254510lbi.38
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 05:00:43 -0700 (PDT)
Message-ID: <53A9686D.5040508@cogentembedded.com>
Date: Tue, 24 Jun 2014 16:00:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 07/23] v4l: vsp1: Release buffers at stream stop
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 06/24/2014 03:54 AM, Laurent Pinchart wrote:

> videobuf2 expects no buffer to be owned by the driver when the
> stop_stream queue operation returns. As the vsp1 driver fails to do so,
> a warning is generated at stream top time.

> Fix this by mark releasing all buffers queued on the IRQ queue in the

    Mark releasing?

> stop_stream operation handler and marking them as erroneous.

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

WBR, Sergei

