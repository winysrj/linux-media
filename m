Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42062 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbZHDVq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 17:46:57 -0400
Received: by ewy10 with SMTP id 10so687618ewy.37
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2009 14:46:56 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Pete Hildebrandt <send2ph@googlemail.com>
Subject: Re: [patch] Added Support for STK7700D (DVB)
Date: Tue, 4 Aug 2009 23:46:51 +0200
Cc: linux-media@vger.kernel.org
References: <200908042138.11938.send2ph@googlemail.com>
In-Reply-To: <200908042138.11938.send2ph@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908042346.52257.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete,

On Tuesday 04 August 2009 21:38:11 Pete Hildebrandt wrote:
> Hello,
>
> To this mail I attached two patch-files to add support for the STK7700D
> USB-DVB-Device.
>
> lsusb identifies it as:
> idVendor           0x1164 YUAN High-Tech Development Co., Ltd
> idProduct          0x1efc
>  iProduct                2 STK7700D
>
> My two patches mainly just add the new product-ID.
>
> I have tested the modification with the 2.6.28 and the 2.6.30 kernel. The
> patches are for the 2.6.30 kernel.
>
> The device is build into my laptop (Samsung R55-T5500) and works great
> after applying the patches.

I will apply your patches tomorrow, but before I need your Signed-off-by-line. 
So something like that:

Signed-off-by: Name <email>

thanks,
-- 
Patrick Boettcher - Kernel Labs
http://www.kernellabs.com
