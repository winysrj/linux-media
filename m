Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f186.google.com ([209.85.210.186]:44087 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZFYScW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 14:32:22 -0400
Received: by yxe16 with SMTP id 16so191547yxe.33
        for <linux-media@vger.kernel.org>; Thu, 25 Jun 2009 11:32:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
Date: Thu, 25 Jun 2009 14:25:31 -0400
Message-ID: <829197380906251125t56fe49ccqee97eab659be9974@mail.gmail.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what
	am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: George Adams <g_adams27@hotmail.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I just spoke with mkrufky, and he confirmed the issue does occur with
the HVR-950.  However, the em28xx driver does not do a printk() when
the subdev registration fails (I will submit a patch to fix that).

Please let me know if you have any further question.

Thanks for your assistance,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
