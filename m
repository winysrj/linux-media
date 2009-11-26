Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1115 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbZKZWft (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 17:35:49 -0500
Received: from tschai.localnet (cm-84.208.105.24.getinternet.no [84.208.105.24])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id nAQMZs78067740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 26 Nov 2009 23:35:54 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: WARNINGS, 2.6.16-2.6.21: OK
Date: Thu, 26 Nov 2009 23:36:03 +0100
References: <200911262137.nAQLbCmW061365@smtp-vbr5.xs4all.nl>
In-Reply-To: <200911262137.nAQLbCmW061365@smtp-vbr5.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <200911262336.03954.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 26 November 2009 22:37:12 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> Results of the daily build of v4l-dvb:
> 
> date:        Thu Nov 26 20:48:58 CET 2009
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   13527:b3695bd384cc
> gcc version: gcc (GCC) 4.3.1
> hardware:    x86_64
> host os:     2.6.26
> 


> sparse (linux-2.6.31): ERRORS
> sparse (linux-2.6.32-rc8): ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.log

Hi all,

I have enabled the sparse checker again in the daily build. Take a quick
look at the log and check the sparse output against your driver code.

The 'bad constant expression' and 'cannot size expression' errors seem to be
mostly bogus. But most of the others seem to warrant a closer look.

I particularly liked this one:

v4l/ir-functions.c:68:8: warning: memset with byte count of 0

Someone should fix that one :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
