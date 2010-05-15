Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp104.rog.mail.re2.yahoo.com ([206.190.36.82]:46664 "HELO
	smtp104.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751103Ab0EOPqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 11:46:23 -0400
Message-ID: <4BEEC1C4.5040809@rogers.com>
Date: Sat, 15 May 2010 11:46:12 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Cliffe <cliffe@ii.net>
CC: linux-media@vger.kernel.org
Subject: Re: No video0, /dev/dvb/adapter0 present
References: <4BEE6B30.30303@ii.net>
In-Reply-To: <4BEE6B30.30303@ii.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cliffe,

Your card does not support analogue, hence there will be no /dev/videoN
node created.  You are most likely attempting to use analogue tv viewing
applications (i.e. xawtv v3.9x, tvtime, ...). Use applications for
digital tv instead (i.e. kaffiene....).

If you go back over the "How to Obtain, Build and Install V4L-DVB Device
Drivers" article, you will find links to two other articles

http://www.linuxtv.org/wiki/index.php/What_is_V4L_or_DVB%3F
http://www.linuxtv.org/wiki/index.php/Device_nodes_and_character_devices

which should provide you with fuller details.
