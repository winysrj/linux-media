Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:61272 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaBRDzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 22:55:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140206092800.GB31780@elgon.mountain>
References: <20140206092800.GB31780@elgon.mountain>
Date: Tue, 18 Feb 2014 09:25:36 +0530
Message-ID: <CAHFNz9LMU0X2YsqniY+6VOS_mM-jUfAvP2sF5MFNdwWWwEVgsw@mail.gmail.com>
Subject: Re: [patch] [media] stv090x: remove indent levels
From: Manu Abraham <abraham.manu@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Thu, Feb 6, 2014 at 2:58 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 1) We can flip the "if (!lock)" check to "if (lock) return lock;" and
>    then remove a big chunk of indenting.
> 2) There is a redundant "if (!lock)" which we can remove since we
>    already know that lock is zero.  This removes another indent level.


The stv090x driver is a mature, but slightly complex driver supporting
quite some
different configurations. Is it that some bug you are trying to fix in there ?
I wouldn't prefer unnecessary code churn in such a driver for
something as simple
as gain in an indentation level.


Thanks,

Manu
