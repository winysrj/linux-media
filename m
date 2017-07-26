Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34831 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdGZSPI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 14:15:08 -0400
Received: by mail-wm0-f52.google.com with SMTP id c184so85825678wmd.0
        for <linux-media@vger.kernel.org>; Wed, 26 Jul 2017 11:15:08 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Gregor Jasny <gjasny@googlemail.com>
Subject: Problems pushing to v4l-utils
Message-ID: <d62e6cc4-9538-1431-e269-91f777b754e7@googlemail.com>
Date: Wed, 26 Jul 2017 20:15:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro & list,

I'm having problems to push to v4l-utils:

Did the setup recently change?

gjasny@sid:~/src/v4l-utils$ git remote -v
origin	git://linuxtv.org/v4l-utils.git (fetch)
origin	git://linuxtv.org/v4l-utils.git (push)

gjasny@sid:~/src/v4l-utils$ git push -v
Pushing to git://linuxtv.org/v4l-utils.git
Looking up linuxtv.org ... done.
Connecting to linuxtv.org (port 9418) ... 130.149.80.248 done.
fatal: remote error: access denied or repository not exported:
/v4l-utils.git

The SSH key is working and I can access the shell on linuxtv.org.

Thanks,
Gregor
