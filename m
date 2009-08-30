Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44279 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZH3OHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 10:07:31 -0400
Received: by bwz19 with SMTP id 19so2355000bwz.37
        for <linux-media@vger.kernel.org>; Sun, 30 Aug 2009 07:07:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9A27DD.3020807@freemail.hu>
References: <4A913AB8.5060604@freemail.hu>
	 <1251032765.4905.19.camel@pc07.localdom.local>
	 <4A9140A7.6020402@freemail.hu>
	 <1251033530.4905.25.camel@pc07.localdom.local>
	 <829197380908230629w62399f3cicd2dd9a9f2c6aeab@mail.gmail.com>
	 <4A9A27DD.3020807@freemail.hu>
Date: Sun, 30 Aug 2009 10:07:32 -0400
Message-ID: <829197380908300707u29463ae0j66cfc1ee2f1d5d47@mail.gmail.com>
Subject: Re: Pinnacle Hybrid Pro Stick (320e)?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/8/30 Németh Márton <nm127@freemail.hu>:
> Devin Heitmueller wrote:
>> I committed some changes to get this board working a few weeks ago.  I
>> will check your dmesg output and see if the changes missed the merge
>> window.  It's possible the changes didn't make it in time for 2.6.31,
>> so I will have to check.
>
> I tried the following software setup with Pinnacle Hybrid Pro Stick (320e)
> (USB ID: eb1a:2881): Linux kernel 2.6.31-rc7 updated with the
> http://linuxtv.org/hg/v4l-dvb repository at version 12564:6f58a5d8c7c6.
>
> When I plug the device I still get the following message:
>
<snip>

The changes have not gone upstream yet.  Mauro wrote some code for a
potential firmware extract script, but it doesn't work yet.

I've been tied up in another project, so I haven't gotten back to it.
I know I keep dragging this out, but given my current workload I
probably won't get the work done for the next couple of weeks.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
