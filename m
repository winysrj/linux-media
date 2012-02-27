Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51782 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2B0UB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 15:01:26 -0500
Received: by wejx9 with SMTP id x9so526796wej.19
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 12:01:25 -0800 (PST)
Message-ID: <4F4BE111.6090805@gmail.com>
Date: Mon, 27 Feb 2012 21:01:21 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.4] gspca for_v3.4
References: <20120227130606.1f432e7b@tele>
In-Reply-To: <20120227130606.1f432e7b@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-François,

On 02/27/2012 01:06 PM, Jean-Francois Moine wrote:
> The following changes since commit a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e:
> 
>    [media] xc5000: declare firmware configuration structures as static const (2012-02-14 17:22:46 -0200)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/jfrancois/gspca.git for_v3.4
> 
> for you to fetch changes up to 1b9ace2d5769c1676c96a6dc70ea84d2dea17140:
> 
>    gspca - zc3xx: Set the exposure at start of hv7131r (2012-02-27 12:49:49 +0100)
> 
> ----------------------------------------------------------------
> Jean-François Moine (13):
>        gspca - pac7302: Add new webcam 06f8:301b
>        gspca - pac7302: Cleanup source
>        gspca - pac7302: Simplify the function pkt_scan
>        gspca - pac7302: Use the new video control mechanism
>        gspca - pac7302: Do autogain setting work
>        gspca - sonixj: Remove the jpeg control
>        gspca - sonixj: Add exposure, gain and auto exposure for po2030n
>        gspca - zc3xx: Adjust the JPEG decompression tables

This patch will conflict with patch:

 gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support

from my recent pull request http://patchwork.linuxtv.org/patch/10022/

How should we proceed with that ? Do you want me to remove the above patch 
from my pull request, or would you rebase your change set on top of mine ?

--
Best regards,
Sylwester

>        gspca - zc3xx: Do automatic transfer control for hv7131r and pas202b
>        gspca - zc3xx: Remove the low level traces
>        gspca - zc3xx: Cleanup source
>        gspca - zc3xx: Fix bad sensor values when changing autogain
>        gspca - zc3xx: Set the exposure at start of hv7131r
> 
>   Documentation/video4linux/gspca.txt |    1 +
>   drivers/media/video/gspca/pac7302.c |  583 ++++++++++-------------------------
>   drivers/media/video/gspca/sonixj.c  |  185 +++++++++---
>   drivers/media/video/gspca/zc3xx.c   |  295 ++++++++++++------
>   4 files changed, 511 insertions(+), 553 deletions(-)
> 

