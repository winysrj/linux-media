Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64807 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2K1NJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 08:09:00 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so9998453iea.19
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 05:09:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <k93vu3$ffi$1@ger.gmane.org>
References: <k93vu3$ffi$1@ger.gmane.org>
Date: Wed, 28 Nov 2012 10:08:59 -0300
Message-ID: <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com>
Subject: Re: ivtv driver inputs randomly "block"
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 28, 2012 at 12:20 AM, Brian J. Murrell
<brian@interlinx.bc.ca> wrote:
>
> To remedy the hanging input I simply have to rmmod ivtv && modprobe ivtv
> and all is back to normal again, until it happens again.
>
> Any ideas?
>

Can you post a dmesg output when this happens?

Thanks,

    Ezequiel
