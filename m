Return-path: <linux-media-owner@vger.kernel.org>
Received: from Harmony.ukdc.aig.com ([195.33.113.40]:29157 "EHLO
	harmony.ukdc.aig.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbZLKPmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 10:42:31 -0500
Received: from xredimc1.exchange.ukdc.aig.com (XREDIMC1.exchange.ukdc.aig.com [172.27.9.13])
	by REDPLPPS2.aig.com (8.14.1/8.14.1) with ESMTP id nBBFJosV008357
	for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 15:19:50 GMT
From: "Rochet, Christophe" <Christophe.Rochet@AIG.com>
To: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Date: Fri, 11 Dec 2009 15:19:49 +0000
Subject: RE: dib0700: Nova-T-500 remote - mixed button codes
Message-ID: <CFDDDF371FF6814E9445C4C937125CE6027007F3C6@CROP3MMBX03.mail.aig.net>
References: <200912111509.51455.amlopezalonso@gmail.com>
In-Reply-To: <200912111509.51455.amlopezalonso@gmail.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio.

Did you switched also the IR remote sensor itself ?

I experienced same weird things with a WinovaTV years ago, and finally the IR phototransistor in the small round receiver was crappy.
When I changed it by a common spare it all came right.

Protect also your IR sensor from AC lights...

If you experiment "random" keys, a noisy IR signal or dead receiver is perhaps the cause.

If you experiment always the same button jam, that's something else.

Regards.

-----Message d'origine-----
De : linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] De la part de Antonio Marcos López Alonso
Envoyé : vendredi 11 décembre 2009 16:10
À : linux-media@vger.kernel.org
Objet : dib0700: Nova-T-500 remote - mixed button codes

Hi all,

I own a Hauppauge Nova-T-500 in a box running Mythbuntu 9.10. The card runs 
fine except when it comes to the in-built remote sensor: 

Whenever I press any button, the remote sensor seems to receive some other 
keycodes aside the proper one (i.e. when I press Volume Up button the sensor 
receives it most of the time, but sometimes it understands some other buttons 
are pressed like ArrowDown, Red button and so, making MythTV experience very 
annoying). There are only three buttons that are always well received with no 
confusion at all: "OK", "ArrowDown" and "Play". This behavior occurs with two 
identical remotes I own (one of them belonging to a WinTV HVR-1100) and 
another card user has reported a similar behavior with its own and same 
remote.

I tested both remotes with the HVR-1100 and they behave perfectly, so I guess 
this is not a remote related issue.

Though I have tried several LIRC setup files and swapped dvb_usb_dib0700 
firmware files (1.10 and 1.20 versions) they make no working difference at 
all.

I also tried rebuilding v4l-dvb code to no avail.

Any suggestions? I would gladly provide further info/logs upon request.

Cheers,
Antonio
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
