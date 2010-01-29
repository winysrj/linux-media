Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:51586 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0A2S3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 13:29:37 -0500
Received: by ewy28 with SMTP id 28so118082ewy.28
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 10:29:35 -0800 (PST)
Message-ID: <4B63290D.20104@googlemail.com>
Date: Fri, 29 Jan 2010 18:29:33 +0000
From: David Henig <dhhenig@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Francis Barber <fedora@barber-family.id.au>,
	leandro Costantino <lcostantino@gmail.com>,
	=?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>	 <4B62A967.3010400@googlemail.com>	 <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com>	 <4B62F048.1010506@googlemail.com>	 <4B62F620.6020105@barber-family.id.au>	 <4B6306AA.8000103@googlemail.com> <829197381001290916m4eeb9271x1c858d6a6d0b9b3b@mail.gmail.com>
In-Reply-To: <829197381001290916m4eeb9271x1c858d6a6d0b9b3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, this is sounding promising, only thing is I'm not seeing a 
.config in the v4l directory although it shows up with the locate 
command, am I missing something very obvious.

David

Devin Heitmueller wrote:
> On Fri, Jan 29, 2010 at 11:02 AM, David Henig <dhhenig@googlemail.com> wrote:
>   
>> Thanks, I appear to have the headers and no longer have to do the symlink,
>> but still getting the same error - any help gratefully received, or do I
>> need to get a vanilla kernel?
>>     
>
> Open up the file v4l/.config and change the line for firedtv from "=m"
> to "=n".  Then run "make".
>
> This is a known packaging bug in Ubuntu's kernel headers.
>
> Cheers,
>
> Devin
>
>   
