Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55655 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0INO4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 10:56:44 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so5565702bwz.19
        for <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 07:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274978356-25836-1-git-send-email-david@identd.dyndns.org>
References: <1274978356-25836-1-git-send-email-david@identd.dyndns.org>
Date: Tue, 14 Sep 2010 10:56:43 -0400
Message-ID: <AANLkTi=QujvRkdSLBMm14ZpOy2GCk8Ow3d87FAAz6GGY@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 0/8] dsbr100: driver cleanup and fixes
From: David Ellingsworth <david@identd.dyndns.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Alexey Klimov <klimov.linux@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Alexey,

Can you review/test this patch series? Patches 2/8, 3/8, and 5/8 are
bug fixes the rest are mainly cleanups. Patch 2/8 should fix a crash
in the normal case if the device is disconnected while not in use.

Regards,

David Ellingsworth

On Thu, May 27, 2010 at 12:39 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> This patch series addresses several issues in the dsbr100 driver.
> This series is based on the v4l-dvb master git branch and has been
> compile tested only. It should be tested before applying.
>
> This is the second version of this series. An additional patch has
> been added to cleanup/clarify the return values from dsbr100_start
> and dsbr100_stop.
>
> The following patches are included in this series:
>   [PATCH/RFC v2 1/8] dsbr100: implement proper locking
>   [PATCH/RFC v2 2/8] dsbr100: fix potential use after free
>   [PATCH/RFC v2 3/8] dsbr100: only change frequency upon success
>   [PATCH/RFC v2 4/8] dsbr100: remove disconnected indicator
>   [PATCH/RFC v2 5/8] dsbr100: cleanup return value of start/stop handlers
>   [PATCH/RFC v2 6/8] dsbr100: properly initialize the radio
>   [PATCH/RFC v2 7/8] dsbr100: cleanup usb probe routine
>   [PATCH/RFC v2 8/8] dsbr100: simplify access to radio device
>
> Regards,
>
> David Ellingsworth
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
