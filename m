Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:48399 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZLKORr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 09:17:47 -0500
Received: by ewy1 with SMTP id 1so1077772ewy.28
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 06:17:53 -0800 (PST)
Message-ID: <4B2254A4.3080105@flumotion.com>
Date: Fri, 11 Dec 2009 15:18:12 +0100
From: =?ISO-8859-1?Q?Guillem_Sol=E0?= <garanda@flumotion.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: TveiiS470 and DVBWorld2005 not working
References: <4B21260D.9080408@flumotion.com>
In-Reply-To: <4B21260D.9080408@flumotion.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guillem Solà wrote:
> Hi,
>
> I come to this list as my last resort. I have two DVB-S PCIE cards and 
> no one can get channels, but I have another computer with a PCI 
> SAA7146 that can get 1400 services from same dish.
>
> * Tveii S470 *
>
> One is the Tveii S470. I guess that the S470 should work because you 
> are working in IR support.
>
> I have tried V4L tip, drivers from website, from website and patched 
> like in wiki says... but all I get is:
>
> scandvb -a 0 /usr/share/dvb-apps/dvb-s/Astra-19.2E
>
> scanning /usr/share/dvb-apps/dvb-s/Astra-19.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12551500 V 22000000 5
> >>> tune to: 12551:v:0:22000
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010it's going on
>
> dumping lists (0 services)
>
> Done.
>
>
> * DVBWorld 2005 *
>
> The other is the DVBWorld DVB-S2 2005. I have tried also latest V4l, 
> liplianin branch... and I get the same: 0 services.
>
>
> The hardware were I'm trying to run this is a Dell 1 unit Rack Server 
> with RHEL with kernels 2.6.30, 2.6.31 and 2.6.32 patched by myself.
>
> As I said I have another computer with a PCI dvb-s card that can get 
> lot of channels so I thing that the disk is working well.
>
>
> Any idea about what's going on?
>
> Thanks in advance,
>
> Guillem Solà
Sorry for the noise,

The sooner I wrote the email, the sooner my TeviiS470 started to work!

I did it work with the latest s2-liplianin tip, of course firmwares were 
in /lib/firmware dir.

Now I'm doing some compatibility tests. As I said I can get a few less 
channels than with the saa7164 that I'm using in old computers.

My aim is to certify it for the company I work for, so if there is 
something I could do testing it to help the community, I could do it 
during my work journey.

regards,

Guillem
