Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35586 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761145Ab2CNRpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 13:45:33 -0400
Received: by lahj13 with SMTP id j13so1674189lah.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 10:45:31 -0700 (PDT)
Message-ID: <4F60D934.7040006@gmail.com>
Date: Wed, 14 Mar 2012 18:45:24 +0100
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add CI support to az6007 driver
References: <1577059.kW45pXQ20M@jar7.dominio> <4F552548.4000304@gmail.com> <1436129.Xg0ZNGxkxn@jar7.dominio> <4F57B520.9070607@gmail.com>
In-Reply-To: <4F57B520.9070607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

Sorry for the top post but this is just to check with you if you have 
experienced the same problem that I have. See below with some additional 
comments.

Roger Mårtensson skrev 2012-03-07 20:21:
> Jose Alberto Reguero skrev 2012-03-06 00:23:
>> On Lunes, 5 de marzo de 2012 21:42:48 Roger Mårtensson escribió:
>>
>> No. I tested the patch with DVB-T an watch encrypted channels with 
>> vdr without
>> problems. I don't know why you can't. I don't know gnutv. Try with other
>> software if you want.
>
> I have done some more testing and it works.. Sort of. :-)
>
> First let me walk through the dmesg.
>
> First I reinsert the CAM-card:
>
> Mar  7 20:12:36 tvpc kernel: [  959.717666] dvb_ca adapter 2: DVB CAM 
> detected and initialised successfully
>
> The next lines are when I start Kaffeine. Kaffeine gets a lock on the 
> encrypted channel and starts viewing it.
>
> Mar  7 20:13:02 tvpc kernel: [  986.359195] mt2063: detected a mt2063 B3
> Mar  7 20:13:03 tvpc kernel: [  987.368964] drxk: SCU_RESULT_INVPAR 
> while sending cmd 0x0203 with params:
> Mar  7 20:13:03 tvpc kernel: [  987.368974] drxk: 02 00 00 00 10 00 05 
> 00 03 02                    ..........
> Mar  7 20:13:06 tvpc kernel: [  990.286628] dvb_ca adapter 2: DVB CAM 
> detected and initialised successfully
>
> And now my "sort of"-comment. When I change the to another encrypted 
> channel in kaffeine I get nothing. To be able to view this channel I 
> need to restart kaffeine.
>
> The only thing that seems different in the logs are that when 
> restarting kaffeine I get the "CAM detected and initialised" but when 
> changing channels I do not get that line.
>
> Maybe there should be another reinit of the CAM somewhere? (just a guess)

I turned on debugging and I see when changing channels from one 
encrypted to another I get lots of:
"40 from 0x1read cam data = 0 from 0x1read cam data = 80 from 0x1read 
cam data = "

So the drivers is doing something except I don't get anything in 
kaffeine until I restart the application.
Now and then I even have to restart kaffeine twice. Same as above.. I 
see it reading but nothing happens.

I seem to find some EPG data since it can tell me what programs should 
be shown.
