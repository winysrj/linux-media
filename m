Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47674 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaGISYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 14:24:30 -0400
Received: by mail-qc0-f180.google.com with SMTP id r5so6996066qcx.11
        for <linux-media@vger.kernel.org>; Wed, 09 Jul 2014 11:24:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 9 Jul 2014 14:24:29 -0400
Message-ID: <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] saa7164: convert to seq_hex_dump()
From: Steven Toth <stoth@kernellabs.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	Linux-Media <linux-media@vger.kernel.org>,
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 9, 2014 at 11:24 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Instead of custom approach let's use recently added seq_hex_dump() helper.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

ack

Reviewed-by: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
