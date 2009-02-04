Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:9452
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbZBDWek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2009 17:34:40 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: kilgota@banach.math.auburn.edu
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
Date: Wed, 4 Feb 2009 22:34:36 +0000
Cc: Andy Walls <awalls@radix.net>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <200901192322.33362.linux@baker-net.org.uk> <200902042138.05028.linux@baker-net.org.uk> <alpine.LNX.2.00.0902041610030.3988@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0902041610030.3988@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042234.37125.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 February 2009, kilgota@banach.math.auburn.edu wrote:
<snip description of attempting to stream from 2 cameras at once>
> 4. After removing the first camera which was plugged in, I tried to start
> the stream from the second one. The stream will not start. A message says
> that
>
> Cannot identify 'dev/video0': 2. No such file or directory.

This line points to an error in your test method.

You need to start the second stream with svv -d /dev/video1 to tell it to pick 
the second camera.

Adam
