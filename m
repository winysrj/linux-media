Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.atmel.fr ([81.80.104.162]:40635 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZBSJBE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 04:01:04 -0500
Message-ID: <499D1A93.5090805@atmel.com>
Date: Thu, 19 Feb 2009 09:38:43 +0100
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New v4l2 driver for atmel boards
References: <499BCAF9.2060101@atmel.com> <Pine.LNX.4.64.0902182202090.6371@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0902182202090.6371@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> what hardware is it for? avr32 or at91 (ARM)?
I am working on AT91(ARM).
  And what API are you using
> to communicate with sensors? 
I am using the ISI IP.
Currently there are two APIs in the kernel -
> int-device and soc-camera, and they both should at some point (soon) 
> converge to the new "V4L2 driver framework." They all have (one of) the 
> goal(s) to reuse sensor (or whatever subdevice) drivers with various 
> hosts. Which of them are you using?
> 
> I've recently got test hardware from Atmel for an AP7000 board (NGW100), 
> and was planning to convert the existing external ISI driver from Atmel to 
> the soc-camera API, but I have no idea when I find time for that.
> 

I have a driver which is not using the soc-camera layer...
Which driver is currently using this soc-camera layer so I can have a 
look at it and maybe I could try to convert mine.

Regards,
Sedji


