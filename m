Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6D7C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 01:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36C392063F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 01:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="bQxdy6hm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfCMBDL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 21:03:11 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:43418 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfCMBDL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 21:03:11 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8A04531C;
        Wed, 13 Mar 2019 02:03:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552438988;
        bh=GOxNW4a22evfZyRTGVcvLfFJitYOSgVU0fZiaVESznY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQxdy6hmyBjzSdWvqrX+FaArswQM9ztQ8AJ36qOB7/kyID7HDvbH+mTH9TFqD7F4H
         eTzcFRgd314EkEJ/35E5Vy5c06C8yxnDaO5ASosIEz6zGX7diLNg4WWwkWdCE4USxg
         fkYfdywrUwq043oqzpImCt5ucH+JWoenDti96cNs=
Date:   Wed, 13 Mar 2019 03:03:01 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Amila Manoj <amilamanoj@gmail.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-uvc-devel@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-uvc-devel] HD Camera (4e45:5501) support
Message-ID: <20190313010301.GN891@pendragon.ideasonboard.com>
References: <CAN6+69JTiWpiiOeRn2jAuW__sx2J2p8FWUts1SpLeUoAC=W4vQ@mail.gmail.com>
 <c8534224-e8eb-8b77-a4ac-bcdbfd784a1c@ideasonboard.com>
 <20190302163400.GC4682@pendragon.ideasonboard.com>
 <CAN6+69+pRnH6zArTAa+2F-B9UDcKHE3DjLEQ0QHqP59CbmWTag@mail.gmail.com>
 <20190305134607.GA10692@pendragon.ideasonboard.com>
 <CAN6+69+0ucQ+SOqCpB3g0X+5MXEVhr7deZ8A2hS0kE_6XrjOnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAN6+69+0ucQ+SOqCpB3g0X+5MXEVhr7deZ8A2hS0kE_6XrjOnA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Amila,

On Tue, Mar 05, 2019 at 04:50:47PM +0100, Amila Manoj wrote:
> Hi Laurent,
> 
> Thank you very much for the reply.
> 
> I tried it on a Windows 10 computer and it worked fine without
> installing any additional software.
> 
> Also managed to capture USB traffic on Linux (didn't capture on Windows yet).
> I don't see a lot of traffic, most of the messages are USB and USBHID
> protocol messages for GET_STATUS, SET_FEATURE, GET_DESCRIPTOR etc.
> 
> There is only one USBVIDEO protocol message for GET_CUR (0x81). Seems
> like this request fails the error "No such file or directory (-ENOENT)
> (-2). Does this sound like a bug in firmware / cause for the error we
> saw in dmesg output?

Yes, that error corresponds to the error message printed by the driver.
My guess is that Windows would send a different sequence of requests,
and the camera firmware assumes this will always be the case. The order
of the requests received from a Linux host doesn't match that, and the
firmware gets confused.

> Here's the full text of USBVIDEO request and response:
> 
> REQUEST:
> 
> Frame 86: 64 bytes on wire (512 bits), 64 bytes captured (512 bits) on
> interface 0
> USB URB
>     [Source: host]
>     [Destination: 2.13.0]
>     URB id: 0xffff89299a435600
>     URB type: URB_SUBMIT ('S')
>     URB transfer type: URB_CONTROL (0x02)
>     Endpoint: 0x80, Direction: IN
>     Device: 13
>     URB bus id: 2
>     Device setup request: relevant (0)
>     Data: not present ('<')
>     URB sec: 1551797452
>     URB usec: 468271
>     URB status: Operation now in progress (-EINPROGRESS) (-115)
>     URB length [bytes]: 34
>     Data length [bytes]: 0
>     [Response in: 87]
>     Interval: 0
>     Start frame: 0
>     Copy of Transfer Flags: 0x00000200
>     Number of ISO descriptors: 0
>     [bInterfaceClass: Video (0x0e)]
> URB setup
> bRequest: GET CUR (0x81)
> Control Selector: Probe (0x01)
> Interface: 0x01
> Entity: 0x00
> wLength: 34
> 
> RESPONSE:
> 
> Frame 87: 64 bytes on wire (512 bits), 64 bytes captured (512 bits) on
> interface 0
> USB URB
>     [Source: 2.13.0]
>     [Destination: host]
>     URB id: 0xffff89299a435600
>     URB type: URB_COMPLETE ('C')
>     URB transfer type: URB_CONTROL (0x02)
>     Endpoint: 0x80, Direction: IN
>     Device: 13
>     URB bus id: 2
>     Device setup request: not relevant ('-')
>     Data: present (0)
>     URB sec: 1551797457
>     URB usec: 587755
>     URB status: No such file or directory (-ENOENT) (-2)
>     URB length [bytes]: 0
>     Data length [bytes]: 0
>     [Request in: 86]
>     [Time from request: 5.119484000 seconds]
>     Unused Setup Header
>     Interval: 0
>     Start frame: 0
>     Copy of Transfer Flags: 0x00000200
>     Number of ISO descriptors: 0
>     [bInterfaceClass: Video (0x0e)]
> [Interface: 0x01]
> [Entity: 0x00]
> [Control Selector: Probe (0x01)]

-- 
Regards,

Laurent Pinchart
