Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:61174 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZCOTAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 15:00:30 -0400
Received: by yx-out-2324.google.com with SMTP id 8so804202yxm.1
        for <linux-media@vger.kernel.org>; Sun, 15 Mar 2009 12:00:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.58.0903150922360.28292@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl>
	 <20090304141715.0a1af14d@pedra.chehab.org>
	 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
	 <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
	 <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
	 <Pine.LNX.4.58.0903051243270.24268@shell2.speakeasy.net>
	 <Pine.LNX.4.64.0903052315530.4980@axis700.grange>
	 <Pine.LNX.4.58.0903061532210.24268@shell2.speakeasy.net>
	 <Pine.LNX.4.64.0903070144520.5665@axis700.grange>
	 <Pine.LNX.4.58.0903150922360.28292@shell2.speakeasy.net>
Date: Sun, 15 Mar 2009 15:00:28 -0400
Message-ID: <412bdbff0903151200l4fc74b82i99045306e95eb162@mail.gmail.com>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 15, 2009 at 12:39 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
> It seems like the real complaint is that dealing v4l-dvb's development
> system is more work for those people who choose not to use it.  Why don't
> we just switch to CVS while were at it, to make it easier for those who
> don't want to learn git?

Personally, the problem for me is not one of which source control
system we use.  I don't care if it's cvs, svn, bzr, hg, or git.  What
I do care about is what the tree contains.

I do all of my development on a stock Ubuntu box that is running the
latest stable release (Intrepid right now).  I want to do v4l-dvb
development, but I do *not* want to be required to run the bleeding
edge kernel.  I want to do v4l-dvb development without having to worry
about whether my wireless chipset is going to work today, or my video
driver.  Having a stable distro allows me to focus on *my* driver
without being susceptible to breakage unrelated to my work.

I know I'm not the only one who develops with this model.  This is not
just an issue about the people looking to test the tree.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
