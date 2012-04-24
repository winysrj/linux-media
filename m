Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:44274 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2DXKdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 06:33:22 -0400
Date: Tue, 24 Apr 2012 12:34:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] tinyjpeg: Dynamic luminance quantization table for
 Pixart JPEG
Message-ID: <20120424123412.3b63810d@tele>
In-Reply-To: <4F95CACD.5010403@redhat.com>
References: <20120412122017.0c808009@tele>
	<4F95CACD.5010403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Apr 2012 23:34:05 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Thanks for your work on this! I've just spend almost 4 days wrestling
> which the Pixart JPEG decompression code to try to better understand
> these cams, and I have learned quite a bit and eventually came up
> with a different approach.
> 
> But your effort is appreciated! After spending so much time on this
> myself, I can imagine that it took you quite some time to come up
> with your solution.
> 
> Attach is a 4 patch patchset which I plan to push to v4l-utils
> tomorrow (after running some more tests in daylight). I'll also try
> to do some kernel patches tomorrow to match...

Hi Hans,

I tried your patch, but I am not happy with the images I have (pac7302).

You say that the marker cannot be in the range 0..31 (index 0..7), but
I have never seen a value lower than 68 (index 17).

This last marker value (68) is the default when the images have no big
contrasts. With such images / blocks, the standard JPEG quantization
table does not work well. It seems that, for this value, the table
should be full of either 7 or 8 (8 gives a higher contrast).

Here is the sequence which works better (around line 1420 of tinyjpeg.c):

-------------8<--------------
		/* And another special Pixart feature, the DC quantization
		   factor is fixed! */
		qt[0] = 7;			// 8 gives a higher contrast
// special case for 68
	if (marker == 68) {
		for (i = 1; i < 64; i++)
			qt[i] = 7;		// also works with 8
	} else {
		for (i = 1; i < 64; i++) {
			j = (standard_quantization[0][i] * comp + 50) / 100;
			qt[i] = (j < 255) ? j : 255;
		}
	}
		build_quantization_table(priv->Q_tables[0], qt);
-------------8<--------------

About the other marker values, it seems also that the quantization
tables are not optimal: some blocks are either too much (small
contrasted lines) or not enough (big pixels) decompressed. As you know,
a finer adjustment would ask for a long test time, so, I think we can
live with your code.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
