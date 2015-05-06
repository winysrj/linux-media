Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36840 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbbEFFqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 01:46:55 -0400
Received: by lbbqq2 with SMTP id qq2so144717103lbb.3
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 22:46:53 -0700 (PDT)
Date: Wed, 6 May 2015 08:46:49 +0300
From: Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	sergei.shtylyov@cogentembedded.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
Message-ID: <20150506084649.3bc76d27@bones>
In-Reply-To: <5004544.CpPfGJfHMn@avalon>
References: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<5004544.CpPfGJfHMn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 04 May 2015 02:32:05 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Mikhail,
> 
> Thank you for the patch. Please see below for a (partial) review.
> 
> On Thursday 30 April 2015 00:53:29 Mikhail Ulyanov wrote:
> > Here's the the driver for the Renesas R-Car JPEG processing unit
> > driver.
> > 
> > The driver is implemented within the V4L2 framework as a mem-to-mem
> > device. It presents two video nodes to userspace, one for the
> > encoding part, and one for the decoding part.
> > 
> > It was found that the only working mode for encoding is no markers
> > output, so we generate it with software. In current version of
> > driver we also use software JPEG header parsing because with
> > hardware parsing performance is lower then desired.
> 
> Just out of curiosity, what is the performance impact of hardware
> parsing ?
Looks like feature of IP core. Header parsing complete/continue
sequence make it work 1.5-2 times longer, so as i remember maximum
performance with 1Mp YUV420 JPEG decoding was ~60 FPS. 
