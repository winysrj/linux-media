Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:34930 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZFLUdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 16:33:17 -0400
Date: Fri, 12 Jun 2009 15:33:18 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Roger <rogerx@sdf.lonestar.org>
cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
In-Reply-To: <1244759335.9812.2.camel@localhost2.local>
Message-ID: <Pine.LNX.4.64.0906121531100.6470@cnc.isely.net>
References: <1244446830.3797.6.camel@localhost2.local>
 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>  <4A311A64.4080008@kernellabs.com>
  <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net> <1244759335.9812.2.camel@localhost2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I am unable to reproduce the s5h1411 error here.

However my HVR-1950 loads the s5h1409 module - NOT s5h1411.ko; I wonder 
if Hauppauge has changed chips on newer devices and so you're running a 
different tuner module.  That would explain the different behavior.  
Unfortunately it also means it will be very difficult for me to track 
the problem down here since I don't have that device variant.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
