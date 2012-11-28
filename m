Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:40641 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab2K1W3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 17:29:12 -0500
Message-ID: <50B69037.3080205@pyther.net>
Date: Wed, 28 Nov 2012 17:29:11 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com>
In-Reply-To: <50B67851.2010808@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2012 03:47 PM, Frank Schäfer wrote:
> Your device seems to use a EM2874 bridge.
That is what appears on the chip.
> Any chance to open the device and find out which demodulator it uses ?
To my surprise it was easier to open than expected.

I think this is the demodulator:

7th Generation
VS8/QAM Receiver
LG
LGDT3305
1211
PGU419.00A

I took some pictures (of the entire card): 
http://pyther.net/a/digivox_atsc/ (SideA_1.jpg, SideA_2.jpg, 
SideB_1.jpg, SideB_2.jpg)
> Are you able to compile a kernel on your own to test patches ? It's not
> that hard... ;)
I sure can! I've done some kernel bisects in the past.

Thanks
