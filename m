Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1729 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZBJEj4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 23:39:56 -0500
Message-ID: <49910509.1080407@linuxtv.org>
Date: Mon, 09 Feb 2009 23:39:37 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: urishk@yahoo.com, linux-media@vger.kernel.org,
	linuxtv-commits@linuxtv.org, linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: Siano's patches
References: <393674.19439.qm@web110814.mail.gq1.yahoo.com>	<49736FE6.9080309@linuxtv.org> <20090209192437.55ee6737@pedra.chehab.org>
In-Reply-To: <20090209192437.55ee6737@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Michael,
>
> On Sun, 18 Jan 2009 13:07:34 -0500
> Michael Krufky <mkrufky@linuxtv.org> wrote:
>
>  
>   
>> Once I have reviewed & merged your changes and after I can restore the 
>> proper functionality to the hauppauge devices, then I will post a new 
>> mercurial tree for testing against all siano-based devices.
>>
>> Please be patient -- this takes time.
>>     
>
> Any news?

I haven't had time to fix the breakage that these changes caused on the 
Hauppauge devices.

This is what I will do -- I will gather all the patches up and push them 
all into one tree, regardless of any codingstyle issues or breakages, 
just so that we at least have track of everything.

Once it's all in one repository, I can just move the gpio function that 
the hauppauge devices depend on into the sms-cards.c file -- this way, 
they will not be used by other devices and the siano code can go in as 
desired by Uri.

The first tree that gets pushed up will likely need some cleanup, but 
we'll deal with that afterwards.

I saw some other interesting patches that Uri's been posting on the 
lists that I'd definitely like to merge along with these as soon as 
possible.

-Mike
