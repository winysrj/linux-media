Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:28122 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbZHGXw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 19:52:58 -0400
Received: by wf-out-1314.google.com with SMTP id 26so733813wfd.4
        for <linux-media@vger.kernel.org>; Fri, 07 Aug 2009 16:52:58 -0700 (PDT)
To: "chaithrika" <chaithrika@ti.com>
Cc: <rmk@arm.linux.org.uk>, <linux@arm.linux.org.uk>,
	<mchehab@infradead.org>, <hverkuil@xs4all.nl>,
	<linux-media@vger.kernel.org>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	"'Manjunath Hadli'" <mrh@ti.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>
Subject: Re: [PATCH v4] ARM: DaVinci: DM646x Video: Platform and board specific setup
References: <1249483662-9589-1-git-send-email-chaithrika@ti.com>
	<008c01ca158e$9ffbf770$dff3e650$@com>
	<87bpmr1ni0.fsf@deeprootsystems.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 07 Aug 2009 16:52:54 -0700
In-Reply-To: <87bpmr1ni0.fsf@deeprootsystems.com> (Kevin Hilman's message of "Fri\, 07 Aug 2009 11\:34\:47 -0700")
Message-ID: <87zlabkwq1.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Hilman <khilman@deeprootsystems.com> writes:

> "chaithrika" <chaithrika@ti.com> writes:
>
>> Russell,
>>
>> Requesting your ack on this patch.
>>
>
> Chaithrika, Mauro,
>
> We don't need Russell's ack on this.  You've incorporated his comments
> and my signoff is enough for stuff under arch/arm/mach-davinci/*
>
> Mauro, go ahead and merge this.
>

I forgot to add that I'll merge this into DaVinci git while waiting
for it to merge via v4l2.

Kevin
