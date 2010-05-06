Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f199.google.com ([209.85.221.199]:34016 "EHLO
	mail-qy0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0EFMkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 08:40:14 -0400
Received: by mail-qy0-f199.google.com with SMTP id 37so2171477qyk.22
        for <linux-media@vger.kernel.org>; Thu, 06 May 2010 05:40:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f8f6b7c78cd8469f838fc084573dbe8b.squirrel@webmail.ovh.net>
References: <f8f6b7c78cd8469f838fc084573dbe8b.squirrel@webmail.ovh.net>
Date: Thu, 6 May 2010 08:40:13 -0400
Message-ID: <i2h83bcf6341005060540sb9e841d2jbf1f8f8c81bd9bb9@mail.gmail.com>
Subject: Re: [PATCH] dvb_frontend: fix typos in comments and one function
From: Steven Toth <stoth@kernellabs.com>
To: guillaume.audirac@webag.fr
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 6, 2010 at 8:30 AM, Guillaume Audirac
<guillaume.audirac@webag.fr> wrote:
> Hello,
>
> Trivial patch for typos.

Thanks Guillaume.

I've had an open TDA10048 bug on my list for quite a while, I think
you've already made reference to this in an earlier email. Essentially
I'm told my a number of Australian users that the 10048 isn't
broad-locking when tuned +- 167Khz away from the carrier, which it
should definitely do. If you're in the mood for patching the 10048 and
want to find and flip the broad-locking bit then I'd be certainly
thrilled to test this. :)

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
