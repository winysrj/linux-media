Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B7DC5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 13:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4D812084E
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 13:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4D812084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbeLJNoS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 08:44:18 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:44904 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbeLJNoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 08:44:17 -0500
Received: from [IPv6:2001:983:e9a7:1:153f:c992:21d9:6742] ([IPv6:2001:983:e9a7:1:153f:c992:21d9:6742])
        by smtp-cloud9.xs4all.net with ESMTPA
        id WLr3g28TyMlDTWLr4g5emM; Mon, 10 Dec 2018 14:44:15 +0100
Subject: Re: [RFC] Create test script(s?) for regression testing
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl>
Message-ID: <9c6841e8-af5d-358b-7d09-7f572155cca9@xs4all.nl>
Date:   Mon, 10 Dec 2018 14:44:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAlVauptOCRHalToHglcha787QUu9oZRvcSsugm+EOWko76j3W1iDyMR2cxP6LMFMmRv6ONs04qheFxmIOWVJMcF3sQHmde4w0b0odVpLyoYbv0QcU0D
 4lKKEGmLyBzXNpPkwyAQEqWgE+dh2cHFZy+O7O/322pQPq6WnuySFMTiu9SPrY4PJP/UDGuKaTKY0/GBu4XlT4gJT/bYkPWqO9ltLD5tC5+djoeJ0/1mrNiz
 xrFbDKLJfXx6r9wEgJTIjqU3j+hE1c58GxCuMSC1GfeskmN/3xRoVh6N+kTccZt4u91jiJKHv7u2RQYlp3QO69WIMDn2enmgxw2DcHcLvVYNy+HvBMgXTRjn
 tdH+6PUx0UHPrlGs1ThXJu3bINwYqOtER5aq2Vlz+Iu9Og6ZX7l8C7ayv4NeM4k89HiTtaY7Pn75Y64qMY6LaRXnfkJYVQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A quick status update regarding creating test scripts for regression
testing on kernelci.

I'm also CC-ing Dmitry to give an update on the work fixing syzkaller bugs.

On 11/6/18 9:37 AM, Hans Verkuil wrote:
> Hi all,
> 
> After the media summit (heavy on test discussions) and the V4L2 event regression
> we just found it is clear we need to do a better job with testing.
> 
> All the pieces are in place, so what is needed is to combine it and create a
> script that anyone of us as core developers can run to check for regressions.
> The same script can be run as part of the kernelci regression testing.
> 
> We have four virtual drivers: vivid, vim2m, vimc and vicodec. The last one
> is IMHO not quite good enough yet for testing: it is not fully compliant to the
> upcoming stateful codec spec. Work for that is planned as part of an Outreachy
> project.

This Outreachy project started last week, so hopefully we'll have something that
is usable by January.

> 
> My idea is to create a script that is maintained as part of v4l-utils that
> loads the drivers and runs v4l2-compliance and possibly other tests against
> the virtual drivers.
> 
> It should be simple to use and require very little in the way of dependencies.
> Ideally no dependencies other than what is in v4l-utils so it can easily be run
> on an embedded system as well.

I have a simple script:

modprobe vivid no_error_inj=1 n_devs=3 multiplanar=1,2,1
modprobe vim2m
modprobe vimc

v4l2-ctl -d0 -i3 -v width=3840,height=2160,pixelformat=XR24
v4l2-ctl -d1 -o1 -x width=3840,height=2160,pixelformat=XR24
v4l2-ctl -d2 -i3 -v width=3840,height=2160,pixelformat=XR24
v4l2-ctl -d3 -o1 -x width=3840,height=2160,pixelformat=XR24
v4l2-ctl -d4 -i3 -v width=3840,height=2160,pixelformat=XR24

v4l2-compliance -m0 -e4 -s10
v4l2-compliance -m1 -e4 -s10

v4l2-compliance -m3 -e4 -s10
v4l2-compliance -m4 -e4 -s10

But there are too many failures at the moment. Most are fixed, but several
first need to be merged into the 4.20 mainline kernel before they can be
backported to our master branch.

Once they are backported, then there is still one outstanding vivid/vimc failure,
fixed in this series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg136900.html

That won't make 4.21, but hopefully it will make 4.22.

This is probably the main blocker for the kernelci regression test.

vimc fails at several places, but most are known API issues that we really need
to nail down at some point. Finding time is the issue, but in the meantime I
can probably downgrade the errors to warnings in v4l2-compliance.

In addition, work is ongoing to make the topology configurable with configfs,
and I think we can postpone regression testing with vimc until that is merged
(I hope for 4.22).

> For a 64-bit kernel it should run the tests both with 32-bit and 64-bit
> applications.

Haven't done that yet.

> 
> It should also test with both single and multiplanar modes where available.

That's done (see vivid multiplanar module option in the script).

> 
> Since vivid emulates CEC as well, it should run CEC tests too.

Not done yet.

> 
> As core developers we should have an environment where we can easily test
> our patches with this script (I use a VM for that).
> 
> I think maintaining the script (or perhaps scripts) in v4l-utils is best since
> that keeps it in sync with the latest kernel and v4l-utils developments.
> 
> Comments? Ideas?

Regarding fixing the open syzkaller issues: most is done, but there is one fix
still pending:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg136512.html

It's more complex than I'd like, but I'm not sure if it can be improved.

I will have to take another look when 4.22 opens.

This patch series fixes issues when the filehandle is dupped and different
fds can do actions in parallel that would otherwise not happen.

Regards,

	Hans
