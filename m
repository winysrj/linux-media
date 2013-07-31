Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:7234 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3GaF5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 01:57:09 -0400
From: =?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 FINAL 0/6] qv4l2: add OpenGL rendering and window fixes
Date: Wed, 31 Jul 2013 07:57:05 +0200
Message-ID: <20227492.r4Kl03Wv4H@bwinther>
In-Reply-To: <20130730101233.2c78cbae@samsung.com>
References: <1375172124-14439-1-git-send-email-bwinther@cisco.com> <20130730101233.2c78cbae@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, July 30, 2013 10:12:33 AM you wrote:
> Em Tue, 30 Jul 2013 10:15:18 +0200
> Bård Eirik Winther <bwinther@cisco.com> escreveu:
> 
> ...
> 
> > Performance:
> > All tests are done on an Intel i7-2600S (with Turbo Boost disabled) using the
> > integrated Intel HD 2000 graphics processor. The mothreboard is an ASUS P8H77-I
> > with 2x2GB CL 9-9-9-24 DDR3 RAM. The capture card is a Cisco test card with 4 HDMI
> > inputs connected using PCIe2.0x8. All video input streams used for testing are
> > progressive HD (1920x1080) with 60fps.
> 
> I did a quick test here with a radeon HD 7750 GPU on a i7-3770 CPU, using an UVC
> camera at VGA resolution and nouveau driver (Kernel 3.10.3).
> 
> qv4l2 CPU usage dropped from 13% to 3,75%.
> 
> It sounds a nice improvement!
> 
> 
That is good to hear. My results where achived using the 3.9 and 3.10 kernels
although I belive that the hardware and opengl driver affects performance the most.

With such a good hardware and relatively low resolution, you wont see that much of a differance :-),
but it is a nice improvement indeed. Anyway, nice to get additional tests!
