Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42406 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZCQVlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 17:41:16 -0400
Subject: Re: [PATCH] radio-mr800.c: Missing mutex include
From: Alexey Klimov <klimov.linux@gmail.com>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
In-Reply-To: <1237323618-6464-1-git-send-email-abogani@texware.it>
References: <1237323618-6464-1-git-send-email-abogani@texware.it>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 00:42:08 +0300
Message-Id: <1237326128.2141.17.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-17 at 22:00 +0100, Alessio Igor Bogani wrote:
> radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> pulled in indirectly by one of the headers it already includes, the
> right thing is to include it directly.


Hello, Alessio

Patch looks okay for my eyes.
If it useful it should be applied.

Thank you!

Mauro, if patch is okay please apply it.
If you need my ack - here it is:
Acked-by: Alexey Klimov <klimov.linux@gmail.com>

-- 
Best regards, Klimov Alexey

