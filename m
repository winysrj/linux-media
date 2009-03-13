Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:22994 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751850AbZCMSpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 14:45:40 -0400
From: David Brownell <david-b@pacbell.net>
To: chaithrika@ti.com
Subject: Re: [RFC 5/7] ARM: DaVinci: DM646x Video: Makefile and config files modifications for Display
Date: Fri, 13 Mar 2009 10:45:35 -0800
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
References: <1236934923-32216-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1236934923-32216-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903131145.36459.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 March 2009, chaithrika@ti.com wrote:
>  
> +config DISPLAY_DAVINCI_DM646X_EVM
> +        tristate "DM646x EVM Video Display"
> +        depends on VIDEO_DEV && MACH_DAVINCI_DM646X_EVM
> +        select VIDEOBUF_DMA_CONTIG
> +        select VIDEO_DAVINCI_VPIF
> +        select VIDEO_ADV7343
> +        select VIDEO_THS7303

A quick glance at the dm646x_display.c code in patch 7
suggests that the file name is generic, but the code is
full of EVM-specific bits.

I suggest either making the code generic (and maybe move
most of that VPIF code into the VPIF driver) so other
dm646x boards can reuse it ... or renaming it.  Generic
would IMO be preferrable.


> +config VIDEO_DAVINCI_VPIF
> +        tristate "DaVinci VPIF Driver"
> +        depends on DISPLAY_DAVINCI_DM646X_EVM

Please have the Kconfig helptext here explain what a VPIF
is and does.

Surely the driver is usable for any dm646x board, not just
the EVM hardware; so, "depends on ARCH_DAVINCI_DM646x".

And, patch style point, most of us like to see one patch
adding an entire driver ... C source, headers, and its
associated Kconfig and Kbuild support.  Make sure that
the kernel continues building between patches; in this
case, the build will break after patch #5 since the
source code it tries to build hasn't been added yet.



