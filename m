Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:60073 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZFJXVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 19:21:34 -0400
Received: by an-out-0708.google.com with SMTP id d40so1914837and.1
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 16:21:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906101944.n5AJiIKQ031735@imap1.linux-foundation.org>
References: <200906101944.n5AJiIKQ031735@imap1.linux-foundation.org>
Date: Thu, 11 Jun 2009 03:21:36 +0400
Message-ID: <208cbae30906101621v6ba12fbbsf29c0d6ec35768d8@mail.gmail.com>
Subject: Re: [patch 1/6] radio-mr800.c: missing mutex include
From: Alexey Klimov <klimov.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	abogani@texware.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 10, 2009 at 11:44 PM, <akpm@linux-foundation.org> wrote:
> From: Alessio Igor Bogani <abogani@texware.it>
>
> radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> pulled in indirectly by one of the headers it already includes, the right
> thing is to include it directly.

It was already applied to v4l-dvb tree (and probably to v4l git tree).
Thanks,
-- 
regards, Klimov Alexey
