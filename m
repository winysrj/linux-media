Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:49708 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbFVVTG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 17:19:06 -0400
Date: Mon, 22 Jun 2015 22:18:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Build regressions/improvements in v4.1
Message-ID: <20150622211857.GY7557@n2100.arm.linux.org.uk>
References: <1435006096-12470-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdXprKyxirhUZBzNV97oxymcMqeugKixTEC8ojcMq3EeDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXprKyxirhUZBzNV97oxymcMqeugKixTEC8ojcMq3EeDw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 22, 2015 at 10:52:13PM +0200, Geert Uytterhoeven wrote:
> On Mon, Jun 22, 2015 at 10:48 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v4.1[1] to v4.1-rc8[3], the summaries are:
> >   - build errors: +44/-7
> 
>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
> 'L_PTE_MT_BUFFERABLE' undeclared here (not in a function):  => 81:10
>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
> 'L_PTE_MT_DEV_CACHED' undeclared here (not in a function):  => 117:10
>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
> 'L_PTE_MT_DEV_NONSHARED' undeclared here (not in a function):  =>
> 108:10

I'm rather ignoring this because I don't see these errors here.  This
is one of the problems of just throwing out build reports.  With zero
information such as a configuration or a method on how to cause the
errors, it's pretty much worthless to post errors.

Folk who do build testing need to be smarter, and consider what it's
like to be on the receiving end of their report emails...

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
