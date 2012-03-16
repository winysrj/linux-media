Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34017 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2CPVYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 17:24:32 -0400
Received: by wejx9 with SMTP id x9so4322064wej.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 14:24:31 -0700 (PDT)
Message-ID: <4F63AF8D.3060005@unixindia.com>
Date: Fri, 16 Mar 2012 21:24:29 +0000
From: Bhasker C V <bhasker@unixindia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Bit rate of a transport stream
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

 In finding the bit rate of a transport stream as a whole, I had a doubt
if someone can help  me please
 I did try to google but could not get any definite information on this
topic

 Say I have 2 programs in a transport stream each with 1 audio and 1 video
 Can I safely assume the total bitrate of the stream is the combined
bitrate of program 1 ES rate and progam 2 ES rate ?
 If this is the case will the audio PIDs should also be taken into
account for caculating the total bitrate of the stream ?


 Program 1  -> PIDA(audio), PIDB(video)
 Program 2  -> PIDC(audio), PIDD(video)

bitrate = ES rate of PIDA + PIDB + PIDC + PIDD ?

or is there any other easier way to find the bitrate of a MPEG transport
stream ?

thanks


-- 
Bhasker C V

