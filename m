Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:9809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1ABKlh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jan 2011 05:41:37 -0500
Message-ID: <4D20565B.9090307@redhat.com>
Date: Sun, 02 Jan 2011 08:41:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: RFC: Move the deprecated et61x251 and sn9c102 to staging
References: <201101012053.00372.hverkuil@xs4all.nl>
In-Reply-To: <201101012053.00372.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 01-01-2011 17:53, Hans Verkuil escreveu:
> The subject says it all:
> 
> If there are no objections, then I propose that the deprecated et61x251 and
> sn9c102 are moved to staging for 2.6.38 and marked for removal in 2.6.39.

Nack.

There are several USB ID's on sn9c102 not covered by gspca driver yet.

It seems to me that et61x251 will also stay there for a long time, as there are
just two devices supported by gspca driver, while et61x251 supports 25.

Btw, we currently have a conflict with this USB ID:
	USB_DEVICE(0x102c, 0x6151),

Both etoms and et61x251 support it, and there's no #if to disable it on one
driver, if both drivers are compiled. We need to disable it either at gspca_etoms
or at et61x251, in order to avoid users of having a random experience with this
device.

> 
> If there are no objections, then I'll make a patch for this.
> 
> Regards,
> 
> 	Hans
> 
Cheers,
Mauro
