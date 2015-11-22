Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:33052 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbKVRrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2015 12:47:24 -0500
Subject: Re: [PATCH 4/4] si2165: Add DVB-C support for HVR-4400/HVR-5500
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1447455298-5562-1-git-send-email-zzam@gentoo.org>
 <1447455298-5562-4-git-send-email-zzam@gentoo.org>
 <20151119112826.7ad9b688@recife.lan>
Cc: linux-media@vger.kernel.org, crope@iki.fi, xpert-reactos@gmx.de
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <5651FF8F.8040003@gentoo.org>
Date: Sun, 22 Nov 2015 18:46:55 +0100
MIME-Version: 1.0
In-Reply-To: <20151119112826.7ad9b688@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.11.2015 um 14:28 schrieb Mauro Carvalho Chehab:
> Em Fri, 13 Nov 2015 23:54:58 +0100
> Matthias Schwarzott <zzam@gentoo.org> escreveu:
> 
>> It works only for HVR-4400/HVR-5500.
>> For WinTV-HVR-930C-HD it fails with bad/no reception
>> for unknown reasons.
> 
> Patch 3/4 of this series is broken. As this one depends on it, please
> resend both patches 3 and 4 on your next patch series.
> 
> Regards,
> Mauro
> 
> PS.: patches 1 and 2 are ok and got applied upstream already.
> 
> 
Hi Mauro,

if you did not notice, I split the patches down into more parts,
improved them a bit and sent them with subject "si2165: Add simple DVB-C
support".

Regards
Matthias

