Return-path: <linux-media-owner@vger.kernel.org>
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:32540 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751951AbZFNT4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 15:56:50 -0400
From: David Brownell <david-b@pacbell.net>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH (V2)] TVP514x: Migration to sub-device framework
Date: Sun, 14 Jun 2009 12:50:04 -0700
Cc: Hans Verkuil <hverkuil@xs4all.nl>, hvaibhav@ti.com,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
References: <hvaibhav@ti.com> <1241634693-28208-1-git-send-email-hvaibhav@ti.com> <200906141214.38355.hverkuil@xs4all.nl>
In-Reply-To: <200906141214.38355.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906141250.04455.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 June 2009, Hans Verkuil wrote:
> > +#define dump_reg(sd, reg, val)                               \
> >       do {                                                    \
> > -             val = tvp514x_read_reg(client, reg);            \
> > -             v4l_info(client, "Reg(0x%.2X): 0x%.2X\n", reg, val); \
> > +             val = tvp514x_read_reg(sd, reg);                \
> > +             v4l2_info(sd, "Reg(0x%.2X): 0x%.2X\n", reg, val); \
> >       } while (0)
> 
> Why not turn this into a static inline function? Much better than a macro.

IMO, too big for either.  Make it a real function.

