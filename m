Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbZKVOTp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 09:19:45 -0500
Message-ID: <4B094A30.3010501@redhat.com>
Date: Sun, 22 Nov 2009 15:26:56 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWF0ZXVzeiBTenltYcWEc2tp?= <dasiek@onet.eu>
CC: linux-media@vger.kernel.org
Subject: Re: libv4l-0.6.2-test problem with compiling on 32 bit
References: <200911221202.36703.dasiek@onet.eu>
In-Reply-To: <200911221202.36703.dasiek@onet.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/22/2009 12:02 PM, Mateusz Szymański wrote:
> Good morning, I am using arch linux on 64 bit architecture, this version v4l
> helped me to rotate view from my webcam, but only in 64 bit apps, like
> mplayer, I have a problem with compiling it to 32 bits (for skype), I have 32
> bit libs, but they are in /opt/lib32/usr/lib directory and during the
> compiling i am receiving an error:
>
> [libv4l-0.6.2-test]$ make PREFIX=/usr CFLAGS=-m32 LDFLAGS=-m32
> LIBDIR=/opt/lib32/usr
> ...
> /usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-unknown-linux-
> gnu/4.4.2/../../../librt.so when searching for -lrt
> /usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-unknown-linux-
> gnu/4.4.2/../../../librt.a when searching for -lrt
> /usr/bin/ld: skipping incompatible /usr/lib/librt.so when searching for -lrt
> /usr/bin/ld: skipping incompatible /usr/lib/librt.a when searching for -lrt
> /usr/bin/ld: cannot find -lrt
> collect2: ld returned 1 exit status
> make[1]: *** [libv4lconvert.so] Error 1
>
> In /opt/lib32/usr/lib, there are files librt.so and librt.a, but ld doesn't
> seem to find them.
>
> $ cat /etc/ld.so.conf
> #
> # /etc/ld.so.conf
> #
>
> # End of file
> /usr/lib/libfakeroot
> /opt/lib32/usr/lib
> /opt/lib32/lib
>
> I would be grateful if You could help me with this problem.
>

This is a problem specific to the way things are set up in your distro,
please ask for help in one of the fora / mailinglists of your distro.

Regards,

hans
