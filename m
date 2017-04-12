Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40255 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdDLPsU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 11:48:20 -0400
From: Helen Koike <helen.koike@collabora.com>
To: =?UTF-8?B?TWlsYW4gxIzDrcW+ZWs=?= <milan.cizek@mail.starnet.cz>
Subject: Re: please help with uninstall
References: <B77D5CB33CF0C84684BD47DA74ADC87A014CAD26D74E@EXCHANGE.mail.starnet.cz>
Cc: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Message-ID: <2ae879c8-dd79-552c-de3c-222bedd3f9d7@collabora.com>
Date: Wed, 12 Apr 2017 12:48:11 -0300
MIME-Version: 1.0
In-Reply-To: <B77D5CB33CF0C84684BD47DA74ADC87A014CAD26D74E@EXCHANGE.mail.starnet.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 2017-04-12 08:00 AM, Milan Čížek wrote:
> How to remove your product from my kernel? I tried make rmmod
> rminstall but this message stills in my syslog.
> Sorry for question, I'm linux newbie.
>
> [   15.753993] WARNING: You are using an experimental version of the
> media stack.
>                 As the driver is backported to an older kernel, it
> doesn't offer
>                 enough quality for its usage in production.
>                 Use it with care.
>                Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
>                 427ae153c65ad7a08288d86baf99000569627d03 [media]
> bq/c-qcam, w9966, pms: move to staging in preparation for removal
>                 ea2e813e8cc3492c951b9895724fd47187e04a6f [media]
> tlg2300: move to staging in preparation for removal
>                 c1d9e03d4ef47de60b414fa25f05f9c867f43c5a [media]
> vino/saa7191: move to staging in preparation for removal
>
> Milan
>

This message doesn't seem to be an error, after running rmmod does the 
driver still shows with lsmod?.
If you want to prevent a module to load at boot time you can add the 
driver in the blacklist file, its location depends on your distribution, 
check this example: 
http://askubuntu.com/questions/110341/how-to-blacklist-kernel-modules
Or you can recompile the kernel without this module, I can point you to 
some guides if you want to go to this direction.

Helen
