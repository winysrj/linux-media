Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:59797 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab0F2Xyc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 19:54:32 -0400
Message-ID: <4C2A87A4.1090104@vorgon.com>
Date: Tue, 29 Jun 2010 16:54:12 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: laggy remote on x64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have 2 systems nearly identical except one runs 64bit and the other 
runs 32bit. I'm now trying to use the remote port on the nexus-s card. 
The 32 bit seems to be working ok, but the 64bit acts like it's bussy 
doing somthing else. It randomly won't respond to the remote. It doesn't 
buffer the keys or anything. Wait a moment and maybe it works fine for a 
few presses. When it doesn't respond is highly random. Kernel-2.6.34, 
debian squeeze updated a few days ago, v4l is hg from 06/25/2010
