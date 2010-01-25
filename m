Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:33726 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0AYVmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 16:42:05 -0500
Received: by fg-out-1718.google.com with SMTP id l26so1256078fgb.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 13:42:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361001241314o7733d2eev2a5c18bd9b75fa08@mail.gmail.com>
References: <7b41dd971001240258h7bce4a9dy7a00d22d6091d3da@mail.gmail.com>
	 <1a297b361001241314o7733d2eev2a5c18bd9b75fa08@mail.gmail.com>
Date: Mon, 25 Jan 2010 22:41:59 +0100
Message-ID: <7b41dd971001251341u64a4496fmb242d7bfcee8648a@mail.gmail.com>
Subject: Re: [PATCH] dvb-apps/util/szap/czap.c "ERROR: cannot parse service
	data"
From: klaas de waal <klaas.de.waal@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org, sander@vermin.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 24, 2010 at 10:14 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi Klaas,
>
> On Sun, Jan 24, 2010 at 2:58 PM, klaas de waal <klaas.de.waal@gmail.com> wrote:
>> The czap utility (dvb-apps/util/szap/czap.c) cannot scan the channel
>> configuration file when compiled on Fedora 12 with gcc-4.4.2.
>>
>> The czap output is:
>>
>> [klaas@myth2 szap]$ ./czap -c ~/.czap/ziggo-channels.conf Cartoon
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> reading channels from file '/local/klaas/.czap/ziggo-channels.conf'
>>  1 Cartoon:356000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:1660:1621
>> ERROR: cannot parse service data
>>
>> Problem is tha the "sscanf" function uses the "%a[^:]" format
>> specifier. According to "man sscanf" you need to define _GNU_SOURCE if
>> you want this to work because it is a gnu-only extension.
>> Adding a first line "#define _GNU_SOURCE" to czap.c and recompiling
>> solves the problem.
>>
>> The czap output is now:
>>
>> [klaas@myth2 szap]$ ./czap -c ~/.czap/ziggo-channels.conf Cartoon
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> reading channels from file '/local/klaas/.czap/ziggo-channels.conf'
>>  1 Cartoon:356000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:1660:1621
>>  1 Cartoon: f 356000000, s 6875000, i 2, fec 0, qam 3, v 0x67c, a 0x655
>> status 00 | signal 0000 | snr b7b7 | ber 000fffff | unc 00000098 |
>> status 1f | signal d5d5 | snr f3f3 | ber 000006c0 | unc 0000009b | FE_HAS_LOCK
>> status 1f | signal d5d5 | snr f4f4 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>
>> This is done on a Linux 2.6.32.2 kernel with a TT C-1501 DVB-C card.
>>
>> Signed-off-by: Klaas de Waal <klaas.de.waal@gmail.com>
>>
>> -------------------------------------------------------------------------------------------
>>
>> diff -r 61b72047a995 util/szap/czap.c
>> --- a/util/szap/czap.c  Sun Jan 17 17:03:27 2010 +0100
>> +++ b/util/szap/czap.c  Sun Jan 24 11:40:43 2010 +0100
>> @@ -1,3 +1,4 @@
>> +#define _GNU_SOURCE
>>  #include <sys/types.h>
>>  #include <sys/stat.h>
>>  #include <sys/ioctl.h>
>>
>
> There seems to be other instances where _GNU_SOURCE needs to be
> defined, from a quick look. Care to send a patch against the entire
> dvb-apps tree ?
>
> Regards,
> Manu
>

Hi Manu,

I did have a reasonably good look at the code and at the compilation
log created with "-pedantic" added to the CFLAGS but although there
are a lot of GNU extensions used I think they will compile correct. I
do not think that the _GNU_SOURCE definitions need to be added
anywhere.

Having said that, I am not even happy anymore with the _GNU_SOURCE in
czap.c although it does solve the problem.

I have now added "std=gnu99 -Wformat" to the default CFLAGS in
Make.rules. This flags the use of the "a" format specifier as used in
the sscanf statement in czap.c as an error, although it works when
_GNU_SOURCE is defined.
I have now modified the czap.c to use the "m" format specifier which
does just what the 'a" used to do.
This works OK, it does not give compilation messages and it does not
require _GNU_SOURCE so I think it is a better solution. Hope you like
it.

Regards,
Klaas.

Signed-off-by: Klaas de Waal <klaas.de.waal@gmail.com>

-------------------------------------------------------------------------------------------

diff -r 61b72047a995 Make.rules
--- a/Make.rules	Sun Jan 17 17:03:27 2010 +0100
+++ b/Make.rules	Mon Jan 25 22:27:05 2010 +0100
@@ -1,6 +1,7 @@
 # build rules for linuxtv.org dvb-apps

-CFLAGS ?= -g -Wall -W -Wshadow -Wpointer-arith -Wstrict-prototypes
+CFLAGS ?= -g -Wall -W -Wshadow -Wpointer-arith -Wstrict-prototypes \
+-std=gnu99 -Wformat

 ifneq ($(lib_name),)

diff -r 61b72047a995 util/szap/czap.c
--- a/util/szap/czap.c	Sun Jan 17 17:03:27 2010 +0100
+++ b/util/szap/czap.c	Mon Jan 25 22:27:05 2010 +0100
@@ -141,7 +141,7 @@
 	}
 	printf("%3d %s", chan_no, chan);

-	if ((sscanf(chan, "%a[^:]:%d:%a[^:]:%d:%a[^:]:%a[^:]:%d:%d\n",
+	if ((sscanf(chan, "%m[^:]:%d:%m[^:]:%d:%m[^:]:%m[^:]:%d:%d\n",
 				&name, &frontend->frequency,
 				&inv, &frontend->u.qam.symbol_rate,
 				&fec, &mod, vpid, apid) != 8)
