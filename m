Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:36430 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0CWWrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 18:47:08 -0400
Received: by fxm23 with SMTP id 23so2725372fxm.1
        for <linux-media@vger.kernel.org>; Tue, 23 Mar 2010 15:47:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BA91A44.4090709@oracle.com>
References: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
	 <4BA91A44.4090709@oracle.com>
Date: Tue, 23 Mar 2010 19:47:05 -0300
Message-ID: <499b283a1003231547k1e7f8060x53a4ea5ec43236d4@mail.gmail.com>
Subject: Re: [PATCH] Fix Warning ISO C90 forbids mixed declarations and code -
	cx88-dvb
From: Ricardo Maraschini <xrmarsx@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-media@vger.kernel.org, doug <dougsland@gmail.com>,
	mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

On Tue, Mar 23, 2010 at 4:45 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Did you test this patch (by building this driver)?
> I think not.

I tried to compile with the patch, but in a wrong way. Sorry.
I'm going to adjust the patch and send again.

> Also, the Signed-off-by: line should be before the patch, not after it.

Thanks, I will remember this.

-rm
