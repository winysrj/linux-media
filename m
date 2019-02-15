Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98437C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 07:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F60121925
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 07:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389847AbfBOHd3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 02:33:29 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:57336 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727993AbfBOHd2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 02:33:28 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id uXzvgHJr24HFnuXzygrucg; Fri, 15 Feb 2019 08:33:26 +0100
Subject: Re: cron job: media_tree daily build: OK
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
References: <c10c676bf2fdd329ec1d31c904370614@smtp-cloud8.xs4all.net>
Message-ID: <26dd148c-51ec-a2d0-0814-995934a192e2@xs4all.nl>
Date:   Fri, 15 Feb 2019 08:33:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c10c676bf2fdd329ec1d31c904370614@smtp-cloud8.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfORnGPOEOLgqTdMogPRnTbiFWfRiUSYxSMtfRc1i0ciyCJatMcreBw2KflSKLPbVc+oIFXAqKBtRMia5/78umzyKdsa6oTbpAjOukQaaCs0L2x0xdN76
 HZofXaftFWKN1kviiDmqqXjWP8gMEp4UbzNDftlqihljntwCMof9JV0loC3bhceCYhLlUBRWLzFQGQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/15/19 5:36 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:			Fri Feb 15 05:00:10 CET 2019
> media-tree git hash:	6fd369dd1cb65a032f1ab9227033ecb7b759656d
> media_build git hash:	c23276037794bae357fa8d23e3a4f11af9ad46e9
> v4l-utils git hash:	59f9840781aab464c1331dcdb82e63dd0544b5c6
> edid-decode git hash:	6def7bc83dfb0338632e06a8b14c93faa6af8879
> gcc version:		i686-linux-gcc (GCC) 8.2.0
> sparse version:		0.5.2
> smatch version:		0.5.1
> host hardware:		x86_64
> host os:		4.19.0-1-amd64
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
> linux-4.20.1-i686: OK
> linux-4.20.1-x86_64: OK
> linux-5.0-rc1-i686: OK
> linux-5.0-rc1-x86_64: OK
> apps: OK
> spec-git: OK
> sparse: WARNINGS
> smatch: ERRORS
> virtme: ERRORS
> virtme: 

Hmm, the regression testing almost worked if it wasn't for a missing
/usr/local/bin in my PATH variable when called from crontab.

Better luck next run :-)

Regards,

	Hans

> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Friday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Friday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/index.html
> 

