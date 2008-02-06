Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m16M4K5G003704
	for <video4linux-list@redhat.com>; Wed, 6 Feb 2008 17:04:20 -0500
Received: from mailout04.sul.t-online.com (mailout04.sul.t-online.de
	[194.25.134.18])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m16M3nCd025895
	for <video4linux-list@redhat.com>; Wed, 6 Feb 2008 17:03:49 -0500
Message-ID: <47AA2EBD.2050900@t-online.de>
Date: Wed, 06 Feb 2008 23:03:41 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <E1JMMVt-000Lwk-00.yurifun-mail-ru@f43.mail.ru>
	<1202258883.4261.28.camel@pc08.localdom.local>
In-Reply-To: <1202258883.4261.28.camel@pc08.localdom.local>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Yuri Fundurian <yurifun@mail.ru>, v4l-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 2.6.24 1/1] saa7134: fix fm-radio
 pinnacle pctv 110i
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

Hi

hermann pitton schrieb:
> Hi,
> 
> Am Dienstag, den 05.02.2008, 15:02 +0300 schrieb Yuri Fundurian:
>> This patch for fm-radio on pinnacle pctv 110i.
>> Without this patch fm-radio doesn't work.
>>
>> --- /usr/src/kernels/2.6.24/drivers/media/video/saa7134/saa7134-cards.c 2008-01-25 03:58:37.000000000 +0500
>> +++ /usr/src/kernels/2.6.24/drivers/media/video/saa7134/saa7134-cards.c.patch   2008-01-31 11:27:01.000000000 +0500
>> @@ -2484,7 +2484,8 @@ struct saa7134_board saa7134_boards[] =
>>                 }},
>>                 .radio = {
>>                           .name = name_radio,
>> -                         .amux = LINE1,
>> +                       .amux = TV,
>> +                       .gpio = 0x0200000,
>>                 },
>>         },
>>         [SAA7134_BOARD_ASUSTeK_P7131_DUAL] = {
>> Signed-off-by: Yuri Funduryan <yurifun@mail.ru>
> Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
> 
> Yuri, thanks for the fix.
> 
> Hartmut, does it apply with some offset or should I prepare something
> against v4l-dvb?
> 
> Mauro can pull it as a fix for 2.6.25 then.
> 
> We also have the same issue on the Avermedia 007, AFAIK.
> Next we should fix the indentation on the 110i entry ;)
> 
Hermann, will you generate a new patch?

> Got a Medion/Creatix CTX953 today.
> Against prior reports, DVB-T and analog TV work very well,
> have to check the other inputs.
> 
> A patch will follow soon.
> 
> No trace of the CTX948 yet I did send to you as a letter in the hope to
> save some time. Will try to get it investigated. A new one is bought,
> but might take time to arrive.
> 
> In between we might call for testers on both lists and point to what we
> have so far.
> 
Jep. Btw: i might get a CTX948 let for some days... I will inform you as soon
as there are news.
I now have to hack a patch for the 10086 diseqc issue...

Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
