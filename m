Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7739Cb1014041
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 23:09:12 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7738wN0029296
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 23:08:59 -0400
Received: by ti-out-0910.google.com with SMTP id 24so178689tim.7
	for <video4linux-list@redhat.com>; Wed, 06 Aug 2008 20:08:58 -0700 (PDT)
From: Worik <worik.stanton@gmail.com>
To: Eddi De Pieri <eddi@depieri.net>
In-Reply-To: <1218052304.7377.1.camel@localhost>
References: <1205053694.6188.312.camel@gloria.red.sld.cu>
	<1217992008.8094.17.camel@kupe>  <1218052304.7377.1.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 07 Aug 2008 15:08:45 +1200
Message-Id: <1218078525.7497.2.camel@kupe>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Setting up a Xceive XC2028
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 2008-08-06 at 21:51 +0200, Eddi De Pieri wrote: 
> > worik@kupe:~/src/v4l-dvb$ hg clone http://linuxtv.org/hg/tm6010
> > tm6010-upstream 
> > abort: 'http://linuxtv.org/hg/tm6010' does not appear to be an hg
> > repository!
> 
> The right url should be http://linuxtv.org/hg/~mchehab/tm6010/

Cool.  Got that going...

So given the recipe I am blindly following...

﻿I have a stock Debian 2.6.24 kernel. This is what I did:

1. hg clone http://.../v4l-dvb v4l-dvb-upstream
2. hg clone http://.../tm6010 tm6010-upstream
3. hg clone v4l-dvb-upstream v4l-dvb
4. cd v4l-dvb
5. hg fetch ../tm6010-upstream
   (some minor issues with file 
    linux/drivers/media/video/tuner-xc2028.c during merge)
6. make && sudo make install

The sudo make install fails as the current directory is incorrect. So cd
v4l-dvb and run it from there.

It fails in (I believe) v4l/Makefile.media on line 546 when it calls
strip 


media-install::
	@echo "Stripping debug info from files " 
	@echo $(inst-m)
	@strip --strip-debug $(inst-m)


There is nothing in inst-m

So I stick...

cheers
Worik




> However good luck
> 
> Eddi
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
