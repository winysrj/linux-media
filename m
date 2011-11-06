Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42827 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1KFSNP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 13:13:15 -0500
Received: by wyh15 with SMTP id 15so3789436wyh.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 10:13:14 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: FX2 FW: conversion from Intel HEX to DVB USB "hexline"
Date: Sun, 6 Nov 2011 19:13:11 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <4EB6990C.8000904@iki.fi> <201111061858.00709.pboettcher@kernellabs.com> <4EB6CCE3.4020809@iki.fi>
In-Reply-To: <4EB6CCE3.4020809@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111061913.11505.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday, November 06, 2011 07:07:31 PM Antti Palosaari wrote:
> Many thanks!
> 
> Actually, I was just started to write similar Python script! You got
> maybe 15min late but still 15min before mine was ready :)
> 
> Format was nothing more than convert ASCII hex values to binary bytes
> and stripping out all white spaces and Intel HEX start code ":".
> 
> Why it was initially converted to binary and not used Intel HEX as it
> is? I think you know, as a original author, history about that decision?

Because doing string-parsing and evaluation in the kernel is something I 
usually  avoid. And it can't sure be done within 300 bytes (the size of the 
perl script). Also the .bin is smaller in term of size compared to the .hex.


--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
