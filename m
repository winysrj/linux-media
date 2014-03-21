Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:33296 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaCUThx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 15:37:53 -0400
Message-ID: <532C92BE.5030601@schinagl.nl>
Date: Fri, 21 Mar 2014 20:27:58 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
Reply-To: oliver+list@schinagl.nl
MIME-Version: 1.0
To: Jonathan McCrohan <jmccrohan@gmail.com>,
	Quentin Glidic <sardemff7+linuxtv@sardemff7.net>
CC: linux-media@vger.kernel.org
Subject: Re: dvb-apps build failure
References: <52F346EA.4070100@sardemff7.net> <20140310233953.GA3490@lambda.dereenigne.org>
In-Reply-To: <20140310233953.GA3490@lambda.dereenigne.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2014 12:39 AM, Jonathan McCrohan wrote:
> Hi Oliver,
>
> On Thu, 06 Feb 2014 09:25:14 +0100, Quentin Glidic wrote:
>> Hello,
>>
>> When building dvb-apps from the Mercurial repository, you hit the
>> following error:
>> install: cannot stat 'atsc/*': No such file or directory
Can you test it now? I removed the install section from the makefile and 
pushed it upstream. It worked on my outdated virtual machine, so it 
should be good now.

Sorry for the delay, was hoping one of the dvb-apps maintainers would 
pick it up ...

Olliver
>>
>> In the latest changeset
>> (http://linuxtv.org/hg/dvb-apps/rev/d40083fff895) scan files were
>> deleted from the repository but not their install rule.
>>
>> Could someone please remove the bottom part of util/scan/Makefile (from
>> line 31,
>> http://linuxtv.org/hg/dvb-apps/file/d40083fff895/util/scan/Makefile#l31)
>> to fix this issue?
>
> Ping on Quentin's behalf. I'd like to upload a new version of dvb-apps
> to Debian, but the build is currently broken after your recent patch.
>
> Would you be able to take a look?
>
> Thanks,
> Jon
>

