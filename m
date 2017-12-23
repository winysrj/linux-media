Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34628 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752688AbdLWSTk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Dec 2017 13:19:40 -0500
Received: by mail-vk0-f43.google.com with SMTP id j192so19093696vkc.1
        for <linux-media@vger.kernel.org>; Sat, 23 Dec 2017 10:19:40 -0800 (PST)
Received: from zooty (c-65-34-205-113.hsd1.fl.comcast.net. [65.34.205.113])
        by smtp.gmail.com with ESMTPSA id 137sm649459vkh.40.2017.12.23.10.19.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Dec 2017 10:19:38 -0800 (PST)
Received: from zooty (localhost [127.0.0.1])
        (Authenticated sender: tom)
        by zooty.my.lan (Postfix) with ESMTPA id 2EDC2140D08
        for <linux-media@vger.kernel.org>; Sat, 23 Dec 2017 13:19:37 -0500 (EST)
Date: Sat, 23 Dec 2017 13:19:36 -0500
From: Tom Horsley <horsley1953@gmail.com>
To: linux-media@vger.kernel.org
Subject: kernel 4.14 causes duplicate key presses
Message-ID: <20171223131936.70413e2a@zooty>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just submitted this redhat bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=1528754,
but I see the ir-keytable man page says send
bug reports here, so here I am :-).

When I updated my Intel NUC recently with
latest fedora 26 updates, I got a 4.14 kernel
and the next time I tried to use kodi after that,
all my remote key presses were duplicated.

I went back to the previous kernel (4.13) and
everything worked fine. More details can
be found in the bugzilla linked above.
