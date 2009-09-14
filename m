Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64109 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbZINTJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 15:09:32 -0400
Received: by mail-ew0-f206.google.com with SMTP id 2so969025ewy.17
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 12:09:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAC656D.2070709@gmail.com>
References: <4AAC656D.2070709@gmail.com>
Date: Mon, 14 Sep 2009 23:09:35 +0400
Message-ID: <208cbae30909141209ge8095fi9f64a07ada0599c1@mail.gmail.com>
Subject: Re: [RFC/RFT 0/14] radio-mr800 patch series
From: Alexey Klimov <klimov.linux@gmail.com>
To: david@identd.dyndns.org
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello David,

On Sun, Sep 13, 2009 at 7:22 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> What follow is a series of patches to clean up the radio-mr800 driver. I
> do _not_ have access to this device so these patches need to be tested.
> These patches should apply to Mauro's git tree and against the 2.6.31
> release kernel. The patches in this series are as follows:
>
> 01. radio-mr800: implement proper locking
> 02. radio-mr800: simplify video_device allocation
> 03. radio-mr800: simplify error paths in usb probe callback
> 04. radio-mr800: remove an unnecessary local variable
> 05. radio-mr800: simplify access to amradio_device
> 06. radio-mr800: simplify locking in ioctl callbacks
> 07. radio-mr800: remove device-removed indicator
> 08. radio-mr800: fix potential use after free
> 09. radio-mr800: remove device initialization from open/close
> 10. radio-mr800: ensure the radio is initialized to a consistent state
> 11. radio-mr800: fix behavior of set_radio function
> 12. radio-mr800: preserve radio state during suspend/resume
> 13. radio-mr800: simplify device warnings
> 14. radio-mr800: set radio frequency only upon success
>
> The first 7 in this series are the same as those submitted in my last series
> and will not be resent. The remaining 7 patches in this series will be sent
> separately for review.
>
> Regards,
>
> David Ellingsworth

Thank you for work at radio-mr800. I'll check and test your patches as
soon as possible, it probably takes 2-3 days.


-- 
Best regards, Klimov Alexey
