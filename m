Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:47373 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760030Ab2EJPYo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 11:24:44 -0400
Message-ID: <1336662597.15542.15.camel@iivanov-desktop>
Subject: Re: Advice on extending libv4l for media controller support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Sergio Aguirre <sergio.a.aguirre@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Atsuo Kuwahara <kuwahara@ti.com>
Date: Thu, 10 May 2012 18:09:57 +0300
In-Reply-To: <CAC-OdnCmXiz1wKST-YAambJFToeqNJhEaMVKYwz_FHV0N+sbyw@mail.gmail.com>
References: <CAC-OdnBNiT35tc_50QAXvVp8+b5tWLMWqc5i1q3qWYTp5c360g@mail.gmail.com>
	 <CAC-OdnCmXiz1wKST-YAambJFToeqNJhEaMVKYwz_FHV0N+sbyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sergio, 

On Thu, 2012-05-10 at 08:54 -0500, Sergio Aguirre wrote:
> +Atsuo
> 
> On Wed, May 9, 2012 at 7:08 PM, Sergio Aguirre
> <sergio.a.aguirre@gmail.com> wrote:
> > Hi Hans,
> >
> > I'm interested in using libv4l along with my omap4 camera project to
> > adapt it more easily
> > to Android CameraHAL, and other applications, to reduce complexity of
> > them mostly...
> >
> > So, but the difference is that, this is a media controller device I'm
> > trying to add support for,
> > in which I want to create some sort of plugin with specific media
> > controller configurations,
> > to avoid userspace to worry about component names and specific
> > usecases (use sensor resizer, or SoC ISP resizer, etc.).
> >
> > So, I just wanted to know your advice on some things before I start
> > hacking your library:
> >

Probably following links can help you. They have been tested
with the OMAP3 ISP.

Regards,
iivanov

[1] http://www.spinics.net/lists/linux-media/msg31901.html
[2]
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/32704


