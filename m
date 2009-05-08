Return-path: <linux-media-owner@vger.kernel.org>
Received: from hamlet.nurpoint.com ([212.239.26.6]:47167 "EHLO
	hamlet.nurpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZEHImr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2009 04:42:47 -0400
Received: from dab.z1.infracom.it ([82.193.15.171] helo=[192.168.1.140])
	by hamlet.nurpoint.com with esmtpa (Exim 4.69)
	(envelope-from <s.danzi@hawai.it>)
	id 1M2Ks1-0006EY-Au
	for linux-media@vger.kernel.org; Fri, 08 May 2009 09:51:49 +0200
Message-ID: <4A03E492.1090504@hawai.it>
Date: Fri, 08 May 2009 09:51:46 +0200
From: Stefano Danzi <s.danzi@hawai.it>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Making a DVB-S Transmitter
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!!

I and some others Ham radio operators are working on a pc-based
dvb-s transmitter.

Reference website are: http://www.m0dts.co.uk/datv.htm

Interfare between pc and transmitter is based on FTDI FT245 (usb fifo).

Goal will be create a device like /dev/dvbs-tx, write into a mpeg-ts 
stream so
kernel module convert it to a dvb-s signal and send it to the usb fifo.

Now could be a good thing to have a kernel module for get raw data from 
/dev/dvbs-tx
and put it on the ftdi chip (we have an external encoder called dvbsenco 
but target project
is rewrite a clone as kernel module to improve performances)

I know basic C but not enought to write a kernel module.
Someone can help us?

PS Sorry for my horrible english



