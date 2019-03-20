Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82A3C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 15:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8169E2186A
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 15:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfCTPH7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:07:59 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:60667 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726595AbfCTPH7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 11:07:59 -0400
Received: from [IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e] ([IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6cothdwVBeXb86couhD4KW; Wed, 20 Mar 2019 16:07:58 +0100
Subject: Re: [PATCH] media: Kconfig files: use the right help coding style
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <b60a5b8dcf49af9f2c60ae82e0383ee8e62a9a52.1553089314.git.mchehab+samsung@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <467bee99-68d4-e963-a56e-65f6c078e513@xs4all.nl>
Date:   Wed, 20 Mar 2019 16:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <b60a5b8dcf49af9f2c60ae82e0383ee8e62a9a52.1553089314.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOuB6a3lRzF539PnC0t8BydIr6ydf3muWOzzOfcvx+67+7Yowmk162AWNbR6CI5lmuyBDrKLVgiKuE70LzZX/3ZgFxoD634l+qzgZOIXDhg7kcT0eY8k
 D5X4PY4UF6kmE3ImCPDVCHbQc4EqtOdu5DxjWCTj9pNW2omaRTaAT8Dp7gUUhtc3VcAmhcIFzuhDjDaqnHMRFpeHyxY00NL7l3XQRwKQiQ0yhcCgeotxgjV4
 dBYgCbrrrE2+6z4Y1arqMWMst/HqG31CQ/3h1wV0FzNw4Jw9Ycm1OCAmdIMcTgjTS2UkNksV23Mpa/0L6OPErptQfBAlhkmtnzHBttAx3e9iPqTWFPm9G6V4
 9blyIQZG
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/20/19 2:41 PM, Mauro Carvalho Chehab wrote:
> Checkpatch wants to use 'help' instead of '---help---':
> 
> 	WARNING: prefer 'help' over '---help---' for new help texts
> 
> Let's change it globally at the media subsystem, as otherwise people
> would keep using the old way.

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans
