Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35632 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaHDUj5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 16:39:57 -0400
Received: by mail-la0-f54.google.com with SMTP id hz20so5946553lab.13
        for <linux-media@vger.kernel.org>; Mon, 04 Aug 2014 13:39:56 -0700 (PDT)
Message-ID: <53DFEF99.7040503@cogentembedded.com>
Date: Tue, 05 Aug 2014 00:39:53 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ian Molton <ian.molton@codethink.co.uk>,
	linux-media@vger.kernel.org
CC: linux-kernel@lists.codethink.co.uk, g.liakhovetski@gmx.de,
	m.chehab@samsung.com, vladimir.barinov@cogentembedded.com,
	magnus.damm@gmail.com, horms@verge.net.au, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/4] media: rcar_vin: Ensure all in-flight buffers are
 returned to error state before stopping.
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk> <1404812474-7627-3-git-send-email-ian.molton@codethink.co.uk>
In-Reply-To: <1404812474-7627-3-git-send-email-ian.molton@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2014 01:41 PM, Ian Molton wrote:

> Videobuf2 complains about buffers that are still marked ACTIVE (in use by the driver) following a call to stop_streaming().

> This patch returns all active buffers to state ERROR prior to stopping.

> Note: this introduces a (non fatal) race condition as the stream is not guaranteed to be stopped at this point.

> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>

    Fixed kernel WARNINGs for me! \o/
    Ian, perhaps it makes sense for me to take these patches into my hands?

WBR, Sergei

