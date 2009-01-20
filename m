Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:37443 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZATIZw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 03:25:52 -0500
Date: Tue, 20 Jan 2009 09:22:29 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "T.P. Reitzel" <4066724035@vzwmail.net>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca_spca505
Message-ID: <20090120092229.57d6fbfc@free.fr>
In-Reply-To: <49751737.1020101@vzwmail.net>
References: <49751737.1020101@vzwmail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009 17:13:43 -0700
"T.P. Reitzel" <4066724035@vzwmail.net> wrote:

> I just pulled mercurial's v4l-dvb for Bluewhite64's 2.6.27.7 kernel.
> This spca505 driver for Intel's PC Camera Pro, 0733:0430 isn't even
> functioning. The MMAP feature of this driver just displays a screen of
> horizontal green lines. Furthermore, M. Xhaard stripped the external
> composite feature from this driver a few years ago and no one has yet
> added it back. If you visit the original website for this driver on
> sourceforge.net, you'll see the original driver for this video camera
> including composite support. As it is, the driver for this camera is
> totally inoperative.

What do you mean by "composite support"?

Otherwise, none of the webcams of the spca505 subdriver have been
tested since the conversion from v1 to v2. I'd be glad to have more
information about what happens with this subdriver. May you read the
gspca_README.txt from my page (see below) and send me the results?

Thank you.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
