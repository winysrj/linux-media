Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d08.mx.aol.com ([205.188.109.207]:35212 "EHLO
	omr-d08.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaG0XwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 19:52:12 -0400
Received: from mtaout-mcb02.mx.aol.com (mtaout-mcb02.mx.aol.com [172.26.50.174])
	by omr-d08.mx.aol.com (Outbound Mail Relay) with ESMTP id E0048700000B5
	for <linux-media@vger.kernel.org>; Sun, 27 Jul 2014 19:44:38 -0400 (EDT)
Received: from x220.optiplex-networks.com (81-178-2-118.dsl.pipex.com [81.178.2.118])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-mcb02.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 6C3EE38000095
	for <linux-media@vger.kernel.org>; Sun, 27 Jul 2014 19:44:38 -0400 (EDT)
Message-ID: <53D58EDF.1090102@netscape.net>
Date: Mon, 28 Jul 2014 00:44:31 +0100
From: Kaya Saman <SamanKaya@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Advice on DVB-S/S2 card and CAM support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm wondering what the best solution for getting satellite working on 
Linux is?


Currently I have a satellite box with CAM module branded by the 
Satellite TV provider we are with.


As I am now migrating everything including TV through my HTPC 
environment I would also like to link the satellite box up to the HTPC 
too to take advantage of the PVR and streaming capabilities.


I run XBMC as my frontend so I was looking into TV Headend to take care 
of PVR side of things.


My greatest issue though is what is the best solution for getting the 
satellite system into the HTPC?


After some research my first idea was to use a satellite tuner card; 
models are available for Hauppauge and other vendors so really it was 
about which was going to offer best compatibility with Linux? (distro is 
Arch Linux with 3.15 kernel)

The model of card I was looking was from DVB-Sky:

http://www.dvbsky.net/Products_S950C.html

something like that, which has CAM module slot and is DVB-S/S2 
compatible and claims to have drivers supported by the Linuxtv project.


Or alternately going for something like this:

http://www.dvbsky.net/Products_T9580.html

as it has a combined DVB-T tuner, then using a USB card reader for the 
CAM "smart card".


Has anyone used the cards above, what are the opinions relating to them? 
Also would they work with motorized dishes?


Since I'm not sure if "all" CAM's are supported as apparently our 
satellite tv provider wanted to lock out other receivers so they force 
people to use their own product;

my second idea was to perhaps use a capture card with RCA inputs.

Something like this:

http://www.c21video.com/viewcast/osprey-210.html

perhaps or a Hauppauge HD-PVR mk I edition:

which according to the wiki is supported.


Looking forward to hearing advice.


Thanks.


Kaya
