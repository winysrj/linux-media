Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:36239 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdE3Iug (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 04:50:36 -0400
Received: by mail-ua0-f170.google.com with SMTP id j17so47332186uag.3
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 01:50:35 -0700 (PDT)
Received: from mail-ua0-f181.google.com (mail-ua0-f181.google.com. [209.85.217.181])
        by smtp.gmail.com with ESMTPSA id l41sm481087uai.10.2017.05.30.01.50.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 May 2017 01:50:34 -0700 (PDT)
Received: by mail-ua0-f181.google.com with SMTP id j17so47331938uag.3
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 01:50:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c86b05d8-2278-5bf2-4836-75d57ad326fb@samsung.com>
References: <20170425061943.717-1-acourbot@chromium.org> <14d0d257-a5c3-222e-137d-4991482c6fb4@gmail.com>
 <CAPBb6MV6YCARzwkvXoxtCFYuZkM1-TzR_BRY6xH1qpzs+vAEuQ@mail.gmail.com>
 <ad2fc73b-0709-f5d3-04c0-658974e2eb21@gmail.com> <CAPBb6MV+MTuYPFUxfgK6hkrXKXYUz-Jc6iPES9E3jQyQJ9gNCg@mail.gmail.com>
 <CGME20170530083004epcas1p22ffe80b6a9442bcd3a6fb0b02381759f@epcas1p2.samsung.com>
 <f284a17b-2dee-a417-d361-0ecb4762b54c@gmail.com> <c86b05d8-2278-5bf2-4836-75d57ad326fb@samsung.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 30 May 2017 17:50:13 +0900
Message-ID: <CAPBb6MUwDj0OJYiETkyWe+T_VurG_K_um-8s9n8QEXF3iHgT7A@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-jpeg: fix recursive spinlock acquisition
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 30, 2017 at 5:30 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi,
>
> On 05/29/2017 09:08 PM, Jacek Anaszewski wrote:
>>
>> This patch seems to have lost somehow. Could you help merging it?
>
>
> It's not lost, it has been on my todo queue. I have applied it now.

Awesome, thanks!
