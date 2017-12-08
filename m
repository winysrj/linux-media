Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:53538 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbdLHVGG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 16:06:06 -0500
Subject: Re: [PATCH] build: Added missing timer_setup_on_stack
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1512766859-7667-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <3343c1fd-d0f0-46b1-fd3f-150f36de6fa4@anw.at>
Date: Fri, 8 Dec 2017 22:06:02 +0100
MIME-Version: 1.0
In-Reply-To: <1512766859-7667-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans!

With this patch it compiles for Kernel 4.4, but not on 3.13. I will work on
that soon.

I am not sure if this patch keeps pvrusb2 working, but it compiles. I tried
first a solution by reverting 8da0edf2f90b6c74b69ad420fdd230c9bd2bd1ed. If you
prefer this, I have it on a branch and can submit it.

BR,
   Jasmin
