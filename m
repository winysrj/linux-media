Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEBAC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 14:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5857206BB
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 14:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbfAIOOj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 09:14:39 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41985 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731154AbfAIOOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 09:14:38 -0500
Received: from [IPv6:2001:420:44c1:2579:f8c4:4546:22d:c704] ([IPv6:2001:420:44c1:2579:f8c4:4546:22d:c704])
        by smtp-cloud7.xs4all.net with ESMTPA
        id hEcqgjtKeBDyIhEcugWyvz; Wed, 09 Jan 2019 15:14:36 +0100
Subject: Re: cron job: media_tree daily build: OK
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org, "Jasmin J." <jasmin@anw.at>
References: <4c43048d06a6c363dee1bb34e26643f3@smtp-cloud8.xs4all.net>
Message-ID: <e263595a-85c6-473a-0d3c-398d423b0973@xs4all.nl>
Date:   Wed, 9 Jan 2019 15:14:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <4c43048d06a6c363dee1bb34e26643f3@smtp-cloud8.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIglK2Pj1gcPiSobYA00KeeQ0wgu3IBxta9Gcaw/SOHWiSyug/CQM4i4g0WKP5UU/7z3bR7eVNkCwes6v9vdKYbRh8uazIq8wdqRAMDz8ZbOzL3+5Ou7
 2ea6xZ04RzTl4Da9j8uwXDYAQL2cNg/vomeZgLu/CpCW+zzmhdVUTNRHiiKTYOOkONxAVmC5WZhHPgE5sUNqb2Prk4+a8sQhhAie/t1+r/pwDLHx3qClen3t
 ebmNR/6UNi8HDZOZbDVTXNP+stglgULqMyfYzW2wJ1MzxOSVtU1jYr58DhlPt+CVc3ZYDDlXypK7rOruYKSc9Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/03/19 05:33, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.

Sorry, the mail from the cron job stopped working. It should be fixed now.

I also (hopefully) fixed compilation failures after the merge with 5.0-rc1.

Regards,

	Hans

> 
> Results of the daily build of media_tree:
> 
> date:			Thu Jan  3 05:00:12 CET 2019
> media-tree git hash:	4bd46aa0353e022c2401a258e93b107880a66533
> media_build git hash:	282066d93c925718ca9f49d4790fd044162694d6
> v4l-utils git hash:	1f6f0ffaaf10dc527c271b56b53ac6663035c516
> edid-decode git hash:	6def7bc83dfb0338632e06a8b14c93faa6af8879
> gcc version:		i686-linux-gcc (GCC) 8.2.0
> sparse version:		0.5.2
> smatch version:		0.5.1
> host hardware:		x86_64
> host os:		4.18.0-3-amd64
> 
> linux-git-arm-at91: OK
> linux-git-arm-davinci: OK
> linux-git-arm-multi: OK
> linux-git-arm-pxa: OK
> linux-git-arm-stm32: OK
> linux-git-arm64: OK
> linux-git-i686: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-sh: OK
> linux-git-x86_64: OK
> Check COMPILE_TEST: OK
> linux-3.10.108-i686: OK
> linux-3.10.108-x86_64: OK
> linux-3.11.10-i686: OK
> linux-3.11.10-x86_64: OK
> linux-3.12.74-i686: OK
> linux-3.12.74-x86_64: OK
> linux-3.13.11-i686: OK
> linux-3.13.11-x86_64: OK
> linux-3.14.79-i686: OK
> linux-3.14.79-x86_64: OK
> linux-3.15.10-i686: OK
> linux-3.15.10-x86_64: OK
> linux-3.16.57-i686: OK
> linux-3.16.57-x86_64: OK
> linux-3.17.8-i686: OK
> linux-3.17.8-x86_64: OK
> linux-3.18.123-i686: OK
> linux-3.18.123-x86_64: OK
> linux-3.19.8-i686: OK
> linux-3.19.8-x86_64: OK
> linux-4.0.9-i686: OK
> linux-4.0.9-x86_64: OK
> linux-4.1.52-i686: OK
> linux-4.1.52-x86_64: OK
> linux-4.2.8-i686: OK
> linux-4.2.8-x86_64: OK
> linux-4.3.6-i686: OK
> linux-4.3.6-x86_64: OK
> linux-4.4.159-i686: OK
> linux-4.4.159-x86_64: OK
> linux-4.5.7-i686: OK
> linux-4.5.7-x86_64: OK
> linux-4.6.7-i686: OK
> linux-4.6.7-x86_64: OK
> linux-4.7.10-i686: OK
> linux-4.7.10-x86_64: OK
> linux-4.8.17-i686: OK
> linux-4.8.17-x86_64: OK
> linux-4.9.131-i686: OK
> linux-4.9.131-x86_64: OK
> linux-4.10.17-i686: OK
> linux-4.10.17-x86_64: OK
> linux-4.11.12-i686: OK
> linux-4.11.12-x86_64: OK
> linux-4.12.14-i686: OK
> linux-4.12.14-x86_64: OK
> linux-4.13.16-i686: OK
> linux-4.13.16-x86_64: OK
> linux-4.14.74-i686: OK
> linux-4.14.74-x86_64: OK
> linux-4.15.18-i686: OK
> linux-4.15.18-x86_64: OK
> linux-4.16.18-i686: OK
> linux-4.16.18-x86_64: OK
> linux-4.17.19-i686: OK
> linux-4.17.19-x86_64: OK
> linux-4.18.12-i686: OK
> linux-4.18.12-x86_64: OK
> linux-4.19.1-i686: OK
> linux-4.19.1-x86_64: OK
> linux-4.20-rc1-i686: OK
> linux-4.20-rc1-x86_64: OK
> apps: OK
> spec-git: OK
> sparse: WARNINGS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/index.html
> 

