Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.19]:11936 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbZKBQZ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 11:25:28 -0500
Received: from smtp23.services.sfr.fr (msfrf2324 [10.18.27.38])
	by msfrf2305.sfr.fr (SMTP Server) with ESMTP id 4CFA070003F6
	for <linux-media@vger.kernel.org>; Mon,  2 Nov 2009 17:25:30 +0100 (CET)
Message-ID: <4AEF0789.5030005@9online.fr>
Date: Mon, 02 Nov 2009 17:23:37 +0100
From: Pierre <pierre42d@9online.fr>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Problem compiling libv4l 0.6.3
References: <4AE882B7.6020406@9online.fr> <4AE975B1.407@redhat.com>
In-Reply-To: <4AE975B1.407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 10/28/2009 06:43 PM, Pierre wrote:
>> # make
>> make -C libv4lconvert V4L2_LIB_VERSION=0.6.3 all
>> make[1]: Entering directory `/tmp/libv4l-0.6.3/libv4lconvert'
>> gcc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include
>> -I../../../include -fvisibility=hidden -fPIC -DLIBDIR=\"/usr/local/lib\"
>> -DLIBSUBDIR=\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
>> -Wstrict-prototypes -Wmissing-prototypes -o libv4lconvert.o 
>> libv4lconvert.c
>> cc1: error: unrecognized command line option "-fvisibility=hidden"
>> make[1]: *** [libv4lconvert.o] Error 1
>> make[1]: Leaving directory `/tmp/libv4l-0.6.3/libv4lconvert'
>> make: *** [all] Error 2
>>
> 
> It would seem that you are using a very very old gcc.

# gcc --version
gcc (GCC) 3.4.3
Copyright (C) 2004 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is 
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR 
PURPOSE.

What is the version you recommend ?

Best regards,

-- 
Pierre.


