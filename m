Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZF3SoA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 14:44:00 -0400
Message-ID: <4A4A5D79.9080403@redhat.com>
Date: Tue, 30 Jun 2009 20:46:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: eric.paturage@orange.fr, linux-media@vger.kernel.org
Subject: Re: (very) wrong picture with sonixj driver and  0c45:6128
References: <200906291843.n5TIhoO04486@neptune.localwarp.net> <20090630124624.7c64a597@free.fr>
In-Reply-To: <20090630124624.7c64a597@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/30/2009 12:46 PM, Jean-Francois Moine wrote:
> On Mon, 29 Jun 2009 20:43:29 +0200 (CEST)
> eric.paturage@orange.fr wrote:
>> i am trying to use an "ngs skull" webcam with the gspca sonixj
>> driver . i enclose a screen copy , so one can see what what i mean :
>> the image is flatten vertically , there is 25% missing on the left .
>> and the color is all wrong , over-bright  . (no matter how much i try
>> to correct with v4l_ctl) the tests have been done with the latest
>> mercurial version of the v4l drivers (from sunday evening) on
>> 2.6.29.4 . I also tried it on 2 other computers (2.6.28.2 ) and
>> 2.6.27.4 . with sames results .
> 	[snip]
>> any idea what is going on ?
>>
>> I can provide more detailled log if needed , by setting the debug
>> param in gspca_main
>
> Hello Eric,
>
> Looking at the ms-win driver, it seems that the bridge is not the right
> one. May you try to change it? This is done in the mercurial tree
> editing the file:
>
> 	linux/drivers/media/video/gspca/sonixj.c
>
> and replacing the line 2379 from:
>
> {USB_DEVICE(0x0c45, 0x6128), BSI(SN9C110, OM6802, 0x21)}, /*sn9c325?*/
>
> to
>
> {USB_DEVICE(0x0c45, 0x6128), BSI(SN9C120, OM6802, 0x21)}, /*sn9c325*/
>                                       ~~~
>
> Don't forget to do 'make', 'make install' and 'rmmod gspca_sonixj'...
>

Hi,

I happen to own a cam with the same USB id myself, and it shows the same
issues as described by Eric. Changing the bridge id does not help I'm
afraid.

I'm afraid I don't have the time to fix this in the near future (it is on
my to do but no idea when I'll get around to it). But I'm more then willing
to test any fixes.

Regards,

Hans
