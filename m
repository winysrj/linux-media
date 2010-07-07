Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33178 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab0GGWTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 18:19:25 -0400
Received: by fxm14 with SMTP id 14so67075fxm.19
        for <linux-media@vger.kernel.org>; Wed, 07 Jul 2010 15:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274978356-25836-1-git-send-email-david@identd.dyndns.org>
References: <1274978356-25836-1-git-send-email-david@identd.dyndns.org>
Date: Wed, 7 Jul 2010 18:19:21 -0400
Message-ID: <AANLkTilEe37y6jG5cO7XGdcQMcbLxcojMQbk2Ld5Cwrw@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 0/8] dsbr100: driver cleanup and fixes
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

Mauro,

This series has not received any comments and the original author
seems to have abandoned this driver. Please review these patches for
approval. All changes are relatively straight forward. The second
patch in this series is a bug fix for the normal case where the device
is unplugged while closed. The current implementation will cause a
NULL pointer dereference. The fact that no one has reported this bug
is probably due to the lack of people using this driver. The rest of
the changes mainly provide general cleanups and reduced overhead.

Regards,

David Ellingsworth
