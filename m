Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:45525 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZCLNUh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 09:20:37 -0400
Received: by qw-out-2122.google.com with SMTP id 5so438503qwi.37
        for <linux-media@vger.kernel.org>; Thu, 12 Mar 2009 06:20:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903121204.11647.zzam@gentoo.org>
References: <200903121204.11647.zzam@gentoo.org>
Date: Thu, 12 Mar 2009 09:20:32 -0400
Message-ID: <30353c3d0903120620w7b3d2a75ydf92e5ea08e8e509@mail.gmail.com>
Subject: Re: null pointer access in error path of lgdt3305 driver
From: David Ellingsworth <david@identd.dyndns.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 7:04 AM, Matthias Schwarzott <zzam@gentoo.org> wrote:
> Hi Michael!
>
> Looking at your new lgdt3305 driver, I noticed that the error path of
> lgdt3305_attach, that is also jumped to kzalloc errors, sets
> state->frontend.demodulator_priv to NULL.
>
> That will oops in case state is NULL. So you either need two goto labels for
> failures or just return in case kzalloc fails.

Patches welcomed. :-)

Regards,

David Ellingsworth
