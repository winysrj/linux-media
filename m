Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:36508 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3CYOiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 10:38:08 -0400
Received: by mail-qc0-f181.google.com with SMTP id a22so2683947qcs.40
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 07:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303251232.31456.hverkuil@xs4all.nl>
References: <201303251232.31456.hverkuil@xs4all.nl>
Date: Mon, 25 Mar 2013 10:38:07 -0400
Message-ID: <CAGoCfiyXLTQV_baP9QF6nsF2z3w3+cQu0YiuHz8OmHLgzc8Pmw@mail.gmail.com>
Subject: Re: [REVIEW PATCH] tuner-core fix for au0828 g_tuner bug
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 25, 2013 at 7:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> This fixes the bug where the au8522 detected a signal and then tuner-core
> overwrote it with 0 since the xc5000 tuner does not support get_rf_strength.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Nice find.  That makes much more sense.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
