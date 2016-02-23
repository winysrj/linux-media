Return-path: <linux-media-owner@vger.kernel.org>
Received: from out.selfhost.de ([82.98.82.95]:58038 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752928AbcBWO2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 09:28:04 -0500
Date: Tue, 23 Feb 2016 15:21:22 +0100
From: Hendrik Oenings <debian@oenings.de>
To: Hendrik Grewe <lists@b4ckbone.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Problems with TV card "TeVii S472"
Message-ID: <20160223152122.67e87cd7@spock>
In-Reply-To: <loom.20160206T214500-421@post.gmane.org>
References: <1449844281.21939.5.camel@oenings.de>
	<loom.20160206T214500-421@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sat, 6 Feb 2016 20:50:00 +0000 (UTC)
schrieb Hendrik Grewe <lists@b4ckbone.de>:

> Hendrik Oenings <debian <at> oenings.de> writes:
> 
> > 
> > Hi all,
> > 
> > I've got a DVB-S2 PCI-Express tv card ("Tevii
> > S472", http://tevii.com/P roducts_S472_1.asp) with Debian testing,
> > but I'm not able to get it work.  
> 
> 
> Any news on this? YOu got it to work?
> 
> 
> I have a very similar problem with a Tevii S470 [1](not) running on
> Ubuntu 15.10 with 4.2 or 4.3 kernels.
> 
> The DVB-S card worked without problem with ubuntu 14.04 but now it is
> not even listed by lspci ...
> 
> 
> [1]
> RF Tuner: Montage M88TS2020
> Demodulator: Montage M88DS3000
> PCIe bridge: Conexant cx23885
> 
>  https://www.linuxtv.org/wiki/index.php/TeVii_S470N_____r__y____b_X____v_^_)__{.n_+____{___bj)____w*jg__________j/___z_____2_______&_)___a_____G___h__j:+v___w____

Sorry for answering that late, I hadn't seen your answer.

I've tried several drivers and several distris, but either the
compilation fails because of the kernel version, or the kernel is
crashing when loading the driver, so I'm still not able to use my tv
card :(. Actually I'm using a 4.3er kernel with Debian unstable.

I'll write to TeVii again, maybe they'll offer me a solution.

I think I forgot writing the result of $ lspci, here is it:
$ lspci
...
03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 04)
...

If anyone has an idea how to get it work, I'm still interested in a
solution.

Regards, Hendrik
