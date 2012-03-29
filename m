Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41708 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2C2HRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 03:17:20 -0400
Received: by vbbff1 with SMTP id ff1so1269515vbb.19
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2012 00:17:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJu-Zix22G3WbCCJ1h7P7+9naEU0XkYNDELTk9hCzMQ8UYB-gQ@mail.gmail.com>
References: <CAJu-Zix22G3WbCCJ1h7P7+9naEU0XkYNDELTk9hCzMQ8UYB-gQ@mail.gmail.com>
From: =?UTF-8?Q?Rafa=C5=82_Rzepecki?= <divided.mind@gmail.com>
Date: Thu, 29 Mar 2012 09:16:59 +0200
Message-ID: <CAJu-ZiykBizbXg=Oq1o-8TYX+CJjBYmZsFsHUFsKJ3BxVQrahQ@mail.gmail.com>
Subject: Re: Startup delay needed for a Sonix camera
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/29 Rafał Rzepecki <divided.mind@gmail.com>:
> I thought it looked like as though the camera hasn't got enough time
> to initialize, and indeed, adding an msleep(30) near the end of
> sd_start() in sonixj.c solved the problem.

Actually after some more research I've found that b4b01071379 has fixed it.
(Jean-François says in the commit message "This problem was introduced
by commit 0e4d413af1a9d and its exact effects are unknown." So I guess
they are known now.)
-- 
Rafał Rzepecki
