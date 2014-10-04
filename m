Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39397 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaJDOWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Oct 2014 10:22:53 -0400
Date: Sat, 4 Oct 2014 11:22:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Subject: Re: Upcoming v4l-utils 1.6.0 release
Message-ID: <20141004112245.7a5de7de@recife.lan>
In-Reply-To: <542ADA66.3040905@redhat.com>
References: <20140925213820.1bbf43c2@recife.lan>
	<54269807.50109@googlemail.com>
	<20140927085455.5b0baf89@recife.lan>
	<542ACA32.3050403@googlemail.com>
	<542ADA66.3040905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Sep 2014 18:29:26 +0200
Hans de Goede <hdegoede@redhat.com> escreveu:

> Hi,
> 
> On 09/30/2014 05:20 PM, Gregor Jasny wrote:
> > Hello,
> >
> > On 27/09/14 13:54, Mauro Carvalho Chehab wrote:
> >> Em Sat, 27 Sep 2014 12:57:11 +0200
> >> Gregor Jasny <gjasny@googlemail.com> escreveu:
> >>> As far as I understand the service_location feature should work but is
> >>> an extension to the standard. Does it harm if we keep it until we have
> >>> something better in place to handle extensions?
> >>>
> >>> The service list descriptor feature is unimplemented (and thus broken).
> >>> Would it help if we return -1 from dvb_desc_service_list_init to reflect
> >>> that fact or does it break something else? But I'd keep the symbol in
> >>> the library to maintain ABI compatibility.
> >
> >> I would actually prefer if we could get rid of those two broken
> >> descriptors on some release, and to re-add them only when they're
> >> actually working.
> >
> > I have sent a patch series to remove the public headers of this two
> > descriptors and provide stubs to maintain SONAME compatibility.
> >
> > Could you please ACK it?
> 
> About the 1.6.0 release, please do not release it until the series
> fixing the regression in 1.4.0 with gstreamer which I've posted
> today. A review of that series would be appreciated. If you're ok
> with the series feel free to push it to master.

>From my side, I'm happy with the changes made at libdvbv5 side.

I did several changes during this week:

- Added user pages for the 4 dvbv5 tools;
- Cleaned up all Valgrind errors;
- Cleaned up a nasty double-free bug;
- Solved all the issues pointed for it at Coverity.
- Added the package version on all section 1 man pages. Those are now
  created during ./configure.

I also did some tests here with DVB-C and ISDB-T and everything seems to
be working fine.

So, at least from dvbv5 utils and libdvbv5, I think we're ready for
version 1.6.

Regards,
Mauro
