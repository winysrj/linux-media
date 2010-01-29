Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55665 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab0A2RQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 12:16:59 -0500
Received: by bwz27 with SMTP id 27so1635742bwz.21
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 09:16:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B6306AA.8000103@googlemail.com>
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>
	 <4B62A967.3010400@googlemail.com>
	 <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com>
	 <4B62F048.1010506@googlemail.com>
	 <4B62F620.6020105@barber-family.id.au>
	 <4B6306AA.8000103@googlemail.com>
Date: Fri, 29 Jan 2010 12:16:57 -0500
Message-ID: <829197381001290916m4eeb9271x1c858d6a6d0b9b3b@mail.gmail.com>
Subject: Re: Make failed - standard ubuntu 9.10
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Henig <dhhenig@googlemail.com>
Cc: Francis Barber <fedora@barber-family.id.au>,
	leandro Costantino <lcostantino@gmail.com>,
	=?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 29, 2010 at 11:02 AM, David Henig <dhhenig@googlemail.com> wrote:
> Thanks, I appear to have the headers and no longer have to do the symlink,
> but still getting the same error - any help gratefully received, or do I
> need to get a vanilla kernel?

Open up the file v4l/.config and change the line for firedtv from "=m"
to "=n".  Then run "make".

This is a known packaging bug in Ubuntu's kernel headers.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
