Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43765 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab0FRG0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jun 2010 02:26:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: sub device device node and ioctl support?
Date: Fri, 18 Jun 2010 08:29:37 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A69FA2915331DC488A831521EAE36FE4016B3A7671@dlee06.ent.ti.com> <201006170903.12665.laurent.pinchart@ideasonboard.com> <A69FA2915331DC488A831521EAE36FE4016B3A7873@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016B3A7873@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006180829.38466.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

On Thursday 17 June 2010 16:44:03 Karicheri, Muralidharan wrote:
> Laurent,
> 
> > The media controller upstreaming process will start in one or two weeks.
> > This will require a lot of time, so everything won't be ready for 2.6.36.
> >
> > This being said, the subdevice userspace API is the first part of the
> > media controller that will be pushed upstream.
> 
> Is this already being reviewed in the list? If not, I suggest you send it
> for review separately, not with the media controller patch set.

Patches haven't been posted yet. That's planned for next week or the one after 
that.

> > Getting it ready for 2.6.36 might be a bit difficult, it will depend on
> > how many rc cycles we still get for 2.6.35. It will also depend on how
> > fast the patches get reviewed, so you can help there :-)
> 
> Of course I will review this since I need it for my work. If you can make
> it against the v4l-dvb latest tree, I can apply and get it tested since we
> are working on to add osd sub device for DMxxx VPBE display driver.

That shouldn't be too difficult.

-- 
Regards,

Laurent Pinchart
