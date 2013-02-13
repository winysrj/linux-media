Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33120 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3BMFyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 00:54:38 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so311500eab.20
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 21:54:36 -0800 (PST)
Message-ID: <511B2A9A.1030305@gmail.com>
Date: Wed, 13 Feb 2013 06:54:34 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove Jarod Wilson and orphan LIRC drivers
References: <1360704036.22660.5.camel@joe-AO722>  <511AFC9E.5060408@gmail.com> <1360723757.2220.1.camel@joe-AO722>
In-Reply-To: <1360723757.2220.1.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.02.2013 03:49, Joe Perches wrote:
> On Wed, 2013-02-13 at 03:38 +0100, thomas schorpp wrote:
>> On 12.02.2013 22:20, Joe Perches wrote:
>>> His email bounces and he hasn't done work on
>>> these sections in a couple of years.
> []
>>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>>> -M:	Jarod Wilson <jarod@wilsonet.com>
>
>> Not bouncing:
>>
>>    -> RCPT TO:<jarod@redhat.com>
>> <-  250 2.0.0 r1D2CGt8016879 Message accepted for delivery
>
> That's his redhat address, it doesn't bounce.
>
> Try the jarod@wilsonet.com address
> as shown above listed in MAINTAINERS.
>
> Bounces for me.

Cant confirm:

wilsonet.com.		5602	IN	MX	0 aspmx.l.google.com.
...

  -> RCPT TO:<jarod@wilsonet.com>
<-  250 2.0.0 OK 1360733211 g1si2865285eeo.229 - gsmtp

$ grep jarod /var/log/mail.log
$

perches.com mail is handled by 10 mx.perches.com.cust.hostedemail.com.
554 5.7.1 Service unavailable; Client host blocked using urbl.hostedemail.com

Maybe Your genious mailhoster blocks You too with https://www.senderscore.org for sending
to much "linux spam" with fake bounces or Google is blocking them with their own blocklist bullshit ;-)

y
tom

