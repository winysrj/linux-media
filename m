Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:62104 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZLAVfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 16:35:18 -0500
Message-ID: <4B158C0E.4080709@freemail.hu>
Date: Tue, 01 Dec 2009 22:35:10 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: WARNINGS, 2.6.16-2.6.21:
 WARNINGS
References: <200912011947.nB1JltLm031870@smtp-vbr17.xs4all.nl>
In-Reply-To: <200912011947.nB1JltLm031870@smtp-vbr17.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> Results of the daily build of v4l-dvb:
> 
> date:        Tue Dec  1 19:00:02 CET 2009
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   13538:e0cd9a337600
> gcc version: gcc (GCC) 4.3.1
> hardware:    x86_64
> host os:     2.6.26
> [...]
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.log


>> linux-2.6.29.1-i686: WARNINGS
>> /marune/build/v4l-dvb-master/v4l/firedtv-1394.c:264: warning: initialization discards qualifiers from pointer target type

>> linux-2.6.29.1-x86_64: WARNINGS
>> /marune/build/v4l-dvb-master/v4l/firedtv-1394.c:264: warning: initialization discards qualifiers from pointer target type

I found about this two warnings that this module is not to be built with 2.6.29.1
according to the following lines from version.txt:

> [2.6.30]
> # Needs const id_table pointer in struct hpsb_protocol_driver
> DVB_FIREDTV_IEEE1394

I'm not sure whether the script v4l/scripts/make_kconfig.pl is working correctly or not.

Regards,

	Márton Németh
