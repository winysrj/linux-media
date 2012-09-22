Return-path: <linux-media-owner@vger.kernel.org>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:40513 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751818Ab2IVJCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 05:02:51 -0400
Message-ID: <505D7EB8.6060006@hoogenraad.net>
Date: Sat, 22 Sep 2012 11:02:48 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: media_build error on header file not present in old linux in
 ivtv-alsa-pcm.c
References: <20120819195423.8011935E0224@alastor.dyndns.org> <CAJL_dMuF1iDZ8vAXu7a0OFfozzKj31UOc-n6ZWWQGBxjTciTXQ@mail.gmail.com> <503149FC.5030501@iki.fi> <505C9388.8090500@hoogenraad.net> <505CBC2A.4010808@hoogenraad.net> <a6e2ffe6-8c39-40aa-80e7-8d2a13e5cefb@email.android.com>
In-Reply-To: <a6e2ffe6-8c39-40aa-80e7-8d2a13e5cefb@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks.

Ecxuse me for the previous mail. I could have searched the archive first:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/54099/match=printk+h

Andy Walls wrote:
> Jan Hoogenraad <jan-conceptronic@hoogenraad.net> wrote:
> 
>> I try to compile the media_build on an old Ubuntu Lucid system.
>> 2.6.32-42-generic-pae #96-Ubuntu SMP Wed Aug 15 19:12:17 UTC 2012 i686
>> GNU/Linux
>>
>> The make job stops with
>>
>> /home/jhh/dvb/media_build/v4l/ivtv-alsa-pcm.c:29:26: error:
>> linux/printk.h: No such file or directory
>> make[3]: *** [/home/jhh/dvb/media_build/v4l/ivtv-alsa-pcm.o] Error 1
>>
>> Apparently, this header file was not yet present in this version of
>> linux. It is the only driver requesting this header file.
>> Removing line 29
>>
>> #include <linux/printk.h>
>>
>> fixes the problem. All compiles well then.
>>
>>
>>
>> -- 
>> Jan Hoogenraad
>> Hoogenraad Interface Services
>> Postbus 2717
>> 3500 GS Utrecht
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hi Jan,
> 
> Hans Verkuil already noticed this and submitted a patch to remove the include.
> 
> Regards,
> Andy
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
