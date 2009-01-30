Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp107.webpack.hosteurope.de ([80.237.132.114]:58169 "EHLO
	wp107.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbZA3OPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 09:15:04 -0500
Cc: linux-media@vger.kernel.org
Message-Id: <DFCABB73-4712-441C-A63E-66A7618399BF@darav.de>
From: Rietzschel Carsten <cr7@darav.de>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <7E87D995-F966-46C9-8023-1743B18BD4C1@gmx.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [linux-dvb] S2API (pctv452e) artefacts in video stream
Date: Fri, 30 Jan 2009 14:51:23 +0100
References: <496204D8.6090602@okg-computer.de><20090105130757.GW12059@titan.makhutov-it.de>	<49620916.7060704@dark-green.com> <8CB3D7E10E304E0-1674-1438@WEBMAIL-MY25.sysops.aol.com> <496B3494.4030500@okg-computer.de> <6940F926-0668-4B88-BF78-32C69EE51919@gmx.de> <158C8110-E256-44A4-9418-E45A94855F62@gmx.de> <49807720.2020808@gmail.com> <A2511C63-B74D-4E71-807C-BD8FCACCAFFF@gmx.de> <498226ED.6000409@gmail.com> <7E87D995-F966-46C9-8023-1743B18BD4C1@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,
Hello together,

in the meantime I was able to test the device on windows. It works  
without any problems for over an hour.

Also I tried again different SAT- und USB-cables.
Also with all other USB-devices dettached - the error still comes.

First I'm getting "TS continuity errors"
and after a while (let's say 15 minutest) ...

Jan 30 14:42:20 vdr dvb-usb: bulk message failed: -110 (8/0)
Jan 30 14:42:20 vdr ttusb2: there might have been an error during  
control message transfer. (rlen = 4, was 0)
Jan 30 14:42:20 vdr ttusb2: i2c transfer failed.
Jan 30 14:42:22 vdr dvb-usb: bulk message failed: -110 (9/0)
Jan 30 14:42:22 vdr ttusb2: there might have been an error during  
control message transfer. (rlen = 3, was 0)
Jan 30 14:42:22 vdr ttusb2: i2c transfer failed.
Jan 30 14:42:24 vdr dvb-usb: bulk message failed: -110 (8/0)
Jan 30 14:42:24 vdr ttusb2: there might have been an error during  
control message transfer. (rlen = 4, was 0)


Thanks for your help!
darav
