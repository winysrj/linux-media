Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59409 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0CDBG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 20:06:58 -0500
Received: by fxm19 with SMTP id 19so2250626fxm.21
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 17:06:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>
	 <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>
	 <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
Date: Wed, 3 Mar 2010 20:06:55 -0500
Message-ID: <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes
	interference with USB soundcard
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 3, 2010 at 8:00 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
> Its working very well, thanks.
>
> Can you please tell me if its going to be pushed to .33 stable? And
> should I close the kernel bug?

It's in Mauro's PULL request for 2.6.34-rc1.  It's marked "normal"
priority so it likely won't get pulled into stable.  It was a
non-trivial restructuring of the code, so doing a minimal fix that
would be accepted by stable is unlikely.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
