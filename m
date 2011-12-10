Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52620 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1LJNPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 08:15:05 -0500
Message-ID: <4EE35B55.3070900@iki.fi>
Date: Sat, 10 Dec 2011 15:15:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 00/10] Query DVB frontend delivery capabilities
References: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com> <4EE359CF.7090707@redhat.com>
In-Reply-To: <4EE359CF.7090707@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/10/2011 03:08 PM, Mauro Carvalho Chehab wrote:
> A separate issue: please, don't send patches like that as attachment. It
> makes
> hard for people review. Instead, you should use git send-email. There's
> even
> an example there (at least on git version 1.7.8) showing how to set it for
> Google:
>
> $ git help send-email
> ...
> EXAMPLE
> Use gmail as the smtp server
> To use git send-email to send your patches through the GMail SMTP
> server, edit ~/.gitconfig to specify your
> account settings:
>
> [sendemail]
> smtpencryption = tls
> smtpserver = smtp.gmail.com
> smtpuser = yourname@gmail.com
> smtpserverport = 587
>
> Once your commits are ready to be sent to the mailing list, run the
> following commands:
>
> $ git format-patch --cover-letter -M origin/master -o outgoing/
> $ edit outgoing/0000-*
> $ git send-email outgoing/*

I have SMTP which requires login over SSL. I am not sure if Git 
send-email event supports that but even if it supports I don't like idea 
to put my clear text password to some config file.

That's why I have used Thunderbird with External Editor and it sucks :/

Antti

-- 
http://palosaari.fi/
