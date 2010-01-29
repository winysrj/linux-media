Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:64832 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0A2Tb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 14:31:56 -0500
Message-ID: <4B63379B.4050408@freemail.hu>
Date: Fri, 29 Jan 2010 20:31:39 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: David Henig <dhhenig@googlemail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Francis Barber <fedora@barber-family.id.au>,
	leandro Costantino <lcostantino@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>	 <4B62A967.3010400@googlemail.com>	 <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com>	 <4B62F048.1010506@googlemail.com>	 <4B62F620.6020105@barber-family.id.au>	 <4B6306AA.8000103@googlemail.com> <829197381001290916m4eeb9271x1c858d6a6d0b9b3b@mail.gmail.com> <4B63290D.20104@googlemail.com>
In-Reply-To: <4B63290D.20104@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Henig wrote:
> Thanks, this is sounding promising, only thing is I'm not seeing a 
> .config in the v4l directory although it shows up with the locate 
> command, am I missing something very obvious.

Sorry if I'm telling evidence, but just a hint: every file starts
with . is a "hidden" file. So you'll need something like
ls -a lib/modules/2.6.31-17-generic/build/.config , see "man ls".

Regards,

	Márton Németh

> Devin Heitmueller wrote:
>> On Fri, Jan 29, 2010 at 11:02 AM, David Henig <dhhenig@googlemail.com> wrote:
>>   
>>> Thanks, I appear to have the headers and no longer have to do the symlink,
>>> but still getting the same error - any help gratefully received, or do I
>>> need to get a vanilla kernel?
>>>     
>> Open up the file v4l/.config and change the line for firedtv from "=m"
>> to "=n".  Then run "make".
>>
>> This is a known packaging bug in Ubuntu's kernel headers.
>>
>> Cheers,
>>
>> Devin
