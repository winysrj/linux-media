Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45944 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751420AbZEGG0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2009 02:26:43 -0400
From: Markus Hahn <markus.o.hahn@gmx.de>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] szap2 and Band L???
Date: Thu, 7 May 2009 08:26:18 +0200
References: <8566f5bc0905060103g250086a2v12d038e9163cabb8@mail.gmail.com>
In-Reply-To: <8566f5bc0905060103g250086a2v12d038e9163cabb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905070826.19020.markus.o.hahn@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 
of  course does szap tune on L-Band, nothing else. 
Try to set lnb settings (LOF = 0) 
On Wednesday 06 May 2009 10:03:00 armel frey wrote:
> Hi,
>
> I have a Hauppauge HVR-4000 and i would like to receive DVB-S2 !
> The card works well in DVB-S and seems to work with szap-s2, but my 
problem
> is that i have to receive DVB-S2 in Band L (950...2150MHz) and szap2 don't
> tune this low fréquency.
>
> I would like to know if there is a patch or something else which make it
> possible??
>
> Thanks,

