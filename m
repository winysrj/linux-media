Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44508 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760968AbZLJQqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 11:46:53 -0500
Received: by ewy19 with SMTP id 19so40135ewy.21
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 08:46:58 -0800 (PST)
Message-ID: <4B21260D.9080408@flumotion.com>
Date: Thu, 10 Dec 2009 17:47:09 +0100
From: =?ISO-8859-1?Q?Guillem_Sol=E0?= <garanda@flumotion.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TveiiS470 and DVBWorld2005 not working
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I come to this list as my last resort. I have two DVB-S PCIE cards and 
no one can get channels, but I have another computer with a PCI SAA7146 
that can get 1400 services from same dish.

* Tveii S470 *

One is the Tveii S470. I guess that the S470 should work because you are 
working in IR support.

I have tried V4L tip, drivers from website, from website and patched 
like in wiki says... but all I get is:

scandvb -a 0 /usr/share/dvb-apps/dvb-s/Astra-19.2E

scanning /usr/share/dvb-apps/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
 >>> tune to: 12551:v:0:22000
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010it's going on

dumping lists (0 services)

Done.


* DVBWorld 2005 *

The other is the DVBWorld DVB-S2 2005. I have tried also latest V4l, 
liplianin branch... and I get the same: 0 services.


The hardware were I'm trying to run this is a Dell 1 unit Rack Server 
with RHEL with kernels 2.6.30, 2.6.31 and 2.6.32 patched by myself.

As I said I have another computer with a PCI dvb-s card that can get lot 
of channels so I thing that the disk is working well.


Any idea about what's going on?

Thanks in advance,

Guillem Solà
