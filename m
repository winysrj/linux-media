Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37005 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761513Ab0J2NLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 09:11:37 -0400
Received: by gxk23 with SMTP id 23so1939969gxk.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 06:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimJu-QDToxGNWKPj_B4QM_iO_x6G6eE4U2WnDPB@mail.gmail.com>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
	<AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
	<201010290139.10204.laurent.pinchart@ideasonboard.com>
	<AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>
	<AANLkTimJu-QDToxGNWKPj_B4QM_iO_x6G6eE4U2WnDPB@mail.gmail.com>
Date: Fri, 29 Oct 2010 15:11:36 +0200
Message-ID: <AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com>
Subject: Re: New media framework user space usage
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

>
> Now it becomes
> Unable to start streaming: 32 : Broken pipe

I saw that my stub mt9p031_get_format gets called. Thanks a lot. So I
reached the point where I can fill my driver with life.

> I will check if the video format of the sensor chip is SGRBG10 in default.

I guess this is GRBG. What does the S stand for?

Datasheet says:
"Pixels are output in a Bayer pattern format consisting of four
“colors”—GreenR, GreenB,
Red, and Blue (Gr, Gb, R, B)—representing three filter colors. When no
mirror modes are
enabled, the first row output alternates between Gr and R pixels, and
the second row
output alternates between B and Gb pixels. The Gr and Gb pixels have
the same color
filter, but they are treated as separate colors by the data path and
analog signal chain."


ciao,

 Bastian


> cheers,
>
>  Bastian
>
>
>> Any ideas where to look next?
>>
>> Thanks,
>>
>>  Bastian
>>
>>
>>> --
>>> Regards,
>>>
>>> Laurent Pinchart
>>>
>>
>
