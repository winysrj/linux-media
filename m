Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:32991 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2LDQf2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 11:35:28 -0500
Received: by mail-vb0-f52.google.com with SMTP id ez10so921745vbb.11
        for <linux-media@vger.kernel.org>; Tue, 04 Dec 2012 08:35:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbwfV+9+k1ds0WK8KdEfrFncKuVS8U49Vde52-FEjDikSA@mail.gmail.com>
References: <1354637265-23335-1-git-send-email-mkrufky@linuxtv.org>
	<CAGoCfixR7oANQM4SoUBY1qpGt=Y4PedD85G+SXncg4ab9YiRng@mail.gmail.com>
	<CAOcJUbwfV+9+k1ds0WK8KdEfrFncKuVS8U49Vde52-FEjDikSA@mail.gmail.com>
Date: Tue, 4 Dec 2012 11:29:00 -0500
Message-ID: <CAGoCfiw2-_4uRjjBYpirXgqzOcb+d_jAybnFNuE8ZYDu8pdm3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] au0828: remove forced dependency of VIDEO_AU0828 on VIDEO_V4L2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 4, 2012 at 11:25 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Do you have any issues with these two patches as-is?  Any suggestions?
>  If not, is it OK with you if I request that Mauro merge this for v3.9
> ?

I have no specific issues with the patch as-is.

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
