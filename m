Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35156 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038097AbdDUL5g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 07:57:36 -0400
Received: by mail-io0-f181.google.com with SMTP id r16so111173307ioi.2
        for <linux-media@vger.kernel.org>; Fri, 21 Apr 2017 04:57:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP2KGU=779YZ6MutWgsdNc5zGEfAxJYeepWXq4x1zKEX0B62tg@mail.gmail.com>
References: <CAP2KGUmvsnWOE9t8uR5YQuGNptt8OcUmbALjB3pD6ChpA0tcug@mail.gmail.com>
 <CAP2KGU=779YZ6MutWgsdNc5zGEfAxJYeepWXq4x1zKEX0B62tg@mail.gmail.com>
From: Steven Toth <stoth@kernellabs.com>
Date: Fri, 21 Apr 2017 07:57:34 -0400
Message-ID: <CALzAhNVuKc8kXVQN5MiAannTK_1GwFqZLVvptcQbWyiborX0xQ@mail.gmail.com>
Subject: Re: HauppaugeTV-quadHD DVB-T mpeg risc op code errors
To: Adam Zegelin <adam@zegelin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Just a follow up on this. I had a bit more time to dig deeper into this today.
>
> Enabling debug output for the cx23885 driver *fixes* the issue.
>
> I added this to my kernel command line: cx23885.debug=8

The driver's been around a very long time and is very stable with
almost anything anyone has every added, or I originally added during
the early development. That being said..... this sounds like the quad
is producing some kind of race condition, or the PLX bridge is in
someway not as transparent as everyone would like.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
