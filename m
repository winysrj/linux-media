Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41152 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0HBTqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 15:46:39 -0400
Received: by qyk11 with SMTP id 11so303231qyk.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 12:46:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100731235404.0bf29a3d@pedra>
References: <cover.1280630041.git.mchehab@redhat.com>
	<20100731235404.0bf29a3d@pedra>
Date: Mon, 2 Aug 2010 15:46:38 -0400
Message-ID: <AANLkTi=AJc3GqZc0XJkxME90jY-hkV+breiCoMobXKma@mail.gmail.com>
Subject: Re: [PATCH 3/7] V4L/DVB: dvb-usb: prepare drivers for using rc-core
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 31, 2010 at 10:54 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is a big patch, yet trivial. It just move the RC properties
> to a separate struct, in order to prepare the dvb-usb drivers to
> use rc-core. There's no change on the behavior of the drivers.
>
> With this change, it is possible to have both legacy and rc-core
> based code inside the dvb-usb-remote, allowing a gradual migration
> to rc-core, driver per driver.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
