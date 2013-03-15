Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:60160 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3COTWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 15:22:22 -0400
Received: by mail-qe0-f48.google.com with SMTP id 9so2123093qea.7
        for <linux-media@vger.kernel.org>; Fri, 15 Mar 2013 12:22:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d5e07f9e-2bc6-4684-b00e-ea8ffbd556b9@zimbra.mdabbs.org>
References: <CAGoCfixans=6fOCDivGFw1yauOp-J9mrg3G+ENV5B4a7j_FfZQ@mail.gmail.com>
	<d5e07f9e-2bc6-4684-b00e-ea8ffbd556b9@zimbra.mdabbs.org>
Date: Fri, 15 Mar 2013 15:22:18 -0400
Message-ID: <CAGoCfiwM4NKO8qhBswWmYDtMFyF0PkQ0S7k-rn=5vGooOD5y=w@mail.gmail.com>
Subject: Re: DVB memory leak?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Moasat <moasat@moasat.dyndns.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 15, 2013 at 2:45 PM, Moasat <moasat@moasat.dyndns.org> wrote:
> Thanks for looking into it.  It wouldn't surprise me to find out that Myth is not checking the error condition.  But even if it did, would that keep the card functioning?

No, it would not keep the card functioning.  But you would at least
not get zero length recordings and instead you would get an error that
something went wrong and that action was required.

The underlying problem of course is the leak - the fact that MythTV
doesn't tell you something went wrong just exacerbates the problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
