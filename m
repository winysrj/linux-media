Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw10.wm.net ([85.119.129.3]:47949 "EHLO mailgw11.wm.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752658AbZFHGMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 02:12:10 -0400
Received: from WMSI001556.corp.wmdata.net (wmsi001556.wmdata.se [164.9.238.12])
	by mailgw11.wm.net  with ESMTP id n586C9wJ021966
	for <linux-media@vger.kernel.org>; Mon, 8 Jun 2009 08:12:10 +0200
From: "Sandell, Anders" <anders.sandell@logica.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 8 Jun 2009 08:11:53 +0200
Subject: SV: /dev/dvb/adapter0/dvr0 gives no output
Message-ID: <22162B491802D04F87B02036F8E317992B6A9F1D71@SE-EX008.groupinfra.com>
References: <22162B491802D04F87B02036F8E317992B6A9F19BE@SE-EX008.groupinfra.com>
 <20090605170933.GA27551@aidi.santinoli.com>
In-Reply-To: <20090605170933.GA27551@aidi.santinoli.com>
Content-Language: sv-SE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, sorry, RTFM I guess.

//Anders

-----Ursprungligt meddelande-----
Från: David Santinoli [mailto:marauder@tiscali.it] 
Skickat: den 5 juni 2009 19:10
Till: Sandell, Anders
Kopia: linux-media@vger.kernel.org
Ämne: Re: /dev/dvb/adapter0/dvr0 gives no output

On Fri, Jun 05, 2009 at 06:06:42PM +0200, Sandell, Anders wrote:
> Everything looks just fine but when trying "cat /dev/dvb/adapter0/dvr0 > file.mpg" nothing happens, the file never get any contents.
> 
> Szap-s2 also seems to be working locking on to BBC World:

Don't know much about szap-s2, but if it works like szap, you might have
to add '-r' in the command line to enable the dvr0 device.

HTH,
 David

