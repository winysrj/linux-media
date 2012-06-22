Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63222 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762037Ab2FVNGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 09:06:11 -0400
Received: by bkcji2 with SMTP id ji2so1512643bkc.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 06:06:09 -0700 (PDT)
From: Federico Vaga <federico.vaga@gmail.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Recent patch for videobuf causing a crash to my driver
Date: Fri, 22 Jun 2012 15:09:41 +0200
Message-ID: <4260673.cPvW4zFeXm@harkonnen>
In-Reply-To: <CA+V-a8uDgmiy52wEs0rR5B08aAmSk=Wyf+e3mMzazeGykdMA4w@mail.gmail.com>
References: <CA+V-a8uDgmiy52wEs0rR5B08aAmSk=Wyf+e3mMzazeGykdMA4w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Has this patch being tested for 'uncached' buffers ?

I didn't test it on uncached buffers because I don't have the hardware.
The main development of the patches:

efeb98b4e2b2
a8f3c203e19b
bca7ad1a332a

was made by windriver people. I review their code an correct the bug 
that I found but I have only the STA2X11 board for testing.

I'll test your patch for uncached buffer on my cached buffer to test if 
it still work.

-- 
Federico Vaga
