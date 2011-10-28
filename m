Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:53747 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722Ab1J1XBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 19:01:10 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9SN14Gr027394
	for <linux-media@vger.kernel.org>; Fri, 28 Oct 2011 19:01:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id AE3CE1E015A
	for <linux-media@vger.kernel.org>; Fri, 28 Oct 2011 19:01:03 -0400 (EDT)
Message-ID: <4EAB342F.2020008@lockie.ca>
Date: Fri, 28 Oct 2011 19:01:03 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: femon patch for dB
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I added a switch to femon so it displays signal and snr in dB.

The cx23885 driver for my Hauppauge WinTV-HVR1250 reports signal and snr 
in dB.

http://lockie.ca/test/femon.patch.bz2
