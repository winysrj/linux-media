Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51938 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab0KPSwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 13:52:24 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Fwd: [PATH] Fix rc-tbs-nec table after converting the cx88 driver to ir-core
Date: Tue, 16 Nov 2010 10:52:02 -0800
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-input" <linux-input@vger.kernel.org>
References: <4CE2C1BD.5040402@redhat.com>
In-Reply-To: <4CE2C1BD.5040402@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161052.04424.dmitry.torokhov@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 09:39:09 am Mauro Carvalho Chehab wrote:
> Hi Dmitry,
> 
> This patch fixes an IR table. The patch is trivial, but there are two
> buttons on this IR that are not directly supported currently (buttons 10-
> and 10+). In a matter of fact, some other IR's use other key codes
> (KEY_DOT, KEY_KPPLUS, KEY_DIGITS) for a similar keyboard key (100+).
> 
> Mariusz is proposing the addition of two new keycodes for it. What do you
> think?
> 

Sure, why not. Just move them over to 0x1b8 please (somewhat 'closer' to
other media keys).

Thanks.

-- 
Dmitry
