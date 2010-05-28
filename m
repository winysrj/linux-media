Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:36393 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab0E1WBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 18:01:10 -0400
Message-ID: <4C003CB9.1090700@arcor.de>
Date: Fri, 28 May 2010 23:59:21 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] tm6000: rewrite copy_streams
References: <1275069820-23980-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1275069820-23980-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: multipart/mixed;
 boundary="------------050404040100050803000106"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050404040100050803000106
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 28.05.2010 20:03, schrieb stefan.ringel@arcor.de:
> From: Stefan Ringel <stefan.ringel@arcor.de>
>
> fusion function copy streams and copy_packets to new function copy_streams.
>
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-usb-isoc.h |    5 +-
>  drivers/staging/tm6000/tm6000-video.c    |  329 +++++++++++-------------------
>  2 files changed, 119 insertions(+), 215 deletions(-)
>
> diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
> -- snipp
>   
Mauro can you superseded the patch from 28.05.2010 , 18:03 h

thanks
Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------050404040100050803000106
Content-Type: text/x-vcard; charset=utf-8;
 name="stefan_ringel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stefan_ringel.vcf"

begin:vcard
fn:Stefan Ringel
n:Ringel;Stefan
email;internet:stefan.ringel@arcor.de
note:web: www.stefanringel.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050404040100050803000106--
