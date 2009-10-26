Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:42326 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZJZBH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2009 21:07:28 -0400
Received: by qyk4 with SMTP id 4so7459576qyk.33
        for <linux-media@vger.kernel.org>; Sun, 25 Oct 2009 18:07:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <156a113e0910251344k5799814dm8afe71d3bbfbe513@mail.gmail.com>
References: <156a113e0910251344k5799814dm8afe71d3bbfbe513@mail.gmail.com>
Date: Mon, 26 Oct 2009 02:07:32 +0100
Message-ID: <156a113e0910251807k43f259c7w4c52d966e3a6238c@mail.gmail.com>
Subject: Re: Almost got remote working with my "Winfast tv usb II Deluxe" box
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hm, it works better with the 64bit AMD version.

2009/10/25 Magnus Alm <magnus.alm@gmail.com>:
> Hi!
>
> This is on Ubuntu 9.04, kernel 2.6.28-16.
> I get the following in dmesg when pressing channel down on my remote:
>
> [ 3517.984559] : unknown key: key=0x90 raw=0x90 down=1
> [ 3518.096558] : unknown key: key=0x90 raw=0x90 down=0
>
> That should correspond with the following row in my keytable in ir-keymaps:
>
>        { 0x90, KEY_CHANNELDOWN},       /* CHANNELDOWN */
>
>
> Do I need to configure lirc also?
> But since something responds (ir-common ?) to my pressing on the
> remote I thought it shouldn't be necessary.
>
> /Magnus
>
