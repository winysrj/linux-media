Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:36320 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZJ0F4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 01:56:08 -0400
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: Magnus Alm <magnus.alm@gmail.com>
Subject: Re: Almost got remote working with my "Winfast tv usb II Deluxe" box
Date: Tue, 27 Oct 2009 06:56:07 +0100
Cc: linux-media@vger.kernel.org
References: <156a113e0910251344k5799814dm8afe71d3bbfbe513@mail.gmail.com>
In-Reply-To: <156a113e0910251344k5799814dm8afe71d3bbfbe513@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910270656.07196.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 25 of October 2009 at 21:44:20, Magnus Alm wrote:
> Hi!

Hi Magnus,

> This is on Ubuntu 9.04, kernel 2.6.28-16.
> I get the following in dmesg when pressing channel down on my remote:
>
> [ 3517.984559] : unknown key: key=0x90 raw=0x90 down=1
> [ 3518.096558] : unknown key: key=0x90 raw=0x90 down=0
>
> That should correspond with the following row in my keytable in ir-keymaps:
>
> 	{ 0x90, KEY_CHANNELDOWN},	/* CHANNELDOWN */
>

That is right. The "unknown key" gives a hint for your keymap. After you 
define all keys, you should fully enjoy your remote control.

> Do I need to configure lirc also?

The keys are emitted via the evdev subsystem, so the remote control behaves 
like a normal keyboard (when you press "1" you should see "1" on the console 
too). Either you will learn your application to directly understand the key 
presses (just change it's keyboard shortcuts), or you can use the lirc's 
devinput driver (it reads keypresses from evdev) and do it via lirc. It's up 
to you.

Oldrich.

> But since something responds (ir-common ?) to my pressing on the
> remote I thought it shouldn't be necessary.
>
> /Magnus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
