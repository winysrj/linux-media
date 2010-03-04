Return-path: <linux-media-owner@vger.kernel.org>
Received: from denebola.andago.com ([213.171.250.124]:34109 "EHLO
	denebola.andago.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0CDSMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 13:12:13 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by denebola.andago.com (Postfix) with ESMTP id 732B111B914
	for <linux-media@vger.kernel.org>; Thu,  4 Mar 2010 19:12:08 +0100 (CET)
Received: from denebola.andago.com ([127.0.0.1])
	by localhost (denebola.andago.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aHFYTPxVArYf for <linux-media@vger.kernel.org>;
	Thu,  4 Mar 2010 19:12:07 +0100 (CET)
Received: from [192.168.16.16] (madrid.andago.com [213.171.250.126])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by denebola.andago.com (Postfix) with ESMTPS id 7DF9211B8AF
	for <linux-media@vger.kernel.org>; Thu,  4 Mar 2010 19:12:07 +0100 (CET)
Message-ID: <4B8FF80C.7050009@andago.com>
Date: Thu, 04 Mar 2010 19:12:28 +0100
From: Jorge Cabrera <jorge.cabrera@andago.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Ubuntu and AverMedia DVD EZMaker USB Gold
References: <4B8E3C69.2090800@andago.com>
In-Reply-To: <4B8E3C69.2090800@andago.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,

I was wrong here, the driver works, the device works great but what's 
going on is that it uses the tuner as the default input, when I run 
mplayer with input=1 (composite video) or input=2 (s-video) it works good:

mplayer tv:// -tv input=1:device=/dev/video0

But this isn't good enough because cheese and camorama and flash use the 
default input. How can I set up default input to composite video or 
s-video? Should I add something to the options that the Avermedia kernel 
module uses?

I would appreciate any help,

Cheers

Jorge Cabrera wrote:
> Hi everyone,
>
> I'm trying to make an "AverMedia DVD EZMaker USB Gold" work with 
> Ubuntu (tried in a computer with 9.04 and other two with 9.10) with a 
> Sony EVI D70P Camera. I installed the linux drivers from AverMedia and 
> when I connect the device the system shows the following message when 
> i run dmesg:
>
> [69302.964025] usb 2-1: new high speed USB device using ehci_hcd and 
> address 6
> [69303.637332] usb 2-1: configuration #1 chosen from 1 choice
> [69303.860132] C038 registered V4L2 device video0[video]
> [69303.860160] C038 registered V4L2 device vbi0[vbi]
> [69303.860440] C038 registered ALSA sound card 2
>
> Problem is that when I connect the camera it doesn' work, tried with 
> cheese, gstreamer-properties, camorama and always get the same error:
>
> libv4l2: error getting pixformat: Invalid argument
>
> I tried connecting the camera with s-video and composite video with 
> the same result. Funny thing is that I get the same error without 
> connecting the camera so I guess it's just a problem with the 
> AverMedia device. Works well on Windows.
>
> I've been reading a lot on this but still have no clues. I'm going to 
> try with the drivers at linuxtv.org but I wanted to ask has anyone got 
> this type of device working under linux?
>
> I would really appreciate any help.
>
> Cheers,
>


-- 
Jorge Cabrera
Ándago Ingeniería - www.andago.com

Teléfono: +34 916 011 373
Móvil: +34 637 741 034
e-mail: jorge.cabrera@andago.com

C/Alcalde Ángel Arroyo n.º10 1.ªPl. (28904) Getafe, Madrid

