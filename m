Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47937 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934475AbdKPLre (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 06:47:34 -0500
Date: Thu, 16 Nov 2017 09:47:29 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: =?UTF-8?B?UmFmYcOrbCBDYXJyw6k=?= <funman@videolan.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] dvbv5-daemon: 0 is a valid fd
Message-ID: <20171116094729.1526db2f@vento.lan>
In-Reply-To: <7f84667f-ef2c-03b5-db09-c932d270c343@videolan.org>
References: <20171115113336.3756-1-funman@videolan.org>
        <20171115113336.3756-2-funman@videolan.org>
        <20171116092509.7b521fbe@vento.lan>
        <7f84667f-ef2c-03b5-db09-c932d270c343@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 16 Nov 2017 12:36:24 +0100
Rafaël Carré <funman@videolan.org> escreveu:

> On 16/11/2017 12:25, Mauro Carvalho Chehab wrote:
> > Em Wed, 15 Nov 2017 12:33:36 +0100
> > Rafaël Carré <funman@videolan.org> escreveu:
> >   
> >> ---
> >>  utils/dvb/dvbv5-daemon.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/utils/dvb/dvbv5-daemon.c b/utils/dvb/dvbv5-daemon.c
> >> index 58485ac6..711694e0 100644
> >> --- a/utils/dvb/dvbv5-daemon.c
> >> +++ b/utils/dvb/dvbv5-daemon.c
> >> @@ -570,7 +570,7 @@ void dvb_remote_log(void *priv, int level, const char *fmt, ...)
> >>  
> >>  	va_end(ap);
> >>  
> >> -	if (fd > 0)
> >> +	if (fd >= 0)
> >>  		send_data(fd, "%i%s%i%s", 0, "log", level, buf);
> >>  	else
> >>  		local_log(level, buf);  
> 
> Signed-off-by: Rafaël Carré <funman@videolan.org>
> 
> > 
> > Patch looks OK. Just need a description explaining why we
> > need to consider fd == 0 and a SOB.  
> 
> Sorry, I am not used to do sign-off, will try to remember.
> 
> fd == 0 can happen if the application closes stdin/out/err then opens a
> new fd.
> 
> Should I put this in the commit log?

For this one, no need. Next time, the best is to resend, as I usually
use patchwork also to pick the patches. Patchwork won't automatically
pick new patch descriptions.

> 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro
