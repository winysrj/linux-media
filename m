Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53828 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZIFH44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2009 03:56:56 -0400
Received: by fxm17 with SMTP id 17so1436973fxm.37
        for <linux-media@vger.kernel.org>; Sun, 06 Sep 2009 00:56:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ef96b78e0909060021r770966f5v93d86f44bb844d4@mail.gmail.com>
References: <ef96b78e0909051137w188ef6ddw75f8c595e4498f0@mail.gmail.com>
	 <ef96b78e0909052355q71f1f2ddudbc787bbffec39e1@mail.gmail.com>
	 <ef96b78e0909060021r770966f5v93d86f44bb844d4@mail.gmail.com>
Date: Sun, 6 Sep 2009 09:56:58 +0200
Message-ID: <ef96b78e0909060056w36a495f6taa4887e5b42469de@mail.gmail.com>
Subject: Re: Hauppauge HVR 1110 : recognized but doesn't work
From: Morvan Le Meut <mlemeut@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/6 Morvan Le Meut <mlemeut@gmail.com>:
> i wonder why mythtv can't use that card when the scan utility can.
> (yes, i checked what card the scan utility use )
>

confirmed with mplayer, the card works but not with mythtv ( got some
"DVB: adapter 0 frontend 0 frequency 4294967286 out of range
(177000000..858000000)" in demsg )
