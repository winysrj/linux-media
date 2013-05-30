Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta.bitpro.no ([92.42.64.202]:59713 "EHLO mta.bitpro.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966916Ab3E3IOY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 04:14:24 -0400
Message-ID: <51A70713.6030802@bitfrost.no>
Date: Thu, 30 May 2013 10:00:19 +0200
From: Hans Petter Selasky <hps@bitfrost.no>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Juergen Lock <nox@jelal.kn-bremen.de>
Subject: TT-USB2.0 and high bitrate packet loss (DVB-C/T)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I need to get in concat with someone that can handle, test and review a 
patch for TT-USB2.0. I've found that for certain high-bitrate streams, 
the TT-USB2.0 sends more ISOCHRONOUS MPEG data than is specified in the 
wMaxPacketSize fields. I have a USB analyzer capture which shows this 
clearly. This of course won't be received at the USB host and packet 
drops appear inside the stream. The solution is to use another alternate 
setting. The technotrend chip has many of these. I've now tested using 
alternate setting 7 instead of 3.

Alternate setting 7 allows transferring a maximum of 3 * 1024 bytes.
Alternate setting 3 allows transferring a maximum of 1 * 940 bytes.

--HPS
