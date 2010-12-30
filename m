Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:51736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab0L3MKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 07:10:01 -0500
Message-ID: <4D1C7690.3020907@redhat.com>
Date: Thu, 30 Dec 2010 10:09:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/4] [media] ivtv: Add Adaptec Remote Controller
References: <cover.1293709356.git.mchehab@redhat.com> <20101230094509.2ecbf089@gaivota> <201012301256.42242.hverkuil@xs4all.nl>
In-Reply-To: <201012301256.42242.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 30-12-2010 09:56, Hans Verkuil escreveu:
> On Thursday, December 30, 2010 12:45:09 Mauro Carvalho Chehab wrote:
>> lirc-i2c implements a get key logic for the Adaptec Remote
>> Controller, at address 0x6b. The only driver that seems to have
>> an Adaptec device is ivtv:
>>
>> $ git grep -i adaptec drivers/media
>> drivers/media/video/cs53l32a.c: * cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver.
>> drivers/media/video/cs53l32a.c: * Audio source switching for Adaptec AVC-2410 added by Trev Jackson
>> drivers/media/video/cs53l32a.c:   /* Set cs53l32a internal register for Adaptec 2010/2410 setup */
>> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2410 card */
>> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0093 },
>> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2410",
>> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2010 card */
>> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0092 },
>> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2010",
>> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2410         7 /* Adaptec AVC-2410 */
>> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2010         8 /* Adaptec AVD-2010 (No Tuner) */
>> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_PCI_ID_ADAPTEC                 0x9005
>> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 8 = Adaptec AVC-2410\n"
>> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 9 = Adaptec AVC-2010\n"
>> drivers/media/video/ivtv/ivtv-i2c.c:              0x6b,   /* Adaptec IR */
>>
>> There are two Adaptec cards defined there, but only one has tuner.
>> I never found any device without tuners, but with a remote controllers, so
>> the logic at lirc_i2c seems to be for Adaptec AVC-2410.
> 
> That's correct. The AVC-2010 does not come with a remote.

Thanks for double checking. I've replaced the comments to:

    [media] ivtv: Add Adaptec Remote Controller
    
    lirc-i2c implements a get key logic for the Adaptec Remote
    Controller, at address 0x6b. The only driver that seems to have
    an Adaptec device is ivtv:
    
    $ git grep -i adaptec drivers/media
    drivers/media/video/cs53l32a.c: * cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver.
    drivers/media/video/cs53l32a.c: * Audio source switching for Adaptec AVC-2410 added by Trev Jackson
    drivers/media/video/cs53l32a.c:   /* Set cs53l32a internal register for Adaptec 2010/2410 setup */
    drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2410 card */
    drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0093 },
    drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2410",
    drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2010 card */
    drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0092 },
    drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2010",
    drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2410         7 /* Adaptec AVC-2410 */
    drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2010         8 /* Adaptec AVD-2010 (No Tuner) */
    drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_PCI_ID_ADAPTEC                 0x9005
    drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 8 = Adaptec AVC-2410\n"
    drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 9 = Adaptec AVC-2010\n"
    drivers/media/video/ivtv/ivtv-i2c.c:              0x6b,   /* Adaptec IR */
    
    There are two Adaptec cards defined there, but AVC-2010 doesn't have a
    remote controller. So, the logic at lirc_i2c seems to be for Adaptec AVC-2410.
    
    As we'll remove lirc_i2c from kernel, move the getkey code to ivtv driver, and
    use it for AVC-2410.

I have no means to test the IR with AVC-2410, but I think it is safe to apply
this patch, if none of us have this device, as the patch is trivial, and this
allows us to remove i2c_adapter.id obsolete field and lirc_i2c, after applying
this series, and the tree patches for lirc_zilog that Andy made.

Cheers,
Mauro
