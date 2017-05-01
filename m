Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42833
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750760AbdEARyc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 May 2017 13:54:32 -0400
Date: Mon, 1 May 2017 14:54:25 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] em28xx: allow setting the eeprom bus at cards
 struct
Message-ID: <20170501145425.10388b37@vento.lan>
In-Reply-To: <2431f8bf-1bbd-ffa6-1e72-488c31c9c2a7@googlemail.com>
References: <05c4899146e7f2cfa1d0bc7a5118e3f2294ede40.1493638682.git.mchehab@s-opensource.com>
        <2431f8bf-1bbd-ffa6-1e72-488c31c9c2a7@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

Em Mon, 1 May 2017 16:11:51 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 01.05.2017 um 13:38 schrieb Mauro Carvalho Chehab:
> > Right now, all devices use bus 0 for eeprom. However, newer
> > versions of Terratec H6 use a different buffer for eeprom.
> >
> > So, add support to use a different I2C address for eeprom.  
> 
> Has this been tested ?
> Did you read my reply to the previous patch version ?:
> See http://www.spinics.net/lists/linux-media/msg114860.html
> 
> I doubt it will work. At least not for the device from the thread in the
> Kodi-forum.

Yes. Someone at IRC were complaining about this device (his nick is
buxy81). According with the tests he did, with both patches his
device is now working.

That's said, it would be great if he could provide us more details
about the tests he did, with the logs enabled, in order for us to see
if the eeprom contents is properly read.


Thanks,
Mauro
