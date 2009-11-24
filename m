Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:29537 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbZKXIIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 03:08:23 -0500
Received: by ey-out-2122.google.com with SMTP id 4so1194776eyf.19
        for <linux-media@vger.kernel.org>; Tue, 24 Nov 2009 00:08:28 -0800 (PST)
Date: Tue, 24 Nov 2009 10:00:06 +0200
From: Dan Carpenter <error27@gmail.com>
To: Ang Way Chuang <wcang79@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb-core: Fix ULE decapsulation bug when less than 4
	bytes of ULE SNDU is packed into the remaining bytes of a MPEG2-TS
	frame
Message-ID: <20091124080006.GB14488@bicker>
References: <51d384e10911230137q7553b8c4x5ba3aca3e8edbc77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51d384e10911230137q7553b8c4x5ba3aca3e8edbc77@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 05:37:57PM +0800, Ang Way Chuang wrote:
> --- a/drivers/media/dvb/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb/dvb-core/dvb_net.c
> @@ -458,8 +458,9 @@ static void dvb_net_ule( struct net_device *dev,
> const u8 *buf, size_t buf_len )

Your email client line broke the line starting with @@ into 2 lines so
the patch doesn't apply.

Could you resend the patch without line wrapping?

regards,
dan carpenter

