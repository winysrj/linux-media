Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38535 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2GPUYk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 16:24:40 -0400
Message-ID: <5004787E.4020706@iki.fi>
Date: Mon, 16 Jul 2012 23:24:30 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Meftah Tayeb <tayeb.dotnet@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Device supported ?
References: <006E41BB892E488D96CC35D62816B7CC@work>
In-Reply-To: <006E41BB892E488D96CC35D62816B7CC@work>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/14/2012 07:50 PM, Meftah Tayeb wrote:
> Hello
> i installed the latest Linux V4L-DVB (mediabuild) in my debian X64
> having those DVBS2 cards:
> http://paste.debian.net/179068/
> dmesg output:
> http://paste.debian.net/179072/
> Uname -a: Linux debian 3.2.0-3-amd64 #1 SMP Thu Jun 28 09:07:26 UTC 2012
> x86_64 GNU/Linux
> Debian release: wheezy/sid
> anyone ?

 From those pastes:
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI 
Video and Audio Decoder (rev 04)
CORE cx23885[0]: subsystem: 6981:8888, board: UNKNOWN/GENERIC 
[card=0,autodetected]

ID 6981:8888 seems to belong for TurboSight TBS 6981. Unfortunately they 
use their own binary drivers. This mailing list is for drivers that are 
included to the Kernel. You have to look help from the device vendor 
support page.

regards
Antti

-- 
http://palosaari.fi/


