Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:43996 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759035AbcBTRk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 12:40:29 -0500
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
To: Jurgen Kramer <gtmkramer@xs4all.nl>,
	Olli Salonen <olli.salonen@iki.fi>
References: <1436697509.2446.14.camel@xs4all.nl>
 <1440352250.13381.3.camel@xs4all.nl> <55F332FE.7040201@mbox200.swipnet.se>
 <1442041326.2442.2.camel@xs4all.nl>
 <CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
 <1454007436.13371.4.camel@xs4all.nl>
 <CAAZRmGwuinufZpCpTs8t+BRyTcfio-4z34PCKH7Ha3J+dxXNqw@mail.gmail.com>
 <56ADCBE4.6050609@mbox200.swipnet.se>
 <CAAZRmGy21S+qkrC9d0hz02J98woUc9p+LtnhK8Det=yWmb_myg@mail.gmail.com>
 <56C88CEB.3080907@mbox200.swipnet.se> <1455988859.21645.6.camel@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <56C8A510.8000204@mbox200.swipnet.se>
Date: Sat, 20 Feb 2016 18:40:32 +0100
MIME-Version: 1.0
In-Reply-To: <1455988859.21645.6.camel@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-02-20 18:20, Jurgen Kramer wrote:
> On Sat, 2016-02-20 at 16:57 +0100, Torbjorn Jansson wrote:
>> so something else is broken too.
>>
> I have been using the patches for a few days. So far everything works
> great (using MythTV). Scanning with dvbv5_scan does indeed not work
> (never did for me). w_scan works though.
>

interesting.
sounds like i need to test this again.

am i right in assuming that you are running mythtv 0.27 or have you 
switched the newer code?
reason for asking is because 0.27 don't know how to change between t & 
t2 and it relies on the driver to auto switch but this fixed (or will be 
once released) in 0.28

maybe someone here can explain why dvbv5-scan doesn't work with this 
dvbsky card?
or should i retest with latest code from media_tree ?
