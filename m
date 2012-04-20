Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53491 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2DTIIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 04:08:54 -0400
Received: from host86-183-226-21.range86-183.btcentralplus.com ([86.183.226.21] helo=molly.ianliverton.co.uk)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <linux-media@ianliverton.co.uk>)
	id 1SL8th-000Cf2-7k
	for linux-media@vger.kernel.org; Fri, 20 Apr 2012 08:08:53 +0000
Received: from [192.168.1.88] (helo=laptop)
	by molly.ianliverton.co.uk with esmtp (Exim 4.72)
	(envelope-from <linux-media@ianliverton.co.uk>)
	id 1SL8uY-000172-70
	for linux-media@vger.kernel.org; Fri, 20 Apr 2012 09:09:46 +0100
From: "Ian Liverton" <linux-media@ianliverton.co.uk>
To: <linux-media@vger.kernel.org>
References: <4F8EB71A.1010104@googlemail.com>
In-Reply-To: <4F8EB71A.1010104@googlemail.com>
Date: Fri, 20 Apr 2012 09:08:53 +0100
Message-ID: <079b01cd1ecc$d3697d40$7a3c77c0$@co.uk>
MIME-Version: 1.0
Content-Language: en-gb
Subject: RE: Tuning file for Crystal Palace, UK (post digital switch-over)
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

Thanks for this - I was in the middle of trying to sort this out when it
arrived!  When I use it with dvbscan, however, it seems to mis-detect the
modulation on the SDN multiplex.  It's telling me it's QPSK rather than
QAM_64.  Did you have any trouble with re-tuning?

>>> tune to:
506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QPSK:TRANSMISSION_M
ODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010

Many thanks

Ian

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Chris Rankin
Sent: 18 April 2012 13:44
To: linux-media@vger.kernel.org
Subject: Tuning file for Crystal Palace, UK (post digital switch-over)

Hi,

The Crystal Palace transmitter has now completed its digital switch-over, so
here's the updated tuning file.

Cheers,
Chris

-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 2012.0.1913 / Virus Database: 2411/4943 - Release Date: 04/17/12

