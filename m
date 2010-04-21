Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta02.eastlink.ca ([24.224.136.13]:50826 "EHLO
	mta02.eastlink.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab0DUQWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 12:22:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Received: from ip05.eastlink.ca ([unknown] [24.222.39.68])
 by mta02.eastlink.ca (Sun Java(tm) System Messaging Server 7.3-11.01 64bit
 (built Sep  1 2009)) with ESMTP id <0L1800GVZIT1W7V1@mta02.eastlink.ca> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 13:22:13 -0300 (ADT)
Message-id: <4BCF2636.4010803@apple2pl.us>
Date: Wed, 21 Apr 2010 13:22:14 -0300
From: Donald Bailey <donnie@apple2pl.us>
To: linux-media@vger.kernel.org
Subject: Issue loading SAA7134 module
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've got a couple of boxes that have two no-name 8-chip SAA713X cards.  
Both have the same issue: the kernel will only set up the first eight on 
one board and only two on the second.  It leaves the other six unusable 
with error -23.  I am unable to figure out what that means.

Sample dmesg as follows.  More (/proc/ioports, /proc/interrupts, etc) 
can be posted if requested.  Tried kernels 2.6.18 and 2.6.33.2 on CentOS 
5.4 and Fedora 11 fully updated. The module is loaded as card=0. The 
following is output for chips 11 through 16.

saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
[card=0,autodetected]
saa7130[10]: board init: gpio is 10000
saa7130[10]: Huh, no eeprom present (err=-5)?
saa7130[10]: can't register video device
saa7134: probe of 0000:05:0f.0 failed with error -23

Thanks in advance,

Donald Bailey
