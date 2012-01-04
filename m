Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab2ADQNf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 11:13:35 -0500
Message-ID: <4F047AA8.6010909@redhat.com>
Date: Wed, 04 Jan 2012 14:13:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: dvbzap application based on DVBv5 API
References: <4EFCC9A7.9050907@redhat.com> <4EFD5E3D.8090305@yahoo.co.jp>
In-Reply-To: <4EFD5E3D.8090305@yahoo.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akihiro,

On 30-12-2011 04:46, Akihiro TSUKADA wrote:
>> [channel name]
>> 	property = value
>> ...
>> 	property = value
> 
> Currently, at least gstreamer's dvbbasebin and mplayer assumue that
> the channel configuration file has the format of one line per channel.
> So when I personally patched them to use v5 parameters,
> I chose the one-line-per-channel format of
>   <channel name>:propname=val|...|propname=val:<service id>, for example,
>  NHKBS1:DTV_DELIVERY_SYSTEM=SYS_ISDBS|DTV_VOLTAGE=1|DTV_FREQUENCY=1318000|DTV_ISDBS_TS_ID=0x40f2:103
> , to minimize modification (hopefully).
> I understand that it is not that difficult nor complicated 
> to adapt applications to use the ini file style format,
> but the old one line style format seems slightly easier.

It is not that harder to parse a multiple lines file, but using something like above
makes harder for humans to read. Also, the format I've proposed is already handled
by several existing tools. So, there are several parsers for it already
written.

> and I wish that the channel configuration can allow nicknames/aliases,
> as the canonical channel name can be long to type in or difficult to remember correctly.
> If I remember right, MythTV has its own database,
> and it would be convenient if we could share the database,
> because applications currently have their own channel configuration separately,
> and the configuration change like new service or parameter changes must be
> propagated manually.

Yes, this is an interesting feature. Some carriers broadcast nicks/aliases via
the emphasis encoding. It shouldn't be hard to add support for it.

Btw, I finished writing a dvbv5-scan application. It reads (currently) the 
legacy channels/transponders format found on dvb-apps, and outputs channel
scans on the new format.

I decided to write the scan tool from scratch, instead of importing the code from
w_scan or dvb-apps/scan, as it allowed me to avoid importing DVBv3 legacy stuff
on it, and to separate the scan code into a few function calls.

Due to that, only a subset of the features found on the other scan tools are there
(the ones that are needed for ISDB-T - and - likely DVB-T). I'm currently without
DVB-C signal, but, as soon as I return back to my hometown, I'll add the missing
bits for it.

I also wrote a small utility to convert from the legacy zap and channels.conf
formats into the new one. It is at:

	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils


Of course, patches, help, etc are welcome!

Regards,
Mauro
