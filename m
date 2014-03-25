Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:52105 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbaCYUvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 16:51:52 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: =?utf-8?Q?Andr=C3=A9?= Roth <neolynx@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 11/11] libdvbv5: fix PMT parser
References: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
	<1395771601-3509-11-git-send-email-neolynx@gmail.com>
Date: Tue, 25 Mar 2014 21:51:49 +0100
In-Reply-To: <1395771601-3509-11-git-send-email-neolynx@gmail.com>
 (=?utf-8?Q?=22Andr=C3=A9?=
	Roth"'s message of "Tue, 25 Mar 2014 19:20:01 +0100")
Message-ID: <87vbv2c87u.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

André Roth <neolynx@gmail.com> writes:

> --- a/lib/libdvbv5/descriptors/pmt.c
> +++ b/lib/libdvbv5/descriptors/pmt.c
> @@ -1,6 +1,5 @@
>  /*
> - * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
> - * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
> + * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License

This copyright change looked strange to me.  Accidental deletion?


Bjørn
