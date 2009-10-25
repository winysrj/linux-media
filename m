Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:49847 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZJYUoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2009 16:44:16 -0400
Received: by qw-out-2122.google.com with SMTP id 9so1681581qwb.37
        for <linux-media@vger.kernel.org>; Sun, 25 Oct 2009 13:44:20 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 25 Oct 2009 21:44:20 +0100
Message-ID: <156a113e0910251344k5799814dm8afe71d3bbfbe513@mail.gmail.com>
Subject: Almost got remote working with my "Winfast tv usb II Deluxe" box
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is on Ubuntu 9.04, kernel 2.6.28-16.
I get the following in dmesg when pressing channel down on my remote:

[ 3517.984559] : unknown key: key=0x90 raw=0x90 down=1
[ 3518.096558] : unknown key: key=0x90 raw=0x90 down=0

That should correspond with the following row in my keytable in ir-keymaps:

	{ 0x90, KEY_CHANNELDOWN},	/* CHANNELDOWN */


Do I need to configure lirc also?
But since something responds (ir-common ?) to my pressing on the
remote I thought it shouldn't be necessary.

/Magnus
