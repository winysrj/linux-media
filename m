Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77EBC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 10:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C932087F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 10:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfAGKV7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 05:21:59 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45387 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbfAGKV6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 05:21:58 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gS2bgEVFyBDyIgS2fgN6cT; Mon, 07 Jan 2019 11:21:57 +0100
Subject: Re: [RFC PATCH 0/5] v4l2-ctl: list controls values in a
 machine-readable format
To:     Antonio Ospite <ao2@ao2.it>, linux-media@vger.kernel.org
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
 <20190103180102.12282-1-ao2@ao2.it>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <27028bd5-c188-1afa-47bc-bd05ac8ecd59@xs4all.nl>
Date:   Mon, 7 Jan 2019 11:21:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190103180102.12282-1-ao2@ao2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDA5Egu/AoDnub/b7pyZvzmFOBT0/HDBHFykcUNEmrt9kLJPNV50KmQc180iYg6QYd+vhq2M/V0ZQpXrr1KHWDq1kmJPHkpymGT3+NMZvH8aDfo8u1Wj
 hjN7L0qdxWZI7B7H+fkKsEdP2nbDIYAnEjECkCbmoQqUwSgMZd5r3kzK7BtjcBAj3kFcubXtk7IuPU2y83iLxoWhS3UFRmA16rM=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/03/2019 07:00 PM, Antonio Ospite wrote:
> Hi,
> 
> here is an experiment about listing controls values with v4l2-ctl in
> a way that makes it more easy to reload them, I would use something like
> that for https://git.ao2.it/v4l2-persistent-settings.git/
> 
> Patches 1 and 2 are just warm-up patches to get me familiar again with
> the v4l2-ctrl codebase, patch 2 is a small preparatory cleanup, and
> patches 4 and 5 showcase the idea.
> 
> Thanks,
>    Antonio
> 
> Antonio Ospite (5):
>   v4l2-ctl: list controls with menus when OptAll is specified
>   v4l2-ctl: list once when both OptListCtrls and OptListCtrlsMenus are
>     there

I merged these first two patches.

>   v4l2-ctl: use a dedicated function to print the control class name
>   v4l2-ctl: abstract the mechanism used to print the list of controls
>   v4l2-ctl: add an option to list controls in a machine-readable format

The others need more work, see my review of the last patch.

Thanks for working on this!

Regards,

	Hans

> 
>  utils/v4l2-ctl/v4l2-ctl-common.cpp | 95 +++++++++++++++++++++++++-----
>  utils/v4l2-ctl/v4l2-ctl.1.in       |  4 ++
>  utils/v4l2-ctl/v4l2-ctl.cpp        |  3 +-
>  utils/v4l2-ctl/v4l2-ctl.h          |  1 +
>  4 files changed, 88 insertions(+), 15 deletions(-)
> 

