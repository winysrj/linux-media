Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8456 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaAPOsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 09:48:14 -0500
Message-id: <52D7F128.5080805@samsung.com>
Date: Thu, 16 Jan 2014 15:48:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: arun.kk@samsung.com
Cc: LMML <linux-media@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>
Subject: Re: Regarding FIMC-IS
References: <2881916.910641389869230202.JavaMail.weblogic@epv6ml07>
In-reply-to: <2881916.910641389869230202.JavaMail.weblogic@epv6ml07>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Cc: linux-media, devicetree ML

On 16/01/14 11:47, Arun Kumar K wrote:
> 
> Hi Sylwester,
> 
> Is there any update on Exynos5 FIMC-IS?
> I was hoping it will come in 3.14 kernel but didn't see any pull request yet.
> Please let me know if anything need to be done from my side.

My apologies for all those delays, AFAIR your patch series is now being
blocked only by a missing Ack on this patch:
https://patchwork.linuxtv.org/patch/21083

I didn't send another pull request because Mauro asked for an explicit
Ack for anything that is related to DT from a DT binding maintainer.
I understand that, at the same time I think it is a bit too restrictive
and successfully blocks any development involving DT in the media
subsystem in the mainline kernel (your patch series have been floating
on the mailing lists for over a year now...).

I think "all" we need is a review/ack of the above patch with regards
to DT binding correctness.

Regards,
Sylwester
