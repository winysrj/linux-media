Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab0BBMRw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 07:17:52 -0500
Message-ID: <4B6817E6.4070709@redhat.com>
Date: Tue, 02 Feb 2010 10:17:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de
Subject: Re: [PATCH v2 00/10] add linux driver for chip TLG2300
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
In-Reply-To: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> The TLG2300 is a chip of Telegent System.
> It support analog tv,DVB-T and radio in a single chip.
> The chip has been used in several dongles, such as aeromax DH-9000:
> 	http://www.b2bdvb.com/dh-9000.htm
> 
> You can get more info from:
> 	[1] http://www.telegent.com/
> 	[2] http://www.telegent.com/press/2009Sept14_CSI.html
> 
> The driver is based Mauro's subtree(2.6.33-rc4).	
> 	
> about country code:
> 	The country code is needed for firmware, so I can not remove it.
> 	If I remove it, the audio will not work properly.

I'm assuming that you're referring to the analog part, right? 

Instead of a country code, the driver should use the V4L2_STD_ macros to
determine the audio standard. Please take a look at saa7134-tvaudio code. It has
an interesting logic to associate the V4L2_STD with the corresponding audio settings:

For example, the audio carrier frequency and the audio standard are at tvaudio array:

static struct saa7134_tvaudio tvaudio[] = {
        {
                .name          = "PAL-B/G FM-stereo",
                .std           = V4L2_STD_PAL_BG,
                .mode          = TVAUDIO_FM_BG_STEREO,
                .carr1         = 5500,
                .carr2         = 5742,
        },{
                .name          = "PAL-D/K1 FM-stereo",
                .std           = V4L2_STD_PAL_DK,
                .carr1         = 6500,
                .carr2         = 6258,
                .mode          = TVAUDIO_FM_BG_STEREO,
        },{
                .name          = "PAL-D/K2 FM-stereo",
                .std           = V4L2_STD_PAL_DK,
                .carr1         = 6500,
                .carr2         = 6742,
                .mode          = TVAUDIO_FM_BG_STEREO,
        },{
                .name          = "PAL-D/K3 FM-stereo",
                .std           = V4L2_STD_PAL_DK,
                .carr1         = 6500,
                .carr2         = 5742,
                .mode          = TVAUDIO_FM_BG_STEREO,
        },{
                .name          = "PAL-B/G NICAM",
                .std           = V4L2_STD_PAL_BG,
                .carr1         = 5500,
                .carr2         = 5850,
                .mode          = TVAUDIO_NICAM_FM,
        },{
                .name          = "PAL-I NICAM",
                .std           = V4L2_STD_PAL_I,
                .carr1         = 6000,
                .carr2         = 6552,
                .mode          = TVAUDIO_NICAM_FM,
        },{
                .name          = "PAL-D/K NICAM",
                .std           = V4L2_STD_PAL_DK,
                .carr1         = 6500,
                .carr2         = 5850,
                .mode          = TVAUDIO_NICAM_FM,
        },{
                .name          = "SECAM-L NICAM",
                .std           = V4L2_STD_SECAM_L,
                .carr1         = 6500,
                .carr2         = 5850,
                .mode          = TVAUDIO_NICAM_AM,
        },{
...
}

Btw, probably the most complicated device, in terms of firmware, is the xc3028. It has one
different firmware for each different combination of standard. There are 80 different firmwares
at the version 3.6. Each time a firmware changes, a reset via GPIO should be sent to the device.

The tuner-xc3028 has a logic that re-loads the firmware if the standard changes, and the 
new standard is not supported by the current firmware. So, it may help if you also take a
look at tuner-xc2028.

-- 

Cheers,
Mauro
