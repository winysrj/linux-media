Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:44943 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZI1PYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 11:24:11 -0400
Received: by bwz6 with SMTP id 6so1339211bwz.37
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 08:24:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC0D05D.4060304@gmail.com>
References: <4AC0D05D.4060304@gmail.com>
Date: Mon, 28 Sep 2009 11:24:13 -0400
Message-ID: <829197380909280824q487c3effp64914d8430f16092@mail.gmail.com>
Subject: Re: [PATCH 2/2] em28xx: Convert printks to em28xx_err and em28xx_info
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: rosset.filipe@gmail.com
Cc: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 28, 2009 at 11:03 AM, Filipe Rosset <rosset.filipe@gmail.com> wrote:
>

You should use the em28xx_errdev() instead of em28xx_err() if your
intent is to insert "dev->name" in front of the message.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
