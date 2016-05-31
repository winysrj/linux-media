Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34444 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbcEaHRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 03:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <1464677903-28412-1-git-send-email-songjun.wu@atmel.com>
References: <1464677903-28412-1-git-send-email-songjun.wu@atmel.com>
Date: Tue, 31 May 2016 09:17:09 +0200
Message-ID: <CAMuHMdV5pqAEea7v7WbQ2FSSve92avte4B=j53-12s842D-Xdg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] [media] atmel-isc: add driver for Atmel ISC
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Songjun Wu <songjun.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Rob Herring <robh@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?Q?Richard_R=C3=B6jfors?= <richard@puffinpack.se>,
	Benoit Parrot <bparrot@ti.com>,
	Kumar Gala <galak@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mark Rutland <mark.rutland@arm.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Simon Horman <horms+renesas@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Songjun,

On Tue, May 31, 2016 at 8:58 AM, Songjun Wu <songjun.wu@atmel.com> wrote:
> The Image Sensor Controller driver includes two parts.
> 1) Driver code to implement the ISC function.
> 2) Device tree binding documentation, it describes how
>    to add the ISC in device tree.

Please reduce the CC list. Not everyone who ever touched a line in the
files you modified is working on media or atmel devices.

get_maintainer.pl gives hints, not exact lists of people.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
