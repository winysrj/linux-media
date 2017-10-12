Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:41080 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753691AbdJLXHW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 19:07:22 -0400
Subject: Re: [PATCH] build: Add bsearch if not defined
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1507849268-31034-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <c8dc01df-e618-1115-15e3-aeac64dcc59a@anw.at>
Date: Fri, 13 Oct 2017 01:07:17 +0200
MIME-Version: 1.0
In-Reply-To: <1507849268-31034-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Even with this patch Kernel 2.6.x still can't be compiled due to
the next error "ida_simple_get" missing.
I will try to fix the "ida_simple_get" error tomorrow.

BR,
   Jasmin
