Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZL1DtZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2009 22:49:25 -0500
Message-ID: <4B382AC0.1090103@redhat.com>
Date: Mon, 28 Dec 2009 01:49:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
References: <4B32CF33.3030201@redhat.com> <4B342CEE.8020205@redhat.com> <1a297b360912271408w191f35f4uc8c928a328a22a71@mail.gmail.com>
In-Reply-To: <1a297b360912271408w191f35f4uc8c928a328a22a71@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> Hello Mauro,
> 
> 
> On Fri, Dec 25, 2009 at 7:09 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 24-12-2009 00:17, Mauro Carvalho Chehab escreveu:
>>> I wrote several patches those days in order to allow dvb-apps to properly
>>> parse ISDB-T channel.conf.
>>>
>>> On ISDB-T, there are several new parameters, so the parsing is more complex
>>> than all the other currently supported video standards.
>>>
>>> I've added the changes at:
>>>
>>> http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt/
>>>
>>> I've merged there Patrick's dvb-apps-isdbt tree.
>>>
>>> While there, I fixed a few bugs I noticed on the parser and converted it
>>> to work with the DVB API v5 headers that are bundled together with dvb-apps.
>>> This helps to avoid adding lots of extra #if DVB_ABI_VERSION tests. The ones
>>> there can now be removed.
>>>
>>> TODO:
>>> =====
>>>
>>> The new ISDB-T parameters are parsed, but I haven't add yet a code to make
>>> them to be used;
>>>
>>> There are 3 optional parameters with ISDB-T, related to 1seg/3seg: the
>>> segment parameters. Currently, the parser will fail if those parameters are found.
>>>
>>> gnutv is still reporting ISDB-T as "DVB-T".
>>>
>> I've just fixed the issues on the TODO list. The DVB v5 code is now working fine
>> for ISDB-T.
>>
>> Pending stuff (patches are welcome):
>>        - Implement v5 calls for other video standards;
>>        - Remove the duplicated DVBv5 code on /util/scan/scan.c (the code for calling
>> DVBv5 is now at /lib/libdvbapi/v5api.c);
>>        - Test/use the functions to retrieve values via DVBv5 API. The function is
>> already there, but I haven't tested.
>>
>> With the DVBv5 API implementation, zap is now working properly with ISDB-T.
>> gnutv also works (although some outputs - like decoder - may need some changes, in
>> order to work with mpeg4/AAC video/audio codecs).
> 
> 
> Few comments on your changes (that came up on a first glance):

Thank you for your review!

> - dvb-apps don't need a DCO (S-O-B) as for kernel related code (though
> not an issue, whether it is there or not)

I know. It is just easier for me to keep the SOB than to modify my .hgrc just for
dvb-apps. If this really bothers you, I'm fine to drop it before merging it.

> - changeset 1334 is a regression:
> 
> dvb-apps look at libraries that are shipped with the distribution
> alone. The headers in there are a copy for szap2 alone for test cases
> and szap2 is not a generic application such as zap and hence doesn't
> need to be ported.

It is very confusing to have a copy of the headers there that it is used
by just one application. So, the dvb headers should be either dropped or used
by all compilation.

By using the random header that is found at /usr/include means that
dvb-apps cannot be built with all their capabilities with the stable distros, 
but only with the latest -rc kernels. 

Just for example, in my case, I was running a distro that it was launched
last month (Fedora 12). It was built and running a 2.6.31 kernel, but ISDB-T
API appeared only on 2.6.32. It seems really doubtful that building dvb-apps 
with any current non-alpha distros would enable ISDB-T, since I doubt you'll
find may users with ISDB-T headers on their /usr/include.

On the other hand, if dvb-apps is newer than the driver, there's no problem, since
it will fall-back to v3 API calls.

The practical effect of not using the latest headers is that people using 
the latest -hg kernel drivers won't benefit from the API changes, since 
there's no target at the out-of-tree system to update the headers at /usr/include.

So, except for kernel developers that know how to update the headers from the latest
linus tree, ISDB-T wouldn't work for users currently.

> - get_v5_frontend keeps on malloc with no free .....

It is feed at the end by:

+exit:
+       if (dtv_prop_arg)
+               free (dtv_prop_arg);
+       free_props(&prop);

Anyway, you're right: there are some cases that it is not freeing. I'll fix it.

> 
> - the basic design we have in the libraries is that we don't allow the
> library to do the allocation but allocation is done by the user
> (application)

In this case, it is just a temporary allocation, just like several other libc
routines do. The temporary memory should be freed before returning back to
the caller.

It is used to create a temporary list of data to be sent to the device, and
it is standard-dependent. The current code has only ISDB-T, but I wrote it
thinking on being extended to other standards as well.

The alternative of not using such data struct is very ugly.

The library might provide a callback method to allocate/free such temporary memory,
but I see no point on doing it.

> - the library is not meant to handle the basic in-kernel API alone,
> there are others that's the whole intention for the library.

Sorry, but I didn't get what you meant here: the ISDB-T data structs need to be
handled by the scan and the parsers.

All the applications needed to know is that now ISDB-T is supported. All ISDB-T
complexity were let to the API. If you see the diffstat for the series:
	hg diff -r 1325|lsdiff -p1 

you'll see that the changes were minimal at the applications (on most cases, just
a few lines at the switch() that handles the DTV types, in order to report that
the device all the DVB FE types, like this one:

$ hg diff -r 1325 util/gnutv/gnutv_dvb.c
diff --git a/util/gnutv/gnutv_dvb.c b/util/gnutv/gnutv_dvb.c
--- a/util/gnutv/gnutv_dvb.c
+++ b/util/gnutv/gnutv_dvb.c
@@ -124,8 +124,12 @@ static void *dvbthread_func(void* arg)
                                types = "DVB-T";
                                break;
                        case DVBFE_TYPE_ATSC:
+                       case DVBFE_TYPE_ATSCC:
                                types = "ATSC";
                                break;
+                       case DVBFE_TYPE_ISDBT:
+                               types = "ISDB-T";
+                               break;
                        default:
                                types = "Unknown";
                        }

> - changeset 1341 is broken

What's broken there? I tested it with both DVB-T and ISDB-T and it worked fine.
I don'think that the changes broke for the other standards.

Cheers,
Mauro.
