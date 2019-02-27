Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE20C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 12:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 190572075B
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 12:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbfB0MwC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:52:02 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47072 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730096AbfB0MwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 07:52:02 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 7595E280013
Message-ID: <fad75e466ef42e535cea8f513fa872d70a67fa22.camel@collabora.com>
Subject: Re: urb issue with an spca561 webcam
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     softwarebugs <softwarebugs@protonmail.com>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Date:   Wed, 27 Feb 2019 09:51:53 -0300
In-Reply-To: <UfTIBB2qMOzL9TCIVwm4hSW9pUthqA6JzWVDiqoitgrGjWA1oRQchJUpPY4gzQ6ZbqhAfyU12_A7uleS2mJYJdC6hg3tUF0VMAjjO7lsO_I=@protonmail.com>
References: <UfTIBB2qMOzL9TCIVwm4hSW9pUthqA6JzWVDiqoitgrGjWA1oRQchJUpPY4gzQ6ZbqhAfyU12_A7uleS2mJYJdC6hg3tUF0VMAjjO7lsO_I=@protonmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

+linux-media

On Fri, 2018-11-23 at 23:37 +0000, softwarebugs wrote:
> After each time I click to stop capturing, the below messages are logged.
> 
> spca561 : urb status: -2
> gspca_main: usb_submit_urb() ret -1
> spca561 : urb status: -2
> gspca_main: usb_submit_urb() ret -1
> spca561 : urb status: -2
> gspca_main: usb_submit_urb() ret -1
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/media/usb/gspca?h=v4.19.4&id=6992effe5344ceba1c53fd1a062df57e820b27cd


