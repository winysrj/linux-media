Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:33961 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753133AbdGHUag (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Jul 2017 16:30:36 -0400
Received: by mail-wr0-f176.google.com with SMTP id 77so89148816wrb.1
        for <linux-media@vger.kernel.org>; Sat, 08 Jul 2017 13:30:36 -0700 (PDT)
Subject: Re: Kaffeine with VLC backend.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <6a28b31a-1b67-f113-9456-19b910674a6a@gmail.com>
 <a94b59bd-0cdc-2856-a022-7190a7b3f6d5@gmail.com>
 <20170708160947.299e1402@vento.lan>
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <d62db204-ff77-fe8e-d9dc-95ba49fae6dd@gmail.com>
Date: Sat, 8 Jul 2017 21:30:32 +0100
MIME-Version: 1.0
In-Reply-To: <20170708160947.299e1402@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/07/17 20:09, Mauro Carvalho Chehab wrote:
> Em Sat, 8 Jul 2017 18:13:14 +0100
> Malcolm Priestley <tvboxspy@gmail.com> escreveu:
> 
>> On 08/07/17 08:17, Malcolm Priestley wrote:
>>> Hi Mauro
>>>
>>> Have you encountered a strange bug with Kaffeine with VLC backend.
>>>
>>> Certain channels will not play correctly, the recordings will also not
>>> play in VLC.
>>>
>>> However, they will play fine with xine player. Only some channels are
>>> affected of those provided by SKY such as 12207 V on Astra 28.2.
>>>
>>> These channels will play fine with Kaffeine with xine backend they also
>>> play with VLC's dvb-s interface.
>>>
>>> Any ideas what could be wrong with the TS format?
>>>
>>> I am wondering if SKY are inserting something into the format.
>>
>> Just a follow up it appears that the PCR is missing from the stream
>> which is transmitted on a different PID.
>>
>> In the case of the above channel manually adding PID 8190 the backend
>> plays normally.
> 
> You're likely using an old version of Kaffeine. See this BZ:
I was already using the latest git tree.

> 	
> 	https://bugs.kde.org/show_bug.cgi?id=376805
> No it hasn't fixed it the PCR is still missing from the stream.

Somehow, PCR PID needs to be added to the PID filter.

Unless there is a way VLC can ignore it like xine does?
