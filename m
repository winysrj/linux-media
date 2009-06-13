Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:53427 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575AbZFMALL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 20:11:11 -0400
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
From: hermann pitton <hermann-pitton@arcor.de>
To: Mike Isely <isely@isely.net>
Cc: Andy Walls <awalls@radix.net>, Roger <rogerx@sdf.lonestar.org>,
	Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
In-Reply-To: <1244846370.3803.44.camel@pc07.localdom.local>
References: <1244446830.3797.6.camel@localhost2.local>
	 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
	 <4A311A64.4080008@kernellabs.com>
	 <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net>
	 <1244759335.9812.2.camel@localhost2.local>
	 <Pine.LNX.4.64.0906121531100.6470@cnc.isely.net>
	 <1244841123.3264.55.camel@palomino.walls.org>
	 <Pine.LNX.4.64.0906121627000.6470@cnc.isely.net>
	 <1244846370.3803.44.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 02:07:34 +0200
Message-Id: <1244851654.3777.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[snip]
> 
> The most undiscovered configurations seem to be such ones about antenna
> inputs and their switching. Again according to Hartmut, and he did not
> know exactly what is going on here, some for us and him at this point
> unknown checksums are used to derive even that information :(
> 
> For what I can see, and I might be of course still wrong, we can also
> not determine plain digital tuner types, digital demodulator types of
> any kind and the type of possibly present second and third tuners, but
> at least their addresses, regularly shared by multiple chips, become
> often visible. (some OEMs have only 0xff still for all that)

forgot, and not any LNB supplies behind some i2c bridges, shared or not
on whatever.

Regards.
Hermann


