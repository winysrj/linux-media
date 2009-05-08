Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.ddnet.es ([88.87.135.16]:60613 "EHLO smtp.ddnet.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZEHLYX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2009 07:24:23 -0400
Subject: DVB-T USB stick  azurewave AD-TU200
From: Miguel <mcm@moviquity.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 08 May 2009 13:22:50 +0200
Message-Id: <1241781770.7996.12.camel@McM>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I am searching information about how to get my dvb-t usb stick works
with my machine.

I currently using a ubuntu intrepid os. I have installed the rtl2831u
drivers as it is recommended.

TwinHan/AzureWave AD-TU200 (7047) DVB-T 
Uses a Realtek RTL2831U decoder chip and MaxLinear MXL5003S tuner. USB
ID is 13d3:3216. It seems to work with the realtek experimental driver
(see freecom v4 above)

The problems I have found:

The found device  has not frontend:

mcm@McM:/usr/share/doc/dvb-utils$ tree /dev/dvb/adapter0/
/dev/dvb/adapter0/
|-- demux0
|-- dvr0
`-- net0

So when scanning it fails
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
main:2247: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No
such file or directory


Other problem I found, which GUI is recommended to be used?

thank you in advance,

Miguel




