Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:57443 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458Ab0DNR3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 13:29:45 -0400
Message-ID: <4BC5FB77.2020303@vorgon.com>
Date: Wed, 14 Apr 2010 10:29:27 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx5000 default auto sleep mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Andy Walls, found out why I kept loosing 1 tuner on a 
FusionHD7 Dual express. Didn't know linux supported an auto sleep mode 
on the tuner chips and that it defaulted to on. Seems like it would be 
better to default to off. If someone wants an auto power down/sleep mode 
and their software supports it, then let the program activate it. Seems 
people are more likely to want the tuners to stay on then keep shutting 
down.

Spent over a year trying to figure out why vdr would loose control of 1 
of the dual tuners when the atscepg pluging was used thinking it was a 
problem with the plugin.
