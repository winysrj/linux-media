Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab1KUMtm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 07:49:42 -0500
Message-ID: <4ECA48E3.8090705@redhat.com>
Date: Mon, 21 Nov 2011 10:49:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] initial support for HAUPPAUGE HVR-930C again...
References: <CAKdnbx5_qfotsKh0-s+DN7skx-J2=1HRw-qZOw=3mUHCQFHo2g@mail.gmail.com> <4EC8F94F.8090800@redhat.com> <CAKdnbx6Leux7+6h5FFRiay709ogwH6v34BCq=U7Qve8YwfA=VQ@mail.gmail.com> <CAKdnbx5XkDcCkbjYuEWP5wXG0yQFgqLhAuaJGW-v7C7oGCSG4Q@mail.gmail.com>
In-Reply-To: <CAKdnbx5XkDcCkbjYuEWP5wXG0yQFgqLhAuaJGW-v7C7oGCSG4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-11-2011 08:43, Eddi De Pieri escreveu:
> Attached the patch for for get_firmware
> 
> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
> 
> Regards,
> 
> Eddi

Applied, thanks. 

Did a quick test here with DVB-C and the HVR-930C firmware. It worked properly
with both scan and vlc.

Regards,
Mauro
