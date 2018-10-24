Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32950 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeJYE0M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Oct 2018 00:26:12 -0400
Subject: Re: [PATCH] [bug/urgent] dvb-usb-v2: Fix incorrect use of
 transfer_flags URB_FREE_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org
References: <04c2de66-ec7f-48db-472b-bdc4cd266cc8@gmail.com>
Message-ID: <e5c806ae-c80c-dd15-53af-9622d7bef007@gmail.com>
Date: Wed, 24 Oct 2018 20:56:42 +0100
MIME-Version: 1.0
In-Reply-To: <04c2de66-ec7f-48db-472b-bdc4cd266cc8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/10/2018 22:26, Malcolm Priestley wrote:
> In commit 1a0c10ed7b media: dvb-usb-v2: stop using coherent memory for URBs
> incorrectly adds URB_FREE_BUFFER after every urb transfer resulting in
> no buffers and eventually deadlock.
> 
> The stream buffer should remain in constant while in use by user and kfree() on their departure.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> CC: stable@vger.kernel.org # v4.18+
> ---
>  drivers/media/usb/dvb-usb-v2/usb_urb.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> index 024c751eb165..2ad2ddeaff51 100644
> --- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
> +++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> @@ -155,7 +155,6 @@ static int usb_urb_alloc_bulk_urbs(struct usb_data_stream *stream)

Re sending email line wrap corruption
