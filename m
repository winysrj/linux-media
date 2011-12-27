Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49083 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1L0Nzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 08:55:50 -0500
Message-ID: <4EF9CE5F.3000003@infradead.org>
Date: Tue, 27 Dec 2011 11:55:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 00/91] Only use DVBv5 internally on frontend drivers
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <4EF9BA86.1010109@linuxtv.org> <4EF9C5D3.2080400@infradead.org>
In-Reply-To: <4EF9C5D3.2080400@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27-12-2011 11:19, Mauro Carvalho Chehab wrote:
> On 27-12-2011 10:31, Andreas Oberritter wrote:
>> On 27.12.2011 02:07, Mauro Carvalho Chehab wrote:
>>> Mauro Carvalho Chehab (91):
>>
>> It would be nice if you could send each message as a reply to the cover
>> letter next time, instead of sending message x as a reply to message x-1.
>>
>> Otherwise, one needs a very wide screen to display all messages in a
>> threaded view. I stopped reading around message 50.
> 
> This is the way git mail-send does, at least by default. Maybe there's an
> option for it to change the way threads are shown. I'll seek if is there
> any way to change it.

Ok, this should fix my git mail-send config:

[sendemail]
        chainreplyto = false

Next time, it should send everything as reply to the first message.

Thanks for pointing it!
Mauro
