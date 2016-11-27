Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:33929 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbcK0OwR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Nov 2016 09:52:17 -0500
Received: by mail-wj0-f174.google.com with SMTP id mp19so95352811wjc.1
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2016 06:52:17 -0800 (PST)
Date: Sun, 27 Nov 2016 15:52:08 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: DVB: Unable to find symbol af9013_attach() (probably not a
 bug)
In-Reply-To: <alpine.LNX.2.20.1611211615270.4736@localhost.localdomain>
Message-ID: <alpine.LNX.2.20.1611271551370.1849@localhost.localdomain>
References: <alpine.LNX.2.20.1611211615270.4736@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello guys.
At the end the problem seems related to the use of the CONFIG_TRIM_UNUSED_KSYMS option.
Now everything works fine.
Thanks,
Enrico
