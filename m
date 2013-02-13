Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59958 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3BMGkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 01:40:39 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so371729eek.39
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 22:40:38 -0800 (PST)
Message-ID: <511B3564.20006@gmail.com>
Date: Wed, 13 Feb 2013 07:40:36 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove Jarod Wilson and orphan LIRC drivers
References: <1360704036.22660.5.camel@joe-AO722>  <511AFC9E.5060408@gmail.com> <1360723757.2220.1.camel@joe-AO722> <511B2A9A.1030305@gmail.com>
In-Reply-To: <511B2A9A.1030305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.02.2013 06:54, thomas schorpp wrote:
> On 13.02.2013 03:49, Joe Perches wrote:
...

>> Bounces for me.
>
> Cant confirm:
>
> wilsonet.com.        5602    IN    MX    0 aspmx.l.google.com.
> ...
>
>   -> RCPT TO:<jarod@wilsonet.com>
> <-  250 2.0.0 OK 1360733211 g1si2865285eeo.229 - gsmtp
>
> $ grep jarod /var/log/mail.log
> $
>

Sorry, need some sleep soon, correction:

$ grep google /var/log/mail.log
$

But still no bounce.

y
tom



