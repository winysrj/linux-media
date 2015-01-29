Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53874 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbA2RFt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 12:05:49 -0500
Received: by mail-lb0-f176.google.com with SMTP id z12so30344345lbi.7
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 09:05:48 -0800 (PST)
Message-ID: <54CA6869.9060100@cogentembedded.com>
Date: Thu, 29 Jan 2015 20:05:45 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-6-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-6-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 01/29/2015 07:19 PM, William Towle wrote:

> This adds V4L2_MBUS_FMT_RGB888_1X24 input format support
> which is used by the ADV7612 chip.

> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>

    I wonder why it hasn't been merged still? It's pending since 2013, and I'm 
seeing no objections to it...

WBR, Sergei

