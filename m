Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:35962 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab3JOWAL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 18:00:11 -0400
Date: Tue, 15 Oct 2013 23:59:43 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Tom Gundersen <teg@jklm.no>
Cc: "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
	Sean Young <sean@mess.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: WPC8769L (WEC1020) support in winbond-cir?
Message-ID: <20131015215943.GC26542@hardeman.nu>
References: <CAG-2HqX-TO7h8zJ6F01r2LfRVjQtb0pK_1wKGsYVKzB0zC7TQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG-2HqX-TO7h8zJ6F01r2LfRVjQtb0pK_1wKGsYVKzB0zC7TQA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 14, 2013 at 03:16:20PM +0200, Tom Gundersen wrote:
>Hi David and Juan,
>
>I'm going through the various out-of-tree LIRC drivers to see if we
>can stop shipping them in Arch Linux [0]. So far it appears we can
>drop all except for lirc_wpc8769l [1] (PnP id WEC1020).
>
>I noticed the comment in windownd-cir [2]:
>
> *  Currently supports the Winbond WPCD376i chip (PNP id WEC1022), but
> *  could probably support others (Winbond WEC102X, NatSemi, etc)
> *  with minor modifications.
>
>What are your thoughts on adding support for WEC1020 upstream? Is
>anyone interested in doing this work (I sadly don't have the correct
>device, so can't really do it myself)?

IIRC, Juan had a hacked-up version of the winbond-cir driver working on
his hardware back in March (the hardware seems similar enough, basically
the WEC1022 adds some additional Wake-On-IR functionality...I seem to
recall).

But I think Juan is the one to talk to. I don't have the WEC1020
hardware and I don't have his experience of adding support for it...

-- 
David Härdeman
