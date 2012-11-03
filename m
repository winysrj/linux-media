Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52765 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab2KCUlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Nov 2012 16:41:13 -0400
References: <2489713.pAFgSjBqdl@comp>
In-Reply-To: <2489713.pAFgSjBqdl@comp>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cx23885: Added support for AVerTV Hybrid Express Slim HC81R (only analog)
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 03 Nov 2012 16:41:10 -0400
To: Oleg Kravchenko <oleg@kaa.org.ua>, linux-media@vger.kernel.org
Message-ID: <21a4038a-2fef-4947-ab2a-06873e80b185@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oleg Kravchenko <oleg@kaa.org.ua> wrote:

>Hello! Please review my patch.
>
>Supported inputs:
>Television, S-Video, Component.
>
>Modules options:
>options cx25840 firmware=v4l-cx23418-dig.fw   

Hi,

Please do not use the CX23418 digitizer firmware with the CX2388[578] chips.  Use the proper cx23885 digitizer firmware.  You need the proper firmware to get the best results in detecting the audio standard in broadcast analog video.

Regards,
Andy
