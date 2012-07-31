Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57493 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab2GaLFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 07:05:48 -0400
Received: by wibhm11 with SMTP id hm11so2758575wib.1
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2012 04:05:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr2+y5emMuvKR0nLdQR=GtUOZ6Ms7j65bO5iXB8jJw0L4Q@mail.gmail.com>
References: <1343295404-8931-1-git-send-email-javier.martin@vista-silicon.com>
	<50170DE0.2030007@redhat.com>
	<CACKLOr2+y5emMuvKR0nLdQR=GtUOZ6Ms7j65bO5iXB8jJw0L4Q@mail.gmail.com>
Date: Tue, 31 Jul 2012 13:05:46 +0200
Message-ID: <CACKLOr3A+P0kbqKJW4v3yfh3dB6cuofhLHMEOKpSCbDX6gzzZQ@mail.gmail.com>
Subject: Re: "[PULL] video_visstrim for 3.6"
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
just in case Sascha's ACK doesn't make it on time. Could you just
merge the following  patches and drop the rest?
.
      media: coda: Add driver for Coda video codec.
      media: Add mem2mem deinterlacing driver.

We did a great effort to push Coda driver for 3.6 and it would be a
pity we finally missed that deadline.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
