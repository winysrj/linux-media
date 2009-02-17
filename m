Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:36318 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZBQFsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 00:48:55 -0500
Received: by gxk22 with SMTP id 22so3824120gxk.13
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2009 21:48:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BAY102-W54F614817092361870868DCFB40@phx.gbl>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
	 <BAY102-W3919BC0C2532C366EEDB1FCFB90@phx.gbl>
	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
	 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
	 <BAY102-W54F614817092361870868DCFB40@phx.gbl>
Date: Tue, 17 Feb 2009 00:48:53 -0500
Message-ID: <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
Subject: =?windows-1256?Q?Re=3A_HVR=2D1500_tuner_seems_to_be_recognized=2C_but_wont_?=
	=?windows-1256?Q?turn_on=2E=FE?=
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Thomas Nicolai <nickotym@hotmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/2/17 Thomas Nicolai <nickotym@hotmail.com>:
>
> I have tried this a couple times, but when I unplug the card, the computer freezes.  Any solutions to that?  Will it work to do the modprobe you listed after turning the computer on and leaving the card out, then putting it in and then doing the modprobe?

Are you saying that independent of the steps I provided the computer
always freezes when you unplug the card?  If so, then that's a
separate issue that should be investigated.

But to answer your question, yes you should be able to achieve the
same result by leaving the card out, booting up, doing the modprobe,
and plugging the card in (as long as you don't have any other tuners
installed in your PC that use the xc3028 tuner).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
