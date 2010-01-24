Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:43243 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab0AXVQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 16:16:05 -0500
Received: by fxm7 with SMTP id 7so1350340fxm.28
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 13:16:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001242239.10739.anssi.hannula@iki.fi>
References: <201001242239.10739.anssi.hannula@iki.fi>
Date: Mon, 25 Jan 2010 01:16:03 +0400
Message-ID: <1a297b361001241316u529fdf01v5eb589f68a541664@mail.gmail.com>
Subject: Re: [PATCH] dvb-apps scan: fix zero transport stream id
From: Manu Abraham <abraham.manu@gmail.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 25, 2010 at 12:39 AM, Anssi Hannula <anssi.hannula@iki.fi> wrote:
> scan sometimes returns services with transport stream id = 0. This
> happens when the service is allocated before the transport stream
> id is known. This patch simply makes copy_transponder propagate
> transport stream id changes to all services of the transponder.
>
> Symptoms of zero transport stream id include VDR not showing EPG.
>
> Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
>
> ---
>
> Index: dvb-apps-1181/util/scan/scan.c
> ===================================================================
> --- dvb-apps-1181/util/scan/scan.c
> +++ dvb-apps-1181/util/scan/scan.c      2010-01-24 22:22:25.092513605 +0200
> @@ -236,6 +236,17 @@
>
>  static void copy_transponder(struct transponder *d, struct transponder *s)
>  {
> +       struct list_head *pos;
> +       struct service *service;
> +
> +       if (d->transport_stream_id != s->transport_stream_id) {
> +               /* propagate change to any already allocated services */
> +               list_for_each(pos, &d->services) {
> +                       service = list_entry(pos, struct service, list);
> +                       service->transport_stream_id = s->transport_stream_id;
> +               }
> +       }
> +
>        d->network_id = s->network_id;
>        d->original_network_id = s->original_network_id;
>        d->transport_stream_id = s->transport_stream_id;
>
>
> --
> Anssi Hannula
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Applied, Thanks.
