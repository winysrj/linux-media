Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:52890 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZBFSjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Feb 2009 13:39:44 -0500
Date: Fri, 6 Feb 2009 19:30:13 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Adam Baker <linux@baker-net.org.uk>
Cc: Linux Media <linux-media@vger.kernel.org>,
	Driver Development <sqcam-devel@lists.sourceforge.net>,
	kilgota@banach.math.auburn.edu
Subject: Re: [PATCH v3] Add support for sq905 based cameras to gspca
Message-ID: <20090206193013.659c6de4@free.fr>
In-Reply-To: <200902061804.36756.linux@baker-net.org.uk>
References: <200902061804.36756.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Feb 2009 18:04:36 +0000
Adam Baker <linux@baker-net.org.uk> wrote:

> Add initial support for cameras based on the SQ Technologies SQ-905
> chipset (USB ID 2770:9120) to V4L2 using the gspca infrastructure.
> Currently only supports one resolution and doesn't attempt to inform
> libv4l what image flipping options are needed.

Applied.

As you did not add the supported webcam (Argus Digital Camera DC1512) to
	linux/Documentation/video4linux/gspca.txt,
I had a look at the ms-win driver, and this one also supports the
webcam 2770:9130 (TCG 501). May I (or you) add it in the sq905's
device_table?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
