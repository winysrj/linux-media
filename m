Return-path: <linux-media-owner@vger.kernel.org>
Received: from server50105.uk2net.com ([83.170.97.106]:33750 "EHLO
	mail.autotrain.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZF3Kzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 06:55:32 -0400
Date: Tue, 30 Jun 2009 11:55:37 +0100 (BST)
From: Tim Williams <tmw@autotrain.org>
To: linux-media@vger.kernel.org
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USBVision device defaults
In-Reply-To: <20090629214747.2fba7b4a@lugdush.houroukhai.org>
Message-ID: <alpine.LRH.2.00.0906301110090.28946@server50105.uk2net.com>
References: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com> <20090629214747.2fba7b4a@lugdush.houroukhai.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Jun 2009, Thierry MERLE wrote:

> I remember a guy that did the trick with the vloopback device.
> Searching a bit on the Internet, it seems that flashcam
> http://www.swift-tools.net/Flashcam/ can be convenient for your needs.

Looks like a useful tool, it certainly keeps the video device active.

Unfortunatly it doesn't really solve my problem, since it still starts the 
usbvision device up with default settings and the vloopback device dosn't 
seem to support pushing through config parameters set using v4ctl to the 
original underlying video device.

It does however fix another problem I had which was that flash caused 
firefox to freeze when you exit the page containing the flash webcam 
applet.

Tim W

-- 
Tim Williams BSc MSc MBCS
Euromotor Autotrain LLP
58 Jacoby Place
Priory Road
Edgbaston
Birmingham
B5 7UW
United Kingdom

Web : http://www.autotrain.org
Tel : +44 (0)121 414 2214

EuroMotor-AutoTrain is a company registered in the UK, Registration
number: OC317070.
