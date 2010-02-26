Return-path: <linux-media-owner@vger.kernel.org>
Received: from warped.bluecherry.net ([66.138.159.247]:47886 "EHLO
	warped.bluecherry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0BZWGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 17:06:42 -0500
Received: from [192.168.1.126] (office.bluecherry.net [69.27.206.208])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by warped.bluecherry.net (Postfix) with ESMTPSA id E3696A271C26
	for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 16:06:41 -0600 (CST)
Message-ID: <4B8845F1.5070608@bluecherry.net>
Date: Fri, 26 Feb 2010 16:06:41 -0600
From: Curtis Hall <curt@bluecherry.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [bttv] Auto detection for Provideo PV- series capture cards
References: <4B882E3A.8050604@bluecherry.net> <4B884034.8080508@redhat.com>
In-Reply-To: <4B884034.8080508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Let's go by parts:
>
> The entry for PV-150 were added at -hg tree by this changeset:
> changeset:   784:3c31d7e0b4bc
> user:        Gerd Knorr
> date:        Sun Feb 22 01:59:34 2004 +0000
> summary:     Initial revision
>
> Probably, this is a discontinued model, but I don't know for sure.
>   
We have been Provideo's US distributor since late 2004 and I've not 
heard of a PV-150 part number, and isn't not a current part number.
> This one is easy:
>   
> [   13.438412] bttv0: subsystem: 1830:1540 (UNKNOWN)
>
> As this PCI ID is not known, it is just a matter of associating the PV-183
> ID's with card 98.
>   

I figured, thanks
> Just for reference the PV-149 / PV-981 / PV-183 series cards are:
>
> PV-149 - 4 port, 4 BT878a chips - no forced card setting required
> PV-155 - 16 port, 4 BT878a chips - card=77,77,77,77  (Shares the same
> board and PCI ID / subsystem as the PV-149)
>   
>
> Hmm... PV-155 shares the same PCI ID as PV-149, but require a different
> entry, then we shouldn't add it to the PV-150 autodetection code.
>   
Okay.  You can easily access four ports on the PV-155 / PV-981, but to 
access the sub (/dev/videoX,1-3) channels you need to add the modprobe line.
> The better would be to check with the manufacturer if is there a
> way to detect between those two boards (maybe reading eeprom?).
>
>   
I can find out, but getting technical data from Provideo can be more 
painful then pulling teeth.
> Why do you need the card= parameter, if it shares the same subsystem 
> ID as the other PV-981 models?

I think I explained that about with the sub channels, if I'm missing 
something let me know.

Thanks!

-- 
--
Curtis Hall (curt@bluecherry.net)
Bluecherry - www.bluecherry.net
(877) 418-3391 x 201 

