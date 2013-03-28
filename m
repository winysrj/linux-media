Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56941 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3C1GLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 02:11:53 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so4549707eek.36
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 23:11:51 -0700 (PDT)
Date: Thu, 28 Mar 2013 08:12:46 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] em28xx: ignore isoc DVB USB endpoints with
 wMaxPacketSize = 0 bytes for all alt settings
Message-ID: <20130328081246.3c3c5d65@vostro>
In-Reply-To: <1364414861-7233-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364414861-7233-1-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Mar 2013 21:07:41 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> wrote:

> Some devices without DVB support (such as the "Terratec Grabby" and
> "Easycap DC-60") provide isochronous DVB USB endpoints with
> wMaxPacketSize set to 0 bytes for all alt settings.
> 
> Ignore these endpoints and avoid registering a DVB device node and
> loading the DVB driver extension.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Cc: stable@kernel.org

Tested-by: Timo Teräs <timo.teras@iki.fi>

Fixes the false DVB detection on my "Terratec Grabby".
