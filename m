Return-path: <linux-media-owner@vger.kernel.org>
Received: from asmtp.unoeuro.com ([195.41.131.37]:33466 "EHLO
	asmtp.unoeuro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2BIVmX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2012 16:42:23 -0500
Received: from mail-bk0-f46.google.com (mail-bk0-f46.google.com [209.85.214.46])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by asmtp.unoeuro.com (Postfix) with ESMTP id 0EA3636DE6B
	for <linux-media@vger.kernel.org>; Thu,  9 Feb 2012 22:42:22 +0100 (CET)
Received: by bkcjm19 with SMTP id jm19so2218496bkc.19
        for <linux-media@vger.kernel.org>; Thu, 09 Feb 2012 13:42:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAd_vpSGPJiFxGBdj9cy0QTK=aVM=XTO68etWXhRKOefUdWEPQ@mail.gmail.com>
References: <CAAd_vpSGPJiFxGBdj9cy0QTK=aVM=XTO68etWXhRKOefUdWEPQ@mail.gmail.com>
From: Kenni Lund <kenni@kelu.dk>
Date: Thu, 9 Feb 2012 22:42:00 +0100
Message-ID: <CAAd_vpRpCGCi1ktEWcbfPfNFuU-V2i8zeh=bvu0YxKNdRdd4cQ@mail.gmail.com>
Subject: Re: TechnoTrend CT-3650 Viaccess CAM never initializes correctly
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/31 Kenni Lund <kenni@kelu.dk>:
> Hi list
>
> I'm unable to get the CI working on a TT CT-3650 with a Viaccess CAM.
> Every time the CAM is inserted, I get a "dvb_ca adapter 0: Invalid PC
> card inserted :(" error message.
>
> I've tested with both an Arch Linux 3.2.1 kernel (CI-support included)
> and with a Ubuntu 2.6.32 kernel with latest media_build git compiled
> against it - both results in the same error.
>
> To rule out any hardware issues, I've tested the tuner with the
> Viaccess CAM under Windows, and it works without any issues here.
>
> From my very limited understanding of the code, it appears that the
> CAM never returns any initialization string to the driver - or times
> out too early - and therefore never is initialized ("TUPLE type:0x0
> length:0").

For the sake of the archives, I finally got it working. Jose Alberto
Reguero was kind enough to tell me, that the above error message is
simply caused by the CAM being in sleep-mode. When an application
needs it, the CAM *should* wake up and initialize successfully. In my
case it didn't on multiple test setups, but it works now on my test
system with the following software:
- A daily build of Ubuntu 12.04 (~alpha2) which includes a 3.2 kernel.
- A daily build of MythTV pre0.25.
- A quick workaround with hard links added to /etc/rc.local to make up
for the non-existing /dev/dvb/adapter0/*1 devices on the combined
DVB-C/T tuner:
ln -s /dev/dvb/adapter0/ca0 /dev/dvb/adapter0/ca1
ln -s /dev/dvb/adapter0/demux0 /dev/dvb/adapter0/demux1
ln -s /dev/dvb/adapter0/dvr0 /dev/dvb/adapter0/dvr1
ln -s /dev/dvb/adapter0/net0 /dev/dvb/adapter0/net1

With this setup, the CAM initializes correctly once the MythTV backend
is started on bootup.

Best regards
Kenni
