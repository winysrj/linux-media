Return-path: <mchehab@pedra>
Received: from psmtp04.wxs.nl ([195.121.247.13]:35402 "EHLO psmtp04.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab0HZTyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 15:54:22 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L7R002EYZAIFP@psmtp04.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 26 Aug 2010 21:54:21 +0200 (MEST)
Date: Thu, 26 Aug 2010 21:54:10 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: HG has errors on kernel 2.6.32
In-reply-to: <4C768B43.9080403@holzeisen.de>
To: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Thomas Holzeisen <thomas@holzeisen.de>
Message-id: <4C76C662.3070003@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4C1D1228.1090702@holzeisen.de> <4C5BA16C.7060808@hoogenraad.net>
 <5a5511b4767b245485b150836b1526f0.squirrel@holzeisen.de>
 <4C760DBC.5000605@hoogenraad.net> <4C768B43.9080403@holzeisen.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Douglas:

I see on that
http://www.xs4all.nl/~hverkuil/logs/Thursday.log
that building linux-2.6.32 yields ERRORS

skip_spaces has only been included in string.h starting from linux-2.6.33.

Should I have a look on how to fix this, or do you want to do this ?

--

second request: can we do some small changes to avoid the compiler 
warnings ?

include the line
         rc=0;
at line 187 of linux/drivers/media/IR/ir-raw-event.c


and change
static  void jpeg_set_qual(u8 *jpeg_hdr,
into
static __attribute__ (( unused )) void jpeg_set_qual(u8 *jpeg_hdr,

at line 152 of linux/drivers/media/video/gspca/jpeg.h

Yours,
		Jan

Thomas Holzeisen wrote:
> Hi Jan,
> 
> this looks great. At first the checkout did not build throwing me this 
> error:
> 
>> /usr/src/rtl2831-r2/v4l/ir-sysfs.c: In function 'store_protocols':
>> /usr/src/rtl2831-r2/v4l/ir-sysfs.c:137: error: implicit declaration of 
>> function 'skip_spaces'
>> /usr/src/rtl2831-r2/v4l/ir-sysfs.c:137: warning: assignment makes 
>> pointer from integer without a cast
>> /usr/src/rtl2831-r2/v4l/ir-sysfs.c:178: warning: assignment makes 
>> pointer from integer without a cast
> 
> i replaced the file by an older version from a previous checkout and 
> then it build perfectly. It also gets initialized without a flaw:
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
