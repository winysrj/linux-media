Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B48CC282CC
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D8D220880
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="dpe8f2qZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfA1Isn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:48:43 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48080 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfA1Isn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 03:48:43 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C6E4485;
        Mon, 28 Jan 2019 09:48:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1548665321;
        bh=iAGluW7XxbOE3Pt4vcwamTyn+nEa1VjcmTjyOQSLMhE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dpe8f2qZmBDZ77amqdgKTcCtUVCUrmPOksBuJ/TGmR9WhAub6hQL9IN8eAcmNDGyu
         Z1NoVaSK5VH/oAkqJgaETSe6Z+GukjofguJCtn9lGLUf5/H7V6Qh/FaCwCYH5Jmc51
         CV+LWeqR0zWdpayKwYQsy8XI/XT8t+vMGEYKFseA=
Subject: Re: ipu3-imgu 0000:00:05.0: required queues are disabled
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        sakari.ailus@linux.intel.com
Cc:     bingbu.cao@intel.com, yong.zhi@intel.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        LibCamera Devel <libcamera-devel@lists.libcamera.org>
References: <7F8ED1B6-5070-437A-A745-AE017D8CE0DF@canonical.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <ac9cd5cd-82af-48c7-5b12-adacb540480c@ideasonboard.com>
Date:   Mon, 28 Jan 2019 08:48:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <7F8ED1B6-5070-437A-A745-AE017D8CE0DF@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kai-Heng,

On 27/01/2019 05:56, Kai-Heng Feng wrote:
> Hi,
> 
> We have a bug report [1] that the ipu3 doesn’t work.
> Does ipu3 need special userspace to work?

Yes, it will need further userspace support to configure the pipeline,
and to provide 3A algorithms for white balance, focus, and exposure
times to the sensor.

We are developing a stack called libcamera [0] to support this, but it's
still in active development and not yet ready for use. Fortunately
however, IPU3 is one of our primary initial targets.

[0] https://www.libcamera.org/

> [1] https://bugs.launchpad.net/bugs/1812114

I have reported similar information to the launchpad bug entry.

It might help if we can get hold of a Dell 7275 sometime although I
think Mauro at least has one ?

If this is a priority for Canonical, please contact us directly.

> Kai-Heng
--
Regards

Kieran
