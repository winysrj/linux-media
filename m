Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbZJ2KyA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 06:54:00 -0400
Message-ID: <4AE975B1.407@redhat.com>
Date: Thu, 29 Oct 2009 12:00:01 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Pierre <pierre42d@9online.fr>
CC: linux-media@vger.kernel.org
Subject: Re: Problem compiling libv4l 0.6.3
References: <4AE882B7.6020406@9online.fr>
In-Reply-To: <4AE882B7.6020406@9online.fr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/28/2009 06:43 PM, Pierre wrote:
> # make
> make -C libv4lconvert V4L2_LIB_VERSION=0.6.3 all
> make[1]: Entering directory `/tmp/libv4l-0.6.3/libv4lconvert'
> gcc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include
> -I../../../include -fvisibility=hidden -fPIC -DLIBDIR=\"/usr/local/lib\"
> -DLIBSUBDIR=\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
> -Wstrict-prototypes -Wmissing-prototypes -o libv4lconvert.o libv4lconvert.c
> cc1: error: unrecognized command line option "-fvisibility=hidden"
> make[1]: *** [libv4lconvert.o] Error 1
> make[1]: Leaving directory `/tmp/libv4l-0.6.3/libv4lconvert'
> make: *** [all] Error 2
>

It would seem that you are using a very very old gcc.

Regards,

Hans
