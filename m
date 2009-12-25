Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZLYDJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 22:09:39 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBP39dnI003159
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 22:09:39 -0500
Received: from gaivota.chehab.org (vpn-11-61.rdu.redhat.com [10.11.11.61])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nBP39Zj8009219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 22:09:38 -0500
Message-ID: <4B342CEE.8020205@redhat.com>
Date: Fri, 25 Dec 2009 01:09:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
References: <4B32CF33.3030201@redhat.com>
In-Reply-To: <4B32CF33.3030201@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-12-2009 00:17, Mauro Carvalho Chehab escreveu:
> I wrote several patches those days in order to allow dvb-apps to properly
> parse ISDB-T channel.conf.
> 
> On ISDB-T, there are several new parameters, so the parsing is more complex
> than all the other currently supported video standards.
> 
> I've added the changes at:
> 
> http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt/
> 
> I've merged there Patrick's dvb-apps-isdbt tree.
> 
> While there, I fixed a few bugs I noticed on the parser and converted it
> to work with the DVB API v5 headers that are bundled together with dvb-apps.
> This helps to avoid adding lots of extra #if DVB_ABI_VERSION tests. The ones
> there can now be removed.
> 
> TODO:
> =====
> 
> The new ISDB-T parameters are parsed, but I haven't add yet a code to make
> them to be used;
> 
> There are 3 optional parameters with ISDB-T, related to 1seg/3seg: the
> segment parameters. Currently, the parser will fail if those parameters are found.
> 
> gnutv is still reporting ISDB-T as "DVB-T".
> 

I've just fixed the issues on the TODO list. The DVB v5 code is now working fine
for ISDB-T.

Pending stuff (patches are welcome):
	- Implement v5 calls for other video standards;
	- Remove the duplicated DVBv5 code on /util/scan/scan.c (the code for calling
DVBv5 is now at /lib/libdvbapi/v5api.c);
	- Test/use the functions to retrieve values via DVBv5 API. The function is
already there, but I haven't tested.

With the DVBv5 API implementation, zap is now working properly with ISDB-T.
gnutv also works (although some outputs - like decoder - may need some changes, in
order to work with mpeg4/AAC video/audio codecs).

Have fun!

Cheers,
Mauro.
