Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:50557 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZJDQl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 12:41:57 -0400
Date: Sun, 4 Oct 2009 18:41:13 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: James Blanford <jhblanford@gmail.com>, linux-media@vger.kernel.org,
	Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Subject: Re: Race in gspca main or missing lock in stv06xx subdriver?
Message-ID: <20091004184113.2af754a7@tele>
In-Reply-To: <4AC8C117.6060406@redhat.com>
References: <20090914111757.543c7e77@blackbart.localnet.prv>
	<20090915124106.35ad1382@tele>
	<4AC8C117.6060406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 04 Oct 2009 17:36:55 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> As Jean-Francois very correctly pointed out, but no worries. The
> handling of isoc irq's is serialised elsewhere in the kernel, the
> issue of what James is seeing is much simpler.
> 
> When we call gspca_frame_add, it returns a pointer to the frame
> passed in, unless we call it with LAST_PACKET, when it will return a
> pointer to a new frame in to whoch store the frame data for the next
> frame. So whenever calling:
> gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);
> we should do this as:
> frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);
> 
> So that any further data got from of the pkt we are handling in
> pkt_scan, goes to the next frame.
> 
> We are not doing this in stv06xx.c pkt_scan method, which the cause
> of what James is seeing. So I started checking all drivers, and we
> are not doing this either in ov519.c when handling an ov518 bridge.
> So now the framerate of my 3 ov518 test cams has just doubled. Thanks
> James!
> 
> I'll send a patch with the fix in a separate mail.

Hello Hans,

Thank you for the patch. Yes, it was simple and I should have seen it
before! I think this problem could be avoided if the frame pointer is
not given to the pkt_scan function (if the subdriver needs it, it is
returned by gspca_get_i_frame).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
