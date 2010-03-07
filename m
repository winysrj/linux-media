Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:52656 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0CGNA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 08:00:57 -0500
Message-ID: <4B93A383.1000500@freemail.hu>
Date: Sun, 07 Mar 2010 14:00:51 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21:
 OK
References: <201003061952.o26JqdTY011655@smtp-vbr11.xs4all.nl> <4B939A00.5090208@freemail.hu> <201003071329.25397.hverkuil@xs4all.nl>
In-Reply-To: <201003071329.25397.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil írta:
> On Sunday 07 March 2010 13:20:16 Németh Márton wrote:
>> Hello Hans,
>>
>> Hans Verkuil wrote:
>>> This message is generated daily by a cron job that builds v4l-dvb for
>>> the kernels and architectures in the list below.
>> Would you mind adding a new test case for your test environment? This would
>> be a test case with the newest stable kernel without Power Management support
>> (CONFIG_PM not defined in .config). It seems some problem could be caught with
>> this test case.
> 
> Hmm, it is not that easy to do that. I just use default configs or
> allyes/allmodconfig. Is this for particular architectures?

No, no special architecture is necessary. The idea is that a lot of drivers
are using the CONFIG_PM in an '#ifdef' and different code will be compiled
when the CONFIG_PM is defined and when it is not defined.

> Note that I'm working on getting the daily build working for the git tree as well.
> I'm currently testing my build changes to see if I didn't forget anything. If
> all goes well then the today's build will support git.

Good to hear about this new feature.

Regards,

	Márton Németh

