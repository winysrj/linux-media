Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:52194 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab0A0Sfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 13:35:48 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id C265E8181E6
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 19:35:43 +0100 (CET)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 9916381815F
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 19:35:40 +0100 (CET)
Date: Wed, 27 Jan 2010 19:37:28 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Setting up white balance on a t613 camera
Message-ID: <20100127193728.0a75ba1e@tele>
In-Reply-To: <20100127171753.GA10865@pathfinder.pcs.usp.br>
References: <20100126170053.GA5995@pathfinder.pcs.usp.br>
	<20100126193726.00bcbc00@tele>
	<20100127163709.GA10435@pathfinder.pcs.usp.br>
	<20100127171753.GA10865@pathfinder.pcs.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Jan 2010 15:17:53 -0200
Nicolau Werneck <nwerneck@gmail.com> wrote:

> Answering my own question, and also a question in the t613 source
> code...
> 
> Yes, the need for the "reg_w(gspca_dev, 0x2087);", 0x2088 and 0x2089
> commands are definitely tied to the white balance. These three set up
> the default values I found out. And (X << 8 + 87) sets up the red
> channel parameter in general, and 88 is for green and 89 for blue.
> 
> That means I can already just play with them and see what happens. My
> personal problem is that I bought this new lens, and the image is way
> too bright, and changing that seems to help. But I would like to offer
> these as parameters the user can set using v4l2 programs. I can try
> making that big change myself, but help from a more experienced
> developer would be certainly much appreciated!...

Hello Nicolau,

The white balance is set in setwhitebalance(). Four registers are
changed: 87, 88, 89 and 80.

Looking at the traces I have, these 4 registers are loaded together only
one time in an exchange at startup time. Then, the white balance
control adjusts only blue and red values while reloading the same value
for the green register (that's what is done for other webcams), and the
register 80 is not touched. In the different traces, the register 80
may be initialized to various values as 3c, ac or 38 and it is not
touched later. I do not know what it is used for.

I may also notice that the green value in the white balance exchanges
may have an other value than the default 20. I do not know which is the
associated control in the ms-win driver. If it is exposure, you are
done. So, one trivial patch is:

- add the exposure control with min: 0x10, max: 0x40, def: 0x20.

- modify the whitebalance control with min: -16, max +16, def:0.

- there is no function setexposure() because the exposure is the value
  of green register. Both controls exposure and white balance call the
  function setwhitebalance().

- in the function setwhitebalance(), set the green value to the
  exposure, the red value to (exposure + whitebalance) and blue value
  to (exposure - whitebalance) and load only the registers 87, 88 and
  89.

An other way could be to implement the blue and red balances in the
same scheme, and to remove the whitebalance.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
