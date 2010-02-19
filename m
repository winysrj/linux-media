Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:32968 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab0BSTu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:50:58 -0500
Received: from kabelnet-199-165.juropnet.hu ([91.147.199.165])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NiYsH-0005Nz-FV
	for linux-media@vger.kernel.org; Fri, 19 Feb 2010 20:50:56 +0100
Message-ID: <4B7EEC92.1090004@mailbox.hu>
Date: Fri, 19 Feb 2010 20:54:58 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>	 <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com> <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com>
In-Reply-To: <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well, it is not really a problem, if it is not merged, so this updated
version is only for those who want to test it:

http://www.sharemation.com/IstvanV/v4l/xc4000-winfast-14021dfc00f3.patch

  - in xc4000.c, power management may default to on or off depending on
    the card type
  - autodetects and (hopefully) supports cards with the following PCI
    IDs, based on Windows INF files:
      107D:6619  WinFast TV2000 XP Global (this is actually the same as
                 6618 and 6F18)
      107D:6F36  WinFast TV2000 XP Global with XC4100 (analog-only
                 XC4000 ?) tuner
      107D:6F38  WinFast DTV1800 H with XC4000 tuner
      107D:6F42  WinFast DTV2000 H Plus
      107D:6F43  WinFast TV2000 XP Global with XC4100 tuner and
                 different GPIOs
    Not all of these card versions may actually exist in practice,
    though, only 6F38 and 6F42 are confirmed so far.
  - added a new "sharpness" control to the CX88 driver

On 02/18/2010 12:59 AM, Devin Heitmueller wrote:

> I would hate to come across as a jerk here, but he cannot provide his
> SOB for this patch, as I wrote about 95% of the code here.  It's
> derived from a tree I have been working on for the PCTV 340e:
