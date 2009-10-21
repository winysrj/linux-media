Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32702.mail.mud.yahoo.com ([68.142.207.246]:32190 "HELO
	web32702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751622AbZJUFfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 01:35:50 -0400
Message-ID: <546639.71742.qm@web32702.mail.mud.yahoo.com>
Date: Tue, 20 Oct 2009 22:35:55 -0700 (PDT)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Kworld 315U help?
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was wondering if someone would be able to help me with getting the analog and inputs for the Kworld 315U working.  I was able to get the digital part working with help from Douglas Schilling and wanted to get the remaining portions of the device working. 

I have traces but have not made much progress.  In addition I also have some questions about the information that the parse_em28xx.pl skips and does not decode.  

For example here is some of the data that doesn't seem to be decoded.. 
unknown: 40 03 00 00 a0 00 01 00 >>> 08                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< d0                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 08                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< d0                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 22                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< 01                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 04                                                 
unknown: c0 02 00 00 a0 00 02 00 <<< 1a eb                                              
unknown: 40 03 00 00 a0 00 01 00 >>> 20                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< 46                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 14                                                 
unknown: c0 02 00 00 a0 00 04 00 <<< 4e 07 01 00                                        

Anyways, any help that can be provided is appreciated.  

Thanks,
Franklin Meng


      
