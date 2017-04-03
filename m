Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34829 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdDCIar (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 04:30:47 -0400
Date: Mon, 3 Apr 2017 10:30:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 0/6] [media] fix missing endpoint sanity checks
Message-ID: <20170403083042.GC25742@localhost>
References: <20170313125359.29394-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313125359.29394-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 13, 2017 at 01:53:53PM +0100, Johan Hovold wrote:
> This series fixes a number of NULL-pointer dereferences (and related
> issues) due to missing endpoint sanity checks that can be triggered by a
> malicious USB device.
 
> Johan Hovold (6):
>   [media] dib0700: fix NULL-deref at probe
>   [media] usbvision: fix NULL-deref at probe
>   [media] cx231xx-cards: fix NULL-deref at probe
>   [media] cx231xx-audio: fix init error path
>   [media] cx231xx-audio: fix NULL-deref at probe
>   [media] gspca: konica: add missing endpoint sanity check

I noticed these had been assigned to you, Hans. Anything more you need
to get them merged?

Thanks,
Johan
