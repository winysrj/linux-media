Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42397 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965630Ab3DTDNX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 23:13:23 -0400
Message-ID: <517207A2.9000103@iki.fi>
Date: Sat, 20 Apr 2013 06:12:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: v4l-utils build problem
References: <51720176.9080400@iki.fi> <20130419235130.636d0f08@redhat.com>
In-Reply-To: <20130419235130.636d0f08@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/20/2013 05:51 AM, Mauro Carvalho Chehab wrote:
> Em Sat, 20 Apr 2013 05:46:14 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> I am unable to build that. It is Fedora 17 box. Any idea what is missing?
>>
>> Here is the error:
>>
>> [crope@localhost v4l-utils]$ autoreconf -vfi
>> autoreconf: Entering directory `.'
>> autoreconf: running: autopoint --force
>> autoreconf: running: aclocal --force -I m4
>> autoreconf: configure.ac: tracing
>> autoreconf: running: libtoolize --copy --force
>> libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `build-aux'.
>> libtoolize: copying file `build-aux/ltmain.sh'
>> libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
>> libtoolize: copying file `m4/libtool.m4'
>> libtoolize: copying file `m4/ltoptions.m4'
>> libtoolize: copying file `m4/ltsugar.m4'
>> libtoolize: copying file `m4/ltversion.m4'
>> libtoolize: copying file `m4/lt~obsolete.m4'
>> autoreconf: running: /usr/bin/autoconf --force
>> autoreconf: running: /usr/bin/autoheader --force
>> autoreconf: running: automake --add-missing --copy --force-missing
>> Makefile.am:4: AM_GNU_GETTEXT used but `po' not in SUBDIRS
>> autoreconf: Leaving directory `.'
>> [crope@localhost v4l-utils]$ configure
>
> It should be, instead:
> 	$ ./configure

How insane mistake! Now I feel embarrassed...

I really was thinking it fails just earlier, to autoreconf as 
"Makefile.am:4: AM_GNU_GETTEXT used but `po' not in SUBDIRS". But that 
seems to be normal printing.

> You probably need to go sleep ;)

Y, indeed. Have been hacking whole night again in order to get GNU 
Radio's sample module working... Finally it stars working. Too many 
environment setup problems...

regards
Antti

-- 
http://palosaari.fi/
