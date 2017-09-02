Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50524 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbdIBN3Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 09:29:25 -0400
Date: Sat, 2 Sep 2017 15:29:13 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v4l-utils] configure.ac: drop --disable-libv4l, disable
 plugin support instead
Message-ID: <20170902152913.437413aa@windsurf.lan>
In-Reply-To: <eb9e0ad2-1003-f861-9cc0-7bdb77939af8@xs4all.nl>
References: <20170821210206.21055-1-thomas.petazzoni@free-electrons.com>
        <eb9e0ad2-1003-f861-9cc0-7bdb77939af8@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, 23 Aug 2017 13:06:13 +0200, Hans Verkuil wrote:
> On 08/21/17 23:02, Thomas Petazzoni wrote:
> > In commit 2e604dfbcd09b93f0808cedb2a0b324c5569a599 ("configure.ac: add
> > --disable-libv4l option"), an option --disable-libv4l was added. As
> > part of this, libv4l is no longer built at all in static linking
> > configurations, just because libv4l uses dlopen() for plugin support.
> > 
> > However, plugin support is only a side feature of libv4l, and one may
> > need to use libv4l in static configurations, just without plugin
> > support.
> > 
> > Therefore, this commit:
> > 
> >  - Essentially reverts 2e604dfbcd09b93f0808cedb2a0b324c5569a599, so
> >    that libv4l can be built in static linking configurations again.
> > 
> >  - Adjusts the compilation of libv4l2 so that the plugin support is
> >    not compiled in when dlopen() in static linking configuration
> >    (dlopen is not available).
> > 
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > ---
> > NOTE: this was only build-time tested, not runtime tested.  
> 
> Hugues, can you test this to make sure this still does what you need?
> 
> It looks good to me, but I'd like to make sure it works for you as well
> before committing this.

Thanks for your feedback. Unfortunately, Hugues has not answered. What
can we do ?

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
