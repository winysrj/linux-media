Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:62417 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0AILB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 06:01:29 -0500
Received: by ewy6 with SMTP id 6so19808953ewy.29
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2010 03:01:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <494322846-1263027888-cardhu_decombobulator_blackberry.rim.net-290047907-@bda006.bisx.prod.on.blackberry>
References: <494322846-1263027888-cardhu_decombobulator_blackberry.rim.net-290047907-@bda006.bisx.prod.on.blackberry>
Date: Sat, 9 Jan 2010 12:01:27 +0100
Message-ID: <c2fe070d1001090301h37777c77me803ae910b35e7c8@mail.gmail.com>
Subject: Re: problem webcam gspca 2.6.32
From: leandro Costantino <lcostantino@gmail.com>
To: knife@toaster.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also, if you can, try the lastest from linuxtv.org

On Sat, Jan 9, 2010 at 10:05 AM, Sean <knife@toaster.net> wrote:
> What kind of errors or problems are you getting?
>
> Can you turn on debugging and give us some output?
>
> Sean
> ------Original Message------
> From: sacarde
> Sender: linux-media-owner@vger.kernel.org
> To: linux-media@vger.kernel.org
> Subject: problem webcam gspca 2.6.32
> Sent: Jan 9, 2010 12:32 AM
>
> hi,
>  on my archlinux-64 I have a webcam: 0471:0322 Philips DMVC1300K PC Camera
>
>  until one mounth ago this works OK with driver: gspca_sunplus
>
>  now with kernel 2.6.32 not works....
>  I start cheese and I view: http://sacarde.interfree.it/errore-cheese.png
>  and this messages:
>  Cheese 2.28.1
>  Probing devices with HAL...
>  Found device 0471:0322, getting capabilities...
>  Detected v4l2 device: USB Camera (0471:0322)
>  Driver: sunplus, version: 132864
>  Capabilities: 0x05000001
>  Probing supported video formats...
>
>
>  from dmesg:
>  ...
>  gspca: probing 0471:0322
>  gspca: probe ok
>  ...
>  /dev/video0 is created
>
>
>  I try to downgrade previus kernel kernel26 2.6.31.6-1 and dependencies
>
>  and it works:
>
>  when it works 2.6.31: Driver: sunplus, version: 132608
>
>
>  thankyou
>
>
>
> sacarde@tiscali.it
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
