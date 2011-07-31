Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:46995 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1GaO3l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 10:29:41 -0400
Message-ID: <4E3566B7.5020405@mailbox.hu>
Date: Sun, 31 Jul 2011 16:29:11 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
References: <4E32EE71.4030908@redhat.com>	<4E33C426.50000@mailbox.hu> <CAGoCfiw0f1puvj33eOHsh8bqVP-EgOUwCPQigF3u5gTEry839Q@mail.gmail.com>
In-Reply-To: <CAGoCfiw0f1puvj33eOHsh8bqVP-EgOUwCPQigF3u5gTEry839Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2011 03:53 PM, Devin Heitmueller wrote:

> Sorry about the top post.  Replying from phone since i'm on vacation.
>
> Haven't tested the firmware, but as long as it's based on the Xceive
> sources it's ok to redistribute in terms of licensing.  Just use the
> same license I provided for the original firmware.

I have uploaded the firmware package to here:
   http://juropnet.hu/~istvan_v/xc4000_firmware.tar.gz
Simply running "make" should compile the utility and create the
firmware file (dvb-fe-xc4000-1.4.fw). The package includes some files
that are not actually needed, for building the version 1.4 firmware
from the official sources, it is enough to have build_fw.c and the
two header files it depends on. I did not change any license
information, although the source files did not include it originally,
so that may still need to be added from here:
   http://www.kernellabs.com/firmware/xc4000/README.xc4000

For completeness, here is the original version of build_fw.c for
comparison, and the original firmware SDK (I have modified one of
the header files to fix a compile error):
   http://juropnet.hu/~istvan_v/build_fw.c
   http://juropnet.hu/~istvan_v/Xc4000_c_code.zip
