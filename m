Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40323 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0EDKC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 06:02:56 -0400
Received: by fxm10 with SMTP id 10so3019722fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 03:02:55 -0700 (PDT)
Date: Tue, 4 May 2010 12:02:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: akpm@linux-foundation.org, linux-media@vger.kernel.org,
	dtor@mail.ru
Subject: Re: [patch 10/11] ir-keytable: avoid double lock
Message-ID: <20100504100243.GS29093@bicker>
References: <201004272111.o3RLBQlk020008@imap1.linux-foundation.org> <4BDF5731.4040203@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDF5731.4040203@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 03, 2010 at 08:07:29PM -0300, Mauro Carvalho Chehab wrote:
> akpm@linux-foundation.org wrote:
> > From: Dan Carpenter <error27@gmail.com>
> > 
> > It's possible that we wanted to resize to a smaller size but we didn't
> > have enough memory to create the new table.  We need to test for that here
> > so we don't try to lock twice and dead lock.  Also we free the "oldkeymap"
> > on that path and that would be bad.
> 
> This patch doesn't apply anymore on my tree.
> 
> It probably conflicted with this one:
> 

Yup.  It's no longer needed.  Looks good.

regards,
dan carpenter


