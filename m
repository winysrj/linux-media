Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2459 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0CGM24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 07:28:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21: OK
Date: Sun, 7 Mar 2010 13:29:25 +0100
Cc: linux-media@vger.kernel.org
References: <201003061952.o26JqdTY011655@smtp-vbr11.xs4all.nl> <4B939A00.5090208@freemail.hu>
In-Reply-To: <4B939A00.5090208@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003071329.25397.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 07 March 2010 13:20:16 Németh Márton wrote:
> Hello Hans,
> 
> Hans Verkuil wrote:
> > This message is generated daily by a cron job that builds v4l-dvb for
> > the kernels and architectures in the list below.
> 
> Would you mind adding a new test case for your test environment? This would
> be a test case with the newest stable kernel without Power Management support
> (CONFIG_PM not defined in .config). It seems some problem could be caught with
> this test case.

Hmm, it is not that easy to do that. I just use default configs or
allyes/allmodconfig. Is this for particular architectures?

Note that I'm working on getting the daily build working for the git tree as well.
I'm currently testing my build changes to see if I didn't forget anything. If
all goes well then the today's build will support git.

Regards,

	Hans

> 
> Regards,
> 
> 	Márton Németh
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
