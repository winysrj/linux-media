Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:60017 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932411AbcKGRXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 12:23:34 -0500
Date: Mon, 7 Nov 2016 09:01:34 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161107170133.4jdeuqydthbbchaq@x>
References: <20161107075524.49d83697@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161107075524.49d83697@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 07, 2016 at 07:55:24AM -0200, Mauro Carvalho Chehab wrote:
> 2) add an Sphinx extension that would internally call ImageMagick and/or
>    inkscape to convert the bitmap;

This seems sensible; Sphinx should directly handle the source format we
want to use for images/diagrams.

> 3) if possible, add an extension to trick Sphinx for it to consider the 
>    output dir as a source dir too.

Or to provide an additional source path and point that at the output
directory.
