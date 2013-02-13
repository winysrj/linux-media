Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:65308 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3BMGyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 01:54:35 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so382391eaa.35
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 22:54:34 -0800 (PST)
Message-ID: <511B38A6.3060001@gmail.com>
Date: Wed, 13 Feb 2013 07:54:30 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove Jarod Wilson and orphan LIRC drivers
References: <1360704036.22660.5.camel@joe-AO722> <511AFC9E.5060408@gmail.com> <1360723757.2220.1.camel@joe-AO722> <CAA7C2qhQ74EbafCXnn0Rz_J70KoT+th61FF1hbotPXv7RszmKg@mail.gmail.com> <511B2F96.9020305@gmail.com>
In-Reply-To: <511B2F96.9020305@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.02.2013 07:15, thomas schorpp wrote:
> On 13.02.2013 06:15, VDR User wrote:
>> You can also try Jarod Wilson on freenode irc in #lirc. He is usually there.
>>
>
> What for? Bothering him with issues from blocklisting mailhosters' RFC violations?
>
> y
> tom
>

Unbelievable, this blocklist bullshit .org https://www.senderscore.org/senderscore/

claims the reputation to teach others about "reputation" and blocking internet mailers

but their own crap mailserver cannot even handle TLS:


$ swaks -tls -t postmaster@senderscore.org -h xxxxxxxxxx -f xxxxxxxxxxxx
=== Trying smtp.returnpath.net:25...
=== Connected to smtp.returnpath.net.
<-  220 smtp.returnpath.net ESMTP Postfix
  -> EHLO xxxxxxxxx
<-  250-smtp.returnpath.net
...
*** Host did not advertise STARTTLS
  -> QUIT
<-  221 2.0.0 Bye
=== Connection closed with remote host.

Bah!

y
tom

