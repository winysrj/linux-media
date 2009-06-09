Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:40242 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZFITHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 15:07:49 -0400
Received: by qw-out-2122.google.com with SMTP id 5so136647qwd.37
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 12:07:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A2EB233.3080800@kernellabs.com>
References: <4A2CE866.4010602@gatech.edu> <4A2D4778.4090505@gatech.edu>
	 <4A2D7277.7080400@kernellabs.com>
	 <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
	 <4A2E6FDD.5000602@kernellabs.com>
	 <829197380906090723t434eef6dje1eb8a781babd5c7@mail.gmail.com>
	 <4A2E70A3.7070002@kernellabs.com> <4A2EAF56.2090508@gatech.edu>
	 <829197380906091155u43319c82i548a9f08928d3826@mail.gmail.com>
	 <4A2EB233.3080800@kernellabs.com>
Date: Tue, 9 Jun 2009 15:07:50 -0400
Message-ID: <829197380906091207s19df864cl50fd14d57abb1dd4@mail.gmail.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: David Ward <david.ward@gatech.edu>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 9, 2009 at 3:04 PM, Steven Toth <stoth@kernellabs.com> wrote:
>
> 40db.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>

Just checked the source.  It's 40dB for QAM256, but 30dB for ATSC and
QAM64.  Are we sure he's doing QAM256 and not QAM64?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
