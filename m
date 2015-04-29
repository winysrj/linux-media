Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:36403 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbD2WIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 18:08:21 -0400
Received: by lagv1 with SMTP id v1so30737148lag.3
        for <linux-media@vger.kernel.org>; Wed, 29 Apr 2015 15:08:19 -0700 (PDT)
Message-ID: <55415651.70403@cogentembedded.com>
Date: Thu, 30 Apr 2015 01:08:17 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com
CC: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
References: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com> <5541542F.7010505@cogentembedded.com>
In-Reply-To: <5541542F.7010505@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/30/2015 12:59 AM, Sergei Shtylyov wrote:

>> Here's the the driver for the Renesas R-Car JPEG processing unit driver.

>     One "the" is enough. And one "driver" too, you probbaly forgot to remove
> the word at the end.

>> The driver is implemented within the V4L2 framework as a mem-to-mem device.  It

>     Perhaps "memory-to-memory"?

    Oops, I thought I was still doing internal review. :-)

[...]

WBR, Sergei

