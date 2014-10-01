Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35995 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaJAGBf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 02:01:35 -0400
Message-ID: <542B98BB.6070405@gentoo.org>
Date: Wed, 01 Oct 2014 08:01:31 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Subject: Re: [PATCH V2 2/2] si2165: do load firmware without extra header
References: <1412143098-18293-1-git-send-email-zzam@gentoo.org> <1412143098-18293-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412143098-18293-2-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.10.2014 07:58, Matthias Schwarzott wrote:
> The new file has a different name: dvb-demod-si2165-d.fw
> 
> Count blocks instead of reading count from extra header.
> Calculate CRC during upload and compare result to what chip calcuated.
> Use 0x01 instead of real patch version, because this is only used to
> check if something was uploaded but not to check the version of it.
> 
> V2: change firmware filename to lower case.
> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>


Hi Mauro,

if you think it is necessary for not breaking userspace, I can change
the patch to fall back to the old firmware file if the new one does not
exists.
Ignoring the additional header is simple.

Regards
Matthias

