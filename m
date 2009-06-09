Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59665 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbZFICog (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 22:44:36 -0400
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
From: Andy Walls <awalls@radix.net>
To: Steven Toth <stoth@kernellabs.com>
Cc: David Ward <david.ward@gatech.edu>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4A2D7277.7080400@kernellabs.com>
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>
	 <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
	 <4A2D3A40.8090307@gatech.edu> <4A2D3CE2.7090307@kernellabs.com>
	 <4A2D4778.4090505@gatech.edu>  <4A2D7277.7080400@kernellabs.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 22:44:39 -0400
Message-Id: <1244515479.3147.159.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-08 at 16:20 -0400, Steven Toth wrote:


> Try installing a decent cable amp. Try looking at the MythTV wiki and support 
> sites for improving your cable network.

If using an amp, be sure you pick one with appropriate gain and noise
figure.   Overdriving the mxl5005s with too much signal can degrade SNR
as well.

Here's my standard list of things to check:

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality

Good luck.

Andy


