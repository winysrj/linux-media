Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43713 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934213AbdKPLg2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 06:36:28 -0500
Received: by mail-lf0-f68.google.com with SMTP id x68so5786180lff.0
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 03:36:27 -0800 (PST)
Subject: Re: [PATCH 2/2] dvbv5-daemon: 0 is a valid fd
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
References: <20171115113336.3756-1-funman@videolan.org>
 <20171115113336.3756-2-funman@videolan.org>
 <20171116092509.7b521fbe@vento.lan>
From: =?UTF-8?B?UmFmYcOrbCBDYXJyw6k=?= <funman@videolan.org>
Message-ID: <7f84667f-ef2c-03b5-db09-c932d270c343@videolan.org>
Date: Thu, 16 Nov 2017 12:36:24 +0100
MIME-Version: 1.0
In-Reply-To: <20171116092509.7b521fbe@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/11/2017 12:25, Mauro Carvalho Chehab wrote:
> Em Wed, 15 Nov 2017 12:33:36 +0100
> Rafaël Carré <funman@videolan.org> escreveu:
> 
>> ---
>>  utils/dvb/dvbv5-daemon.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/utils/dvb/dvbv5-daemon.c b/utils/dvb/dvbv5-daemon.c
>> index 58485ac6..711694e0 100644
>> --- a/utils/dvb/dvbv5-daemon.c
>> +++ b/utils/dvb/dvbv5-daemon.c
>> @@ -570,7 +570,7 @@ void dvb_remote_log(void *priv, int level, const char *fmt, ...)
>>  
>>  	va_end(ap);
>>  
>> -	if (fd > 0)
>> +	if (fd >= 0)
>>  		send_data(fd, "%i%s%i%s", 0, "log", level, buf);
>>  	else
>>  		local_log(level, buf);

Signed-off-by: Rafaël Carré <funman@videolan.org>

> 
> Patch looks OK. Just need a description explaining why we
> need to consider fd == 0 and a SOB.

Sorry, I am not used to do sign-off, will try to remember.

fd == 0 can happen if the application closes stdin/out/err then opens a
new fd.

Should I put this in the commit log?

> Thanks,
> Mauro
> 
