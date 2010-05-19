Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:48079
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab0ESIhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 04:37:21 -0400
Message-ID: <4BF3A33F.8040707@ii.net>
Date: Wed, 19 May 2010 16:37:19 +0800
From: Cliffe <cliffe@ii.net>
MIME-Version: 1.0
To: CityK <cityk@rogers.com>
CC: linux-media@vger.kernel.org
Subject: Re: No video0, /dev/dvb/adapter0 present
References: <4BEE6B30.30303@ii.net> <4BEEC1C4.5040809@rogers.com>
In-Reply-To: <4BEEC1C4.5040809@rogers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks! That helped get me back on track.

MythTV doesn't scan channels correctly (I thought it was related to
video0) but importing a channels.conf created using the scan program
works. So now I have a working MythTV setup!

Cheers,

Cliffe.

On 15/05/10 23:46, CityK wrote:
> Cliffe,
>
> Your card does not support analogue, hence there will be no /dev/videoN
> node created.  You are most likely attempting to use analogue tv viewing
> applications (i.e. xawtv v3.9x, tvtime, ...). Use applications for
> digital tv instead (i.e. kaffiene....).
>
> If you go back over the "How to Obtain, Build and Install V4L-DVB Device
> Drivers" article, you will find links to two other articles
>
> http://www.linuxtv.org/wiki/index.php/What_is_V4L_or_DVB%3F
> http://www.linuxtv.org/wiki/index.php/Device_nodes_and_character_devices
>
> which should provide you with fuller details.
>
>   

