Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53666 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FKRAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:00:01 -0400
Received: by ewy4 with SMTP id 4so1215060ewy.19
        for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 10:00:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106111753.21581.hverkuil@xs4all.nl>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
	<BANLkTikWiEb+aGGbSNSZ+YtdeVRB6QaJtg@mail.gmail.com>
	<201106111753.21581.hverkuil@xs4all.nl>
Date: Sat, 11 Jun 2011 13:00:00 -0400
Message-ID: <BANLkTi=gSXAgTfhU=cjJLaqD6EnDApL=kA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jun 11, 2011 at 11:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Do you happen to know not-too-expensive cards that you can buy that have
> this sort of tuners? It may be useful to be able to test this myself.

Anything with an xc3028 or xc5000 would have this issue.  I don't
really keep close track of current shipping DVB products, but the 3028
was definitely very chip in products from a couple of years ago.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
