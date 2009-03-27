Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45290 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbZC0KnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 06:43:24 -0400
Date: Fri, 27 Mar 2009 07:42:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>,
	Jean-Francois Moine <moinejf@free.fr>,
	David Ellingsworth <david@identd.dyndns.org>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gspca: add missing .type field check in VIDIOC_G_PARM
Message-ID: <20090327074258.1cf99620@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0903191741540.28292@shell2.speakeasy.net>
References: <49C133F6.3020202@freemail.hu>
	<30353c3d0903181445i409604e8r33678f7ce09d0288@mail.gmail.com>
	<49C1DD0C.4050500@freemail.hu>
	<Pine.LNX.4.58.0903190032530.28292@shell2.speakeasy.net>
	<49C2C3C8.3000300@freemail.hu>
	<Pine.LNX.4.58.0903191741540.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009 17:47:13 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Thu, 19 Mar 2009, [UTF-8] Németh Márton wrote:
> > The gspca webcam driver does not check the .type field of struct v4l2_streamparm.
> > This field is an input parameter for the driver according to V4L2 API specification,
> > revision 0.24 [1]. Add the missing check.
> 
> I think this check could go in the v4l2 core too.  It already does a
> similar check for QUERYBUF, QBUF, DQBUF, etc.  If the driver doesn't
> provide a method for ->vidioc_try_fmt_foo() then the v4l2 core will reject
> a call with .type == V4L2_BUF_TYPE_foo.
> 
> It seems like it should be ok to do this for S_PARM and G_PARM too.

I agree. Could you provide such patch?

Cheers,
Mauro
