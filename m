Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab2AGUFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 15:05:37 -0500
Message-ID: <4F08A58A.1010401@redhat.com>
Date: Sat, 07 Jan 2012 18:05:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Honza_Petrou=9A?= <jpetrous@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com> <CAJbz7-0HUqWttzMhQ14nQQwjyc_sO=zL0uQDMciFECPttg_o9Q@mail.gmail.com>
In-Reply-To: <CAJbz7-0HUqWttzMhQ14nQQwjyc_sO=zL0uQDMciFECPttg_o9Q@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-01-2012 15:29, Honza Petrouš wrote:
> Hi Mauro.
> 
> 2012/1/7 Mauro Carvalho Chehab <mchehab@redhat.com>:
>> As previously commented at the ML, I'm developing a set of tools
>> using DVBv5 API. Instead of starting from something existing,
>> I decided to start from scratch, in order to avoid polluting it
>> with DVBv3 legacy stuff. Of course, I did some research inside
>> the existing tools, in order to fill in the blanks, using the
>> dvb-apps tzap as a reference for the first real application on it,
>> but removing a large amount of code (file parsers, etc).
>>
>> They're now on a good shape, at least for my own usage ;)
>>
>> In order to test, you should use:
>>
>> git clone git://linuxtv.org/mchehab/experimental-v4l-utils.git
>>
>> And then run "make". the utils are inside utils/dvb.
>>
> 
> Am I doing something wrong? After clone I can't find
> dvb subdirectory inside utils:

Huh... sorry, you need to specify the branch as well. The correct
syntax would be:

git clone git://linuxtv.org/mchehab/experimental-v4l-utils.git	dvbv5-0.0.1

it is likely that git clone has already fetched this branch as well,
so, now that you've cloned it, you can do:

git remote update
git checkout origin/dvbv5-0.0.1

In order to build, you need to run "make" two times (the first one
will run automake tools, and the second one will actually compile
everything).

After running the first make, you can just go to utils/dvb and run
make from there, if you don't want to compile everything.

> 
> [hop@localhost experimental-v4l-utils (master)]$ ll utils/
> celkem 48
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 decode_tm6000/
> drwxr-xr-x 3 hop hop 4096 led  7 18:21 keytable/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 libmedia_dev/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 libv4l2util/
> -rw-r--r-- 1 hop hop  947 led  7 18:21 Makefile
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 qv4l2/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 rds/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-compliance/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-ctl/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-dbg/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-sysfs-path/
> drwxr-xr-x 2 hop hop 4096 led  7 18:21 xc3028-firmware/
> 
> 
> Honza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

