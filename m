Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47340
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbcHVKci (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 06:32:38 -0400
Date: Mon, 22 Aug 2016 07:32:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: LMML <linux-media@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: [ANNOUNCE] Linux Kernel Media Subsystem documentation now available
 in PDF format
Message-ID: <20160822073233.706ab8b2@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

As you know, the media documentation is daily-built from the Linux Kernel
sources, in HTML format, from its ReST files.

Starting today, it will also be building the PDF book with all the Kernel
Media documentation on it. Despite having 1031 pages, the PDF file has
only 3.3 MB.

I prefer myself handling the documentation in PDF format, as we have
everything there on just one file. Yet, a few tables have small fonts.

There are still some things that need to be done to improve the PDF
format, specially with regards to its index and to the way it numerates
the document parts and sections, but not sure if we'll have any short
term solution, as the Sphinx tool, used to build a LaTeX file is pretty
much limited for such format, at least up to its version 1.4.6.

Anyway, if you want to look into it, The PDF file is available at:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media.pdf

Thanks,
Mauro
