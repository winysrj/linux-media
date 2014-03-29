Return-path: <linux-media-owner@vger.kernel.org>
Received: from Gaia.Eases.nl ([46.182.217.96]:60483 "EHLO Gaia.Eases.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaC2WN5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 18:13:57 -0400
Received: from [192.168.20.100] (D978A948.cm-3-1c.dynamic.ziggo.nl [217.120.169.72])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by Gaia.Eases.nl (Postfix) with ESMTPSA id CE8F86668
	for <linux-media@vger.kernel.org>; Sat, 29 Mar 2014 22:56:04 +0100 (CET)
Message-ID: <53374174.4000909@podiumbv.nl>
Date: Sat, 29 Mar 2014 22:56:04 +0100
From: "Podium B.V." <mailinglist@podiumbv.nl>
Reply-To: mailinglist@podiumbv.nl
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: FireDTV / w_scan / no data from NIT(actual)
References: <533731B9.7030805@PodiumBV.com>
In-Reply-To: <533731B9.7030805@PodiumBV.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Steve,

I am already using the "-F" and the "-t 3" option...
So a longer time waiting is not possible.

     -F       use long filter timeout
     -t N   tuning timeout
                   1 = fastest [default]
                   2 = medium
                   3 = slowest

And there are "NIT(actual) table" on the frequencies.
My result should be very much like: http://www.dtvmonitor.com/nl/ziggo-noord

But I also search more what my problem could be and I discovered that
most examples say:

     using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

and i only get:

     using '/dev/dvb/adapter0/frontend0'

But I guess demuxing is necessary to get the "NIT(actual) table", isn't it ?






On 29-03-14 14:44, Steven Toth wrote:
 >> Only is goes already wrong with the init scan.... I only get: "Info: 
no data
 >> from NIT(actual)"
 > I suspect either their isn't a NIT(actual) table on your frequency, or
 > the tool isn't waiting long enough for the NIT table to arrive.
 >
 > - Steve






