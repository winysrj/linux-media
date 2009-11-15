Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:39484 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbZKOInc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 03:43:32 -0500
Date: Sun, 15 Nov 2009 09:43:42 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Dotan Cohen <dotancohen@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: MSI StarCam 370i: The right way?
Message-ID: <20091115094342.759cee65@tele>
In-Reply-To: <880dece00911140735n14f79fb6k6e854a5a852ff6fe@mail.gmail.com>
References: <880dece00911140735n14f79fb6k6e854a5a852ff6fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Nov 2009 17:35:28 +0200
Dotan Cohen <dotancohen@gmail.com> wrote:

> I have just installed a new Kubuntu 9.10 install with the
> 2.6.31-14-generic (stock) kernel. I need to get an MSI StarCam i370
> working on this machine. The lsusb command shows the device as such:
> Bus 003 Device 002: ID 0c45:60fc Microdia PC Camera with Mic (SN9C105)
	[snip]

Hello Dotan,

In the kernel you have (2.6.31) two drivers may try to handle your
webcam: gspca_sonixj and sn9c102. If both are generated, the active
driver changes at each webcam unplug/replug (you may know which driver
is active looking at the last lines of 'dmesg').

If the driver gspca_sonixj does not work, you may try its last version
from LinuxTv.org (many bugs have been found since kernel 2.6.31).

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
