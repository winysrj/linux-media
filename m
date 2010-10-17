Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59775 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab0JQUZa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 16:25:30 -0400
Received: by ewy20 with SMTP id 20so462149ewy.19
        for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 13:25:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CBB584B.1030905@redhat.com>
References: <20100806114248.GA29247@emard.lan>
	<20100810215718.GB27972@emard.lan>
	<4CBB584B.1030905@redhat.com>
Date: Sun, 17 Oct 2010 22:25:28 +0200
Message-ID: <AANLkTikL1qst7LxPgRVxFpfk5wUfSfaS9C3c_6KVpPjV@mail.gmail.com>
Subject: Re: Avermedia dvb-t hybrid A188
From: Luca Tettamanti <kronos.it@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Davor Emard <davoremard@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 17, 2010 at 10:10 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> I'm not sure why, but there are two drivers for saa716x chips, one out of the tree
> (never submitted upstream), and the otherone that were submited and is already merged
> at the kernel tree.
>
> The patch you've done is for the other driver. So, I can't apply it. If you want
> to base it in the top of the driver found at the kernel tree, at
> drivers/media/video/saa7164/, I can apply it.

Unless I'm mistaken this driver cannot handle the SAA7162; AFAIK they
are two very different chips.

Luca
