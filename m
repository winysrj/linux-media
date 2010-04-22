Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:36390 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122Ab0DVCPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 22:15:12 -0400
Subject: Re: Issue loading SAA7134 module
From: hermann pitton <hermann-pitton@arcor.de>
To: Donald Bailey <donnie@apple2pl.us>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4BCF2636.4010803@apple2pl.us>
References: <4BCF2636.4010803@apple2pl.us>
Content-Type: text/plain
Date: Thu, 22 Apr 2010 03:57:31 +0200
Message-Id: <1271901451.3198.59.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 21.04.2010, 13:22 -0300 schrieb Donald Bailey:
> I've got a couple of boxes that have two no-name 8-chip SAA713X cards.  
> Both have the same issue: the kernel will only set up the first eight on 
> one board and only two on the second.  It leaves the other six unusable 
> with error -23.  I am unable to figure out what that means.
> 
> Sample dmesg as follows.  More (/proc/ioports, /proc/interrupts, etc) 
> can be posted if requested.  Tried kernels 2.6.18 and 2.6.33.2 on CentOS 
> 5.4 and Fedora 11 fully updated. The module is loaded as card=0. The 
> following is output for chips 11 through 16.
> 
> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[10]: board init: gpio is 10000
> saa7130[10]: Huh, no eeprom present (err=-5)?
> saa7130[10]: can't register video device
> saa7134: probe of 0000:05:0f.0 failed with error -23
> 

Due to some unknown bug we have ;), it likely works only perfectly with
unidentified devices with more than 128 saa713x chips in a single PCI
slot.

Read on the wiki, about how to add a new device, and feel free to
improve it. 

China is going totally mad. (or is it from somewhere else?)

Cheers,
Hermann







