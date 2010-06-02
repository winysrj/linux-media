Return-path: <linux-media-owner@vger.kernel.org>
Received: from [93.89.92.10] ([93.89.92.10]:41038 "EHLO xen2.csldevices.co.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756414Ab0FBRj4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jun 2010 13:39:56 -0400
Received: from [212.49.228.51] (helo=[192.168.17.1])
	by xen2.csldevices.co.uk with esmtp (Exim 4.69)
	(envelope-from <phil@csldevices.co.uk>)
	id 1OJrJi-0006we-VW
	for linux-media@vger.kernel.org; Wed, 02 Jun 2010 18:01:23 +0100
Message-ID: <4C068E48.6070301@csldevices.co.uk>
Date: Wed, 02 Jun 2010 18:00:56 +0100
From: Philip Downer <phil@csldevices.co.uk>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Implementing a hardware dvb pid filter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm looking to implement a hardware pid filter for a card I'm working 
on. I've been looking at how other drivers do this however all the 
drivers I've looked at still seem to call the software filter routines 
to pass data to user space. For example I've been looking at the flexcop 
(ie b2c2) driver and whilst that has a hardware filter, the interrupt 
service routine seems to always call flexcop_pass_dmx_data or 
flexcop_pass_dmx_packets from dvb/b2c2/flexcop.c which both call 
dvb_dmx_swfilter_packets or dvb_dmx_swfilter respectively.

I had assumed that I would be able to make a ts stream coming from a 
hardware demux directly available to demux clients and dvr0, but no 
other budget driver (ie without mpeg/video out) seems to do this without 
using the swfilter. Can anyone point me at a driver which does similar 
to what I'm trying to implement or am I just missing something.

Thanks in advance,

Phil
