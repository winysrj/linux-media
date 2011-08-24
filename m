Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62136 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1HXRyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 13:54:35 -0400
Received: by bke11 with SMTP id 11so1087983bke.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 10:54:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314207232-6031-1-git-send-email-obi@linuxtv.org>
References: <1314207232-6031-1-git-send-email-obi@linuxtv.org>
Date: Wed, 24 Aug 2011 13:54:34 -0400
Message-ID: <CAGoCfizk8Ni96yJJq7Q=MGhH_-EgLskYd3SDMJ4w9mAdEPg1mg@mail.gmail.com>
Subject: Re: [PATCH 1/2] DVB: dvb_frontend: convert semaphore to mutex
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 24, 2011 at 1:33 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>

This may seem like a silly question, but *why* are you making this
change?  There is no explanation for what prompted it.  Is it in
response to some issue you encountered?

I'm asking because in general dvb_frontend has a fairly complicated
locking model, and unless there is a compelling reason to make changes
I would be against it.

In other words, this is a bad place for arbitrary "cleanup patches".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
