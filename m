Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:35636 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbZKKPys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 10:54:48 -0500
Received: from IO.local (61-140.4-85.fix.bluewin.ch [85.4.140.61])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id nABFsmL6017131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 11 Nov 2009 16:54:53 +0100
Message-ID: <4AFADE49.9070600@deckpoint.ch>
Date: Wed, 11 Nov 2009 16:54:49 +0100
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: v4l-dvb compile broken with stock Ubuntu Karmic build (firedtv-ieee1394.c
 errors)
References: <4AF9150D.2070601@deckpoint.ch>
In-Reply-To: <4AF9150D.2070601@deckpoint.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas Kernen wrote:
> Hello,
> 
> I came across this thread from June 2009 in the news archives about 
> Ubuntu Karmic and v4l-dvb compile broken with stock Ubuntu Karmic build:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/7161 
> 
> 
> I've just come across this issue myself after an upgrade of a server to 
> the Ubuntu Karmic release.
> 
> Is there any plans to attempt to mitigate this so that other users would 
> not be impacted?
> 
> Regards,
> Thomas

I don't like answering my own messages but hopefully this will be useful 
to other users too who may come across the same issue as I and didn't do 
enough research before asking the question.

Ubuntu Karmic is missing some Firewire/IEEE1394 files in the 
kernel-headers package.

Workaround:
in the v4l folder, open the .config file, find the line with 
"CONFIG_DVB_FIREDTV=m" and change to "CONFIG_DVB_FIREDTV=n".

Thomas
