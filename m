Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.182]:57609 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932503AbeCMLkG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 07:40:06 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kieran Bingham' <kieran.bingham+renesas@ideasonboard.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/11] media: vsp1: use kernel __packed for structures
Date: Tue, 13 Mar 2018 11:20:04 +0000
Message-ID: <b58ff7ec7f7246498325e74b31ba3664@AcuMS.aculab.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
 <767c4c9f6aa4799a58f0979b318208f1d3e27860.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <767c4c9f6aa4799a58f0979b318208f1d3e27860.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham
> Sent: 09 March 2018 22:04
> The kernel provides a __packed definition to abstract away from the
> compiler specific attributes tag.
> 
> Convert all packed structures in VSP1 to use it.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 37e2c984fbf3..382e45c2054e 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -29,19 +29,19 @@
>  struct vsp1_dl_header_list {
>  	u32 num_bytes;
>  	u32 addr;
> -} __attribute__((__packed__));
> +} __packed;
> 
>  struct vsp1_dl_header {
>  	u32 num_lists;
>  	struct vsp1_dl_header_list lists[8];
>  	u32 next_header;
>  	u32 flags;
> -} __attribute__((__packed__));
> +} __packed;
> 
>  struct vsp1_dl_entry {
>  	u32 addr;
>  	u32 data;
> -} __attribute__((__packed__));
> +} __packed;

Do these structures ever actually appear in misaligned memory?
If they don't then they shouldn't be marked 'packed'.

	David
