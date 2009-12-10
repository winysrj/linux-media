Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52747 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760986AbZLJSf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 13:35:59 -0500
Received: by bwz27 with SMTP id 27so69581bwz.21
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 10:36:04 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Guillem =?utf-8?q?Sol=C3=A0?= <garanda@flumotion.com>
Subject: Re: TveiiS470 and DVBWorld2005 not working
Date: Thu, 10 Dec 2009 20:35:59 +0200
Cc: linux-media@vger.kernel.org
References: <4B21260D.9080408@flumotion.com>
In-Reply-To: <4B21260D.9080408@flumotion.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912102035.59356.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 декабря 2009 18:47:09 Guillem Solà wrote:
> Hi,
>
> I come to this list as my last resort. I have two DVB-S PCIE cards and
> no one can get channels, but I have another computer with a PCI SAA7146
> that can get 1400 services from same dish.
>
> * Tveii S470 *
>
> One is the Tveii S470. I guess that the S470 should work because you are
> working in IR support.
>
> I have tried V4L tip, drivers from website, from website and patched
> like in wiki says... but all I get is:
>
> scandvb -a 0 /usr/share/dvb-apps/dvb-s/Astra-19.2E
>
> scanning /usr/share/dvb-apps/dvb-s/Astra-19.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12551500 V 22000000 5
>
>  >>> tune to: 12551:v:0:22000
>
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
> As I said I have another computer with a PCI dvb-s card that can get lot
> of channels so I thing that the disk is working well.
>
>
> Any idea about what's going on?
Hi Guillem,
I think you are missing firmwares, though you give too little information.

>
> Thanks in advance,
>
> Guillem Solà
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
