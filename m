Return-path: <mchehab@gaivota>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3164 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0L3L44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 06:56:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/4] [media] ivtv: Add Adaptec Remote Controller
Date: Thu, 30 Dec 2010 12:56:42 +0100
References: <cover.1293709356.git.mchehab@redhat.com> <20101230094509.2ecbf089@gaivota>
In-Reply-To: <20101230094509.2ecbf089@gaivota>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301256.42242.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday, December 30, 2010 12:45:09 Mauro Carvalho Chehab wrote:
> lirc-i2c implements a get key logic for the Adaptec Remote
> Controller, at address 0x6b. The only driver that seems to have
> an Adaptec device is ivtv:
> 
> $ git grep -i adaptec drivers/media
> drivers/media/video/cs53l32a.c: * cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver.
> drivers/media/video/cs53l32a.c: * Audio source switching for Adaptec AVC-2410 added by Trev Jackson
> drivers/media/video/cs53l32a.c:   /* Set cs53l32a internal register for Adaptec 2010/2410 setup */
> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2410 card */
> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0093 },
> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2410",
> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2010 card */
> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0092 },
> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2010",
> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2410         7 /* Adaptec AVC-2410 */
> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2010         8 /* Adaptec AVD-2010 (No Tuner) */
> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_PCI_ID_ADAPTEC                 0x9005
> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 8 = Adaptec AVC-2410\n"
> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 9 = Adaptec AVC-2010\n"
> drivers/media/video/ivtv/ivtv-i2c.c:              0x6b,   /* Adaptec IR */
> 
> There are two Adaptec cards defined there, but only one has tuner.
> I never found any device without tuners, but with a remote controllers, so
> the logic at lirc_i2c seems to be for Adaptec AVC-2410.

That's correct. The AVC-2010 does not come with a remote.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
