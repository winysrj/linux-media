Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AC2C43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 09:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D232177B
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 09:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbfALJra (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 04:47:30 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:39197 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbfALJr3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 04:47:29 -0500
Received: from [IPv6:2001:983:e9a7:1:e8cf:8a82:99b1:1cd8] ([IPv6:2001:983:e9a7:1:e8cf:8a82:99b1:1cd8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id iFt0gOfJvBDyIiFt1gkzIa; Sat, 12 Jan 2019 10:47:28 +0100
Subject: Re: cron job: media_tree daily build: ERRORS
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
References: <7b2fad561a3695cede5c46ef122da4d8@smtp-cloud7.xs4all.net>
Cc:     "Jasmin J." <jasmin@anw.at>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Message-ID: <cf25f665-1e71-045e-748b-9fbba6df15ca@xs4all.nl>
Date:   Sat, 12 Jan 2019 10:47:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <7b2fad561a3695cede5c46ef122da4d8@smtp-cloud7.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGHWucZdL+ZwXh59J3PXv+rtNnw95X0OxTlo57kpqgKLlwkoU1SpNo8T0Mwsyum5V5FYtQGNDSRK4CPSK1OeBwG5FdXtZFMHPCnA7295S+B+WHSFrhJ6
 ZFgl1KH87O5DLkZ4UDAku6tyKjbITkW5Nmk6Z/CTNKGASybIIUKV07smDRcPbDLTPyPA5MVUxcHZj4KG66LDaQWED5LmHO6g4nFuXgU3SRbfJIiqU+f66cdF
 8W3lgSXtHzEoNWX05C+dRqbZPF6G/mXjwTnEiUkR4KBgey9rNyTwg7K/Ov/8drWJRgKAEvSsn8zc8DRUfLArhAMbdniFoNG1+C0WUCmaIRo=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/12/19 5:38 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:			Sat Jan 12 05:00:50 CET 2019
> media-tree git hash:	1e0d0a5fd38192f23304ea2fc2b531fea7c74247
> media_build git hash:	8851c6e626dac550d6798e162c6b4f5a41bc13ec
> v4l-utils git hash:	a4f1a58d1138f26b5e2cc294687598ba323eeeca
> edid-decode git hash:	6def7bc83dfb0338632e06a8b14c93faa6af8879
> gcc version:		i686-linux-gcc (GCC) 8.2.0
> sparse version:		0.5.2
> smatch version:		0.5.1
> host hardware:		x86_64
> host os:		4.19.0-1-amd64
> 

<snip>

> linux-4.14.74-i686: OK
> linux-4.14.74-x86_64: ERRORS
> linux-4.15.18-i686: OK
> linux-4.15.18-x86_64: ERRORS
> linux-4.16.18-i686: OK
> linux-4.16.18-x86_64: ERRORS
> linux-4.17.19-i686: OK
> linux-4.17.19-x86_64: ERRORS
> linux-4.18.12-i686: OK
> linux-4.18.12-x86_64: ERRORS
> linux-4.19.1-i686: OK
> linux-4.19.1-x86_64: ERRORS
> linux-4.20.1-i686: OK
> linux-4.20.1-x86_64: ERRORS
> linux-5.0-rc1-i686: OK
> linux-5.0-rc1-x86_64: ERRORS

These errors are due to a binutils-2.31 bug that surfaced when elfutils
was upgrade to 0.175.

I've applied patches for the binutils used during the daily build.

See https://bugs.archlinux.org/task/61151 for more details.

Regards,

	Hans

> apps: OK
> spec-git: OK
> sparse: WARNINGS
> 
> Logs weren't copied as they are too large (3364 kB)
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/index.html
> 

