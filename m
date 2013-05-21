Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:35970 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3EUJUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 05:20:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Can you take a look at these dvb-apps warnings/errors?
Date: Tue, 21 May 2013 11:20:18 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201305171030.57794.hverkuil@xs4all.nl> <20130520182215.54e2e3b0@redhat.com>
In-Reply-To: <20130520182215.54e2e3b0@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201305211120.18566.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 20 May 2013 23:22:15 Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Fri, 17 May 2013 10:30:57 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi Mauro,
> > 
> > Can you take a look at these? The daily build is failing because of this.
> > 
> > Thanks!
> > 
> > 	Hans
> > 
> > test_video.c:322:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘ssize_t’ [-Wformat]
> > dvbscan.c:128:6: warning: variable ‘output_type’ set but not used [-Wunused-but-set-variable]
> > dvbscan.c:126:6: warning: variable ‘uk_ordering’ set but not used [-Wunused-but-set-variable]
> > dvbscan.c:124:32: warning: variable ‘inversion’ set but not used [-Wunused-but-set-variable]
> > dvbscan_dvb.c:27:44: warning: unused parameter ‘fe’ [-Wunused-parameter]
> > dvbscan_atsc.c:27:45: warning: unused parameter ‘fe’ [-Wunused-parameter]
> > util.c:193:7: error: ‘SYS_DVBC_ANNEX_A’ undeclared (first use in this function)
> > util.c:194:7: error: ‘SYS_DVBC_ANNEX_C’ undeclared (first use in this function)
> > util.c:262:26: error: ‘DTV_ENUM_DELSYS’ undeclared (first use in this function)
> > util.c:263:1: warning: control reaches end of non-void function [-Wreturn-type]
> > make[2]: *** [util.o] Error 1
> > make[1]: *** [all] Error 2
> > make: *** [all] Error 2
> 
> I'm not touching on dvb-apps for a long time. From my side, all I need in
> terms of userspace apps for DVB is there at dvbv5/libdvbv5 on v4l-utils.
> 
> That's said, from the above errors, it seems that it got added (partial)
> support for DVB v5 but, somehow, it is compiling with an older
> dvb/frontend.h header on your build.
> 
> Regards,
> Mauro
> 

I've running a 3.8 kernel on my daily build server, so that's why those
headers are old. I've manually updated the headers.

Note that dvb-apps has an include directory with old headers as well, but
those headers aren't used anyway it seems.

Should I bother with building dvb-apps at all?

Regards,

	Hans
