Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:45551 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751066AbdHXAHm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 20:07:42 -0400
Subject: Re: [PATCH] [media_build] rc: Fix ktime erros in rc_ir_raw.c
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: d.scheller@gmx.net, Sean Young <sean@mess.org>
References: <1503531988-15429-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <9b070969-9422-b809-3611-648d8da0e121@anw.at>
Date: Thu, 24 Aug 2017 02:07:37 +0200
MIME-Version: 1.0
In-Reply-To: <1503531988-15429-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Just some notes on that patch.

I have *not* tested it due to the lack of an ir remote control. So someone
needs to test this on an <= 4.9 Kernel, if the ir core is still working as
expected.

Even if I fixed that in media_build, it may be better to apply this code change
in media_tree. This because the involved variables are all of type ktime_t and
there are accessor and converter functions available for that type, which
should have been used by the original author of 86fe1ac0d and 48b2de197 in my
opinion.

BR,
   Jasmin
