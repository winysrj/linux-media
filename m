Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:53694 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752678AbeFESEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Jun 2018 14:04:22 -0400
Subject: Re: [PATCH] cx231xx: Increase USB bridge bandwidth
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@s-opensource.com
References: <1522699141-11464-1-git-send-email-brad@nextdimension.cc>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <72df1973-b58c-3bf2-c010-c7c4ea6130e5@gentoo.org>
Date: Tue, 5 Jun 2018 20:04:17 +0200
MIME-Version: 1.0
In-Reply-To: <1522699141-11464-1-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.04.2018 um 21:59 schrieb Brad Love:
> The cx231xx USB bridge has issue streaming QAM256 DVB-C channels.
> QAM64 channels were fine, but QAM256 channels produced corrupted
> transport streams.
> 
> cx231xx alt mode 4 does not provide enough bandwidth to acommodate
> QAM256 DVB-C channels, most likely DVB-T2 channels would break up
> as well. Alt mode 5 increases bridge bandwidth to 90Mbps, and
> fixes QAM256 DVB-C streaming.
> 
Hi Brad,

I read through the media commits applied in the last weeks.

This patch looks so simple and yet resolves the (for me) unexplainable
behaviour of the Hauppauge WinTV-HVR-930C-HD. DVB-C reception did only
produce garbage, but the the same demod driver (si2165) does work
perfectly in a PCI device.

Thank you for fixing this issue.

Regards
Matthias
