Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61042 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1DWLfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 07:35:33 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so1276502wwa.1
        for <linux-media@vger.kernel.org>; Sat, 23 Apr 2011 04:35:32 -0700 (PDT)
Message-ID: <4DB2BA0B.20906@gmail.com>
Date: Sat, 23 Apr 2011 13:37:47 +0200
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <4DB1FE58.20006@usa.net>
In-Reply-To: <4DB1FE58.20006@usa.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Issa,
> Running a bunch of test with gnutv and a DuoFLEX S2.
>   
I have a DuoFlex S2 running with CI, but not nGene based (it's attached 
to Octopus card - ddbridge module).

> I would run gnutv  like 'gnutv -out stdout channelname >
> /dev/dvb/adapter0/caio0' and then 'cat /dev/dvb/adapter0/caio0 | mplayer -'
> Mplayer would complain the file is invalid. Simply running simply 'cat
> /dev/dvb/adapter0/caio0' will show me the same data pattern over and over.
>   
I suspect the problem is that reads/writes are not aligned to 188 bytes 
with such invocation of commands. Maybe if you tried replacing 'cat' and 
'>' with 'dd' (bs=188). Other important thing seems to be, to read from 
the caio0 fast enough or real data is overwritten with null packets 
(haven't proved it, but it looks this way on nGene).

Hope this helps.

Best regards,
Martin Vidovic
